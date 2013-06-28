-module(history_tests).
-include_lib("eunit/include/eunit.hrl").
-include("history.hrl").

do_this_once_test() ->
    history:do_this_once().

add_history_test() ->
    history:start(),
    H = history:create_history("Test", "select * from tests", 1, "2013-06-29 00:11:23", "2013-06-29 00:14:54"),
    history:add_history(H),
    Histories = history:get_histories(),
    ?assertEqual(1, length(Histories)),
    L = lists:last(Histories),
    #history{query_id = Query_id, hql = Hql, status = Status, start_at = Start_at, end_at = End_at} = L,
    ?assertEqual("Test", Query_id),
    ?assertEqual("select * from tests", Hql),
    ?assertEqual(1, Status),
    ?assertEqual("2013-06-29 00:11:23", Start_at),
    ?assertEqual("2013-06-29 00:14:54", End_at).


