-module(websocket_handler_tests).
-include_lib("eunit/include/eunit.hrl").
-include("history.hrl").

json_encode1_test() ->
    In = {[{event, query_done}, {data, [aaa, bbb, ccc]}]},
    JsonStr = jiffy:encode(In),
    ?assertEqual(<<"{\"event\":\"query_done\",\"data\":[\"aaa\",\"bbb\",\"ccc\"]}">>, JsonStr).

json_encode2_test() ->
    In = {[{event, query_done}, {data, {[{id, aaa}]}}]},
    JsonStr = jiffy:encode(In),
    ?debugVal(JsonStr),
    ?assertEqual(<<"{\"event\":\"query_done\",\"data\":{\"id\":\"aaa\"}}">>, JsonStr).

json_decode_test() ->
    In = <<"{\"event\":\"query_start\",\"data\":\"dsdsddddf\"}">>,
    {[{_, _}, {_, Data}]} = jiffy:decode(In),
    ?assertEqual(<<"dsdsddddf">>, Data).

date_format_test() ->
    In = {{2013, 7, 18}, {1,26,44}},
    ?assertEqual(<<"2013-07-18T01:26:44Z">>, iso8601:format(In)). 

date_parse_test() ->
    In = <<"2013-07-18T01:26:44Z">>,
    ?assertEqual({{2013, 7, 18}, {1, 26, 44}}, iso8601:parse(In)).

on_executed_test_() ->
    {setup, fun start_mnesia/0, fun stop_mnesia/1, 
     fun() ->
             TestHistory = history_tests:create_history1(),
             Results = ["a\t1", "b\t2", "c\t3"],
             {ok, Executed} = websocket_handler:on_executed(Results, TestHistory),
             #history{query_id = Qid, status = Status} = Executed,
             ?assertEqual(executed, Status),
             #query_result{result = StoredResults} = history:get_result(Qid),
             ?assertEqual(Results, StoredResults)
     end
    }.

execute_query_test_() ->
    {setup, fun start_all/0, fun stop_all/1,
     fun() ->
             TestHistory = history_tests:create_history1(),
             Executing = TestHistory#history{status = executing},
             {atomic, ok} = history:update_history(Executing),
             {ok, Executed} = websocket_handler:execute_query(TestHistory),
             #history{query_id = Qid, status = Status} = Executed,
             ?assertEqual(executed, Status)
     end
    }.

start_all() ->
    ok = application:start(gproc),
    ok = application:start(econfig),
    ok = econfig:register_config(erl_shib, ["../erl_shib.ini"], [autoreload]),    
    true = econfig:subscribe(erl_shib),
    start_mnesia().

stop_all(_Result) ->
    stop_mnesia(_Result),
    ok = application:stop(econfig),
    ok = application:stop(gproc),
    ok.

start_mnesia() ->
    history:do_this_once(),
    history:start(),    
    ok.

stop_mnesia(_Result) ->
    history:stop(),
    ok.
   
