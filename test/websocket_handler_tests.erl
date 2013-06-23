-module(websocket_handler_tests).
-include_lib("eunit/include/eunit.hrl").

json_encode1_test() ->
    In = {[{event, query_done}, {data, [aaa, bbb, ccc]}]},
    JsonStr = jiffy:encode(In),
    ?assertEqual(<<"{\"event\":\"query_done\",\"data\":[\"aaa\",\"bbb\",\"ccc\"]}">>, JsonStr).

json_encode2_test() ->
    In = {[{event, query_done}, {data, {[{id, aaa}]}}]},
    JsonStr = jiffy:encode(In),
    ?debugVal(JsonStr),
    ?assertEqual(<<"{\"event\":\"query_done\",\"data\":{\"id\":\"aaa\"}}">>, JsonStr).
