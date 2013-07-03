-module(history_tests).
-include_lib("eunit/include/eunit.hrl").
-include("history.hrl").

do_this_once_test() ->
    history:do_this_once().

update_history_test() ->
    history:do_this_once(),
    history:start(),
    H = create_history1(),
    history:update_history(H),
    Histories = history:get_histories(),
    ?assertEqual(1, length(Histories)),
    L = lists:last(Histories),
    ?assertEqual(H, L).

update_history2_test() ->
    history:do_this_once(),
    history:start(),
    H1 = create_history1(),
    H2 = create_history2(),
    history:update_history(H1),
    history:update_history(H2),
    Histories = history:get_histories(),
    ?assertEqual(2, length(Histories)),
    [F, L] = Histories,
    ?assertEqual(H2, F),
    ?assertEqual(H1, L).

get_history_test() ->
    history:do_this_once(),
    history:start(),
    H = create_history1(),
    history:update_history(H),
    Histories = history:get_history("Test1"),
    ?assertEqual(1, length(Histories)),
    L = lists:last(Histories),
    ?assertEqual(H, L).

update_test() ->
    history:do_this_once(),
    history:start(),
    H = create_history1(),
    history:update_history(H),
    H2 = H#history{hql = "select * from tests2"},
    ?debugVal(H2),
    history:update_history(H2),
    Histories = history:get_history("Test1"),
    ?assertEqual(1, length(Histories)),
    L = lists:last(Histories),
    #history{hql = Hql} = L,
    ?assertEqual("select * from tests2", Hql).

create_history1() ->
    history:create_history("Test1", "select * from tests", 1, {{2013, 6, 29}, {19, 38, 22}}, {{2013, 6, 29}, {19, 39, 41}}).
    
create_history2() ->
    history:create_history("Test2", "select * from tests", 1, {{2013, 6, 29}, {19, 38, 21}}, {{2013, 6, 29}, {19, 39, 42}}).
    