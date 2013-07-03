-module(thrift_hive).

-include("hive_service_types.hrl").
-include("thriftHive_thrift.hrl").

-export([fetch_one/1, fetch_all/1, fetch_all_async/1, get_cluster_status/0, get_query_plan/0]).

fetch_one(Hql) ->
    {ok, C0} = get_connection(),
    {C1, {ok, _}} = thrift_client:call(C0, execute, [Hql]),
    {_, {ok, R2}} = thrift_client:call(C1, fetchOne, []),
    Ret = binary_to_list(R2),
    {ok, Ret}.

fetch_all(Hql) ->
    {ok, C0} = get_connection(),
    {C1, {ok, _}} = thrift_client:call(C0, execute, [Hql]),
    {_, {ok, R2}} = thrift_client:call(C1, fetchAll, []),
    Ret = lists:map(fun(N) -> binary_to_list(N) end, R2),
    {ok, Ret}.

fetch_all_async(Hql) ->
    {ok, C0} = get_connection(),
    {C1, ok} = thrift_client:send_call(C0, execute, [Hql]),
    {_, {ok, R1}} = thrift_client:call(C1, getQueryPlan, []),
    {ok, R1}.

get_cluster_status() ->
    {ok, C0} = get_connection(),
    {_, {ok, R1}} = thrift_client:call(C0, getClusterStatus, []),
    {ok, R1}.

get_query_plan() ->
    {ok, C0} = get_connection(),
    {_, {ok, R1}} = thrift_client:call(C0, getQueryPlan, []),
    {ok, R1}.

get_connection() ->
    thrift_client_util:new("127.0.0.1", 10000, thriftHive_thrift, []).
