-module(websocket_handler_tests).
-include_lib("eunit/include/eunit.hrl").

json_test() ->
    %%JsonStr = json:encode([{<<"event">>, <<"query_done">>}, {<<"data">>, {<<"id">>, <<"aaa">>}}]),
    %%JsonStr = json:encode({<<"event">>, <<"query_done">>}),
    %%{ok, JsonStr} = json:encode([1, true, <<"hoge">>]),
    In = {<<"event">>, <<"query_done">>},
    ?debugVal(In),
    {ok, JsonStr} = json:encode(In),
    ?debugVal(JsonStr).
