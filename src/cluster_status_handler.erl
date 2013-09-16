-module(cluster_status_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-include("history.hrl").

init(_Transport, Req, []) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    {ok, C0} = hive:get_connection(),
    {_, {ok, R1}} = thrift_client:call(C0, getClusterStatus, []),
    Result = lists:sublist(tuple_to_list(R1), 2, 6),
    Keys = [task_trackers, map_tasks, reduce_tasks, max_map_tasks, max_reduce_tasks, status],
    Zipped = {lists:zip(Keys, Result)},
    lager:info(io_lib:format("Zipped: ~p", [Zipped])),    
    Json = jiffy:encode(Zipped),
    lager:info(io_lib:format("getClusterStatus(R1): ~p", [R1])),
    lager:info(io_lib:format("getClusterStatus(Result): ~p", [Json])),
    {ok, Req2} = cowboy_req:reply(200, [{<<"Content-Type">>, <<"text/plain">>}], Json, Req),
    {ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
    ok.

