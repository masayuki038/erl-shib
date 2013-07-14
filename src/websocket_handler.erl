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
    %%erlang:start_timer(1000, self(), <<"Hello!">>),
    {ok, Req, undefined_state}.
 
websocket_handle({text, Msg}, Req, State) ->
    error_logger:info_report("websocket_handle/3a"),
    error_logger:info_report(Msg),
    case jiffy:decode(Msg) of
        {[{<<"event">>, <<"query_start">>}, {<<"data">>, Hql}]} ->
            {ok, Updated} = execute_query(Hql),
            #history{query_id = Qid} = Updated,
            error_logger:info_report(io:format("Qid: ~p~n", [Qid])),
            {reply, 
             {text, jiffy:encode({[{event, query_success}, {data, {[{id, list_to_atom(Qid)}]}}]})}, 
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
 
websocket_info({timeout, _Ref, Msg}, Req, State) ->
    error_logger:info_report("websocket_info/3a"),
    %%erlang:start_timer(1000, self(), <<"How' you doin'?">>),
    {reply, {text, Msg}, Req, State};
websocket_info(_Info, Req, State) ->
    error_logger:info_report("websocket_info/3b"),
    {ok, Req, State}.
 
websocket_terminate(_Reason, _Req, _State) -> 
    error_logger:info_report("websocket_terminate/3"),
    ok.

execute_query(Hql) ->
    Qid = hive_query:generate_id(Hql, erlang:localtime()),
    History = create_history(Qid, Hql),
    history:update_history(History),
    {ok, Results} = fetch_all(Hql),
    %io:format("~p", [lists:map(fun(N) -> binary_to_list(N) end, Results)]),
    Updated = History#history{results = Results, end_at = erlang:localtime()},
    history:update_history(Updated),
    {ok, Updated}.

create_history(Qid, Hql) ->
    #history{query_id = Qid, hql = Hql, status = prepare, start_at = erlang:localtime()}.

fetch_all(Hql) ->
    {ok, C0} = get_connection(),
    {C1, {ok, _}} = thrift_client:call(C0, execute, [Hql]),
    {_, {ok, R2}} = thrift_client:call(C1, fetchAll, []),
    %Ret = lists:map(fun(N) -> binary_to_list(N) end, R2),
    {ok, R2}.

get_connection() ->
    Host = econfig:get_value(erl_shib, "hive", "host"),
    Port = econfig:get_value(erl_shib, "hive", "port"),
    error_logger:info_report(io:format("Host: ~p~n", [Host])),
    error_logger:info_report(io:format("Port: ~p~n", [Port])),
    thrift_client_util:new(Host, list_to_integer(Port), thriftHive_thrift, []).

