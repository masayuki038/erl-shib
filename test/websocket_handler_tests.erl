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
