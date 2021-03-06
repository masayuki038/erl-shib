-module(thrift_hive_tests).
-include_lib("eunit/include/eunit.hrl").
-export([start/0]).
-export([stop/1]).

fetchOne_test_() ->
    {timeout, 1200,
     {setup, fun start/0, fun stop/1,
      ?_assertEqual(
         {ok, "a\t1"}, 
         begin thrift_hive:fetch_one("select * from test") end
        )}
     }.

fetchAll_test_() ->
    {timeout, 1200,
     {setup, fun start/0, fun stop/1,
      fun() ->
              {ok, Lst} = thrift_hive:fetch_all("select * from test"),
              ?assertEqual(["a\t1", "b\t2", "c\t3", "d\t1", "e\t2", "f\t3", "a\t4", "b\t5"], Lst)
      end}
     }.

getClusterStatus_test_() -> 
    {timeout, 1200,
     {setup, fun start/0, fun stop/1, 
      fun() ->
              {ok, Ret} = thrift_hive:get_cluster_status(),
              ?assertEqual({hiveClusterStatus, 1, 1, 1, 1, 1, 1}, Ret)
      end}
    }.

start() ->
    ok = application:start(gproc),
    ok = application:start(econfig),
    ok = econfig:register_config(erl_shib, ["../erl_shib.ini"], [autoreload]),    
    true = econfig:subscribe(erl_shib),
    ok = hive_server_mock:start().

stop(_Result) ->
    ok = hive_server_mock:stop(),
    ok = application:stop(econfig),
    ok = application:stop(gproc),
    ok.
    
