-module(websocket_handler).

-behaviour(cowboy_websocket_handler).
-export([init/3]).
-export([websocket_init/3]).
-export([websocket_handle/3]).
-export([websocket_info/3]).
-export([websocket_terminate/3]).

-include("history.hrl").

init({tcp, http}, _Req, _Opts) ->
    error_logger:info_report("init/3"),
    {upgrade, protocol, cowboy_websocket}.

websocket_init(_TransportName, Req, _Opts) -> 
    error_logger:info_report("websocket_init/3"),
    {ok, Req, undefined_state}.
 
websocket_handle({text, Msg}, Req, State) ->
    error_logger:info_report("websocket_handle/3a"),
    error_logger:info_report(Msg),
    case jiffy:decode(Msg) of
        {[{<<"event">>, <<"send_query">>}, {<<"data">>, Hql}]} ->
            {ok, Updated} = create_query(Hql),
            erlang:start_timer(1000, self(), Updated),
            #history{query_id = Qid} = Updated,
            error_logger:info_report(io:format("Qid: ~p~n", [Qid])),
            {
                reply, 
                {
                    text, 
                    jiffy:encode({[{event, query_start}, {data, {[{id, list_to_atom(Qid)}]}}]})
                }, 
                Req, State
            };
        _ ->
            {reply, 
             {text, jiffy:encode({[{event, error}, {data, {[{messsage, not_support}]}}]})}, 
             Req, State
            }
    end;
websocket_handle(_Data, Req, State) ->
    error_logger:info_report("websocket_handle/3b"),
    {ok, Req, State}.
 
websocket_info({timeout, _Ref, History}, Req, State) ->
    error_logger:info_report("websocket_info/3a"),
    case execute_query(History) of
        {ok, Updated} ->
            #history{query_id = Qid} = Updated,
            error_logger:info_report(io:format("Qid: ~p~n", [Qid])),
            {
                reply, 
                {
                    text, 
                    jiffy:encode({[{event, query_success}, {data, {[{id, list_to_atom(Qid)}]}}]})
                }, 
                Req, State
            };
        {canceled, Canceled} ->
            #history{query_id = Qid} = Canceled,
            error_logger:info_report(io:format("Qid: ~p~n", [Qid])),
            {
                reply, 
                {
                    text, 
                    jiffy:encode({[{event, query_cancel}, {data, {[{id, list_to_atom(Qid)}]}}]})
                }, 
                Req, State
            };
	{failed, Failed} ->
            #history{query_id = Qid} = Failed,
            error_logger:info_report(io:format("Qid: ~p~n", [Qid])),
            {
                reply, 
                {
                    text, 
                    jiffy:encode({[{event, query_fail}, {data, {[{id, list_to_atom(Qid)}]}}]})
                }, 
                Req, State
            }
    end;           
websocket_info(_Info, Req, State) ->
    error_logger:info_report("websocket_info/3b"),
    {ok, Req, State}.
 
websocket_terminate(_Reason, _Req, _State) -> 
    error_logger:info_report("websocket_terminate/3"),
    ok.

create_query(Hql) ->
    Qid = hive_query:generate_id(Hql, erlang:localtime()),
    error_logger:info_report(io_lib:format("generated id: ~p", [Qid])),
    History = create_history(Qid, Hql),
    {atomic, ok} = history:update_history(History),
    {ok, History}.

execute_query(History) ->
    #history{query_id = Qid, hql = Hql} = History,
    try fetch_all(Qid, Hql) of
        {ok, ResultAsBinary} ->
            LatestHistory = history:get_history(Qid),
            #history{status = LatestStatus} = LatestHistory,
            case LatestStatus of 
                executing -> 
                    Fetched = History#history{status = fetched},
                    {atomic, ok} = history:update_history(Fetched),
                    error_logger:info_report(io_lib:format("ResultAsBinary size: : ~p", [length(ResultAsBinary)])),
                    Results = lists:map(fun(N) -> binary_to_list(N) end, ResultAsBinary),
                    Result = create_result(Qid, Results),
                    {atomic, ok} = history:update_result(Result),
                    Executed = History#history{status = executed, end_at = iso8601:format(erlang:localtime())},
                    {atomic, ok} = history:update_history(Executed),
	            {ok, History};
                canceled ->
                    {canceled, History}
            end
    catch
        _:_ ->
            Report = ["failed to execute query",
                      {method, fetch_all},
                      {stacktrace, erlang:get_stacktrace()}],
	    error_logger:error_report(Report),
            Failed = History#history{status = error, end_at = iso8601:format(erlang:localtime())},
            {atomic, ok} = history:update_history(Failed),
	    {failed, Failed}
    end.

create_history(Qid, Hql) ->
    history:create_history(Qid, Hql, executing, iso8601:format(erlang:localtime()), undefined).

create_result(Qid, Results) ->
    history:create_result(Qid, Results).

fetch_all(Qid, Hql) ->
    {ok, C0} = hive:get_connection(),
    %%true = ets:insert(hive_conn, {Qid, C0}),
    {C1, {ok, _}} = thrift_client:call(C0, execute, [Hql]),
    error_logger:info_report("execute called"),
    {_, {ok, R2}} = thrift_client:call(C1, fetchAll, []),
    error_logger:info_report("fetchAll called"),
    {ok, R2}.
