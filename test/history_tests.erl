-module(history_tests).
-include_lib("eunit/include/eunit.hrl").
-include("history.hrl").

do_this_once_test() ->
    history:do_this_once().

add_history_test() ->
    history:do_this_once(),
    history:start(),
    H = create_history1(),
    history:add_history(H),
    Histories = history:get_histories(),
    ?assertEqual(1, length(Histories)),
    L = lists:last(Histories),
    ?assertEqual(H, L).
%    #history{query_id = Query_id, hql = Hql, status = Status, start_at = Start_at, end_at = End_at} = L,
%    ?assertEqual("Test", Query_id),
%    ?assertEqual("select * from tests", Hql),
%    ?assertEqual(1, Status),
%    ?assertEqual({{2013, 6, 29}, {19, 38, 22}}, Start_at),
%    ?assertEqual({{2013, 6, 29}, {19, 39, 41}}, End_at).

add_history2_test() ->
    history:do_this_once(),
    history:start(),
    H1 = create_history1(),
    H2 = create_history2(),
    history:add_history(H1),
    history:add_history(H2),
    Histories = history:get_histories(),
    ?assertEqual(2, length(Histories)),
    [F, L] = Histories,
    ?assertEqual(H2, F),
    ?assertEqual(H1, L).

create_history1() ->
    history:create_history("Test1", "select * from tests", 1, {{2013, 6, 29}, {19, 38, 22}}, {{2013, 6, 29}, {19, 39, 41}}).
    
create_history2() ->
    history:create_history("Test2", "select * from tests", 1, {{2013, 6, 29}, {19, 38, 21}}, {{2013, 6, 29}, {19, 39, 42}}).
    
