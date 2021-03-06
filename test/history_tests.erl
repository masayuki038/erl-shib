-module(history_tests).
-include_lib("eunit/include/eunit.hrl").
-include("history.hrl").

-export([create_history1/0]).


update_history_test() ->
    history:clean_start(),
    Tests = history:get_histories(),
    ?debugVal(Tests),
    H = create_history1(),
    history:update_history(H),
    Histories = history:get_histories(),
    ?debugVal(Histories),
    ?assertEqual(1, length(Histories)),
    L = lists:last(Histories),
    ?assertEqual(H, L).

update_history2_test() ->
    history:clean_start(),
    H1 = create_history1(),
    H2 = create_history2(),
    history:update_history(H1),
    history:update_history(H2),
    Histories = history:get_histories(),
    ?assertEqual(2, length(Histories)),
    [F, L] = Histories,
    ?assertEqual(H1, F),
    ?assertEqual(H2, L).

get_history_test() ->
    history:clean_start(),
    H = create_history1(),
    history:update_history(H),
    L = history:get_history(H#history.query_id),
    ?assertEqual(H, L).

update_test() ->
    history:clean_start(),
    H = create_history1(),
    history:update_history(H),
    H2 = H#history{hql = <<"select * from tests2">>},
    %?debugVal(H2),
    history:update_history(H2),
    L = history:get_history(H2#history.query_id),
    #history{hql = Hql} = L,
    ?assertEqual(<<"select * from tests2">>, Hql).

histories_to_json_test() ->
    history:clean_start(),
    H1 = create_history1(),
    H2 = create_history2(),
    history:update_history(H1),
    history:update_history(H2),
    Histories = history:get_histories(),
    %%?debugVal(Histories),
    Structured = lists:map(fun(History) -> ?record_to_struct(history, History) end, Histories),
    %%?debugVal(Structured),
    Json = jiffy:encode(Structured),   
    lager:info(Json).
    
create_history1() ->
    history:create_history(hive_query:generate_id(<<"Test1">>, erlang:localtime()), <<"select * from test">>, 1, iso8601:format({{2013, 6, 30}, {19, 38, 22}}), iso8601:format({{2013, 6, 29}, {19, 39, 41}})).

create_history2() ->
    history:create_history(hive_query:generate_id(<<"Test2">>, erlang:localtime()), <<"select * from test">>, 1, iso8601:format({{2013, 6, 29}, {19, 38, 21}}), iso8601:format({{2013, 6, 29}, {19, 39, 42}})).
    
