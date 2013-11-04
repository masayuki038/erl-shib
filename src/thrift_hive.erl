-module(thrift_hive).

-include("hive_service_types.hrl").
-include("thriftHive_thrift.hrl").

-export([fetch_one/1, fetch_all/1, fetch_all_async/1, get_cluster_status/0, get_query_plan/0]).

-spec fetch_one(string()) -> {ok, list()}.
fetch_one(Hql) ->
    {ok, C0} = hive:get_connection(),
    {C1, {ok, _}} = thrift_client:call(C0, execute, [Hql]),
    {_, {ok, R2}} = thrift_client:call(C1, fetchOne, []),
    Ret = binary_to_list(R2),
    {ok, Ret}.

-spec fetch_all(_) -> {ok, [list()]}.
fetch_all(Hql) ->
    {ok, C0} = hive:get_connection(),
    {C1, {ok, _}} = thrift_client:call(C0, execute, [Hql]),
    {_, {ok, R2}} = thrift_client:call(C1, fetchAll, []),
    Ret = lists:map(fun(N) -> binary_to_list(N) end, R2),
    {ok, Ret}.

-spec fetch_all_async(_) -> {ok, _}.
fetch_all_async(Hql) ->
    {ok, C0} = hive:get_connection(),
    {C1, ok} = thrift_client:send_call(C0, execute, [Hql]),
    {_, {ok, R1}} = thrift_client:call(C1, getQueryPlan, []),
    {ok, R1}.

-spec get_cluster_status() -> {ok, _}.
get_cluster_status() ->
    {ok, C0} = hive:get_connection(),
    {_, {ok, R1}} = thrift_client:call(C0, getClusterStatus, []),
    {ok, R1}.

-spec get_query_plan() -> {ok, _}.
get_query_plan() ->
    {ok, C0} = hive:get_connection(),
    {_, {ok, R1}} = thrift_client:call(C0, getQueryPlan, []),
    {ok, R1}.
