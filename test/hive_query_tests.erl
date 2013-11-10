-module(hive_query_tests).
-include_lib("eunit/include/eunit.hrl").

md5_test() ->
    Hql = <<"select * from test">>,
    Seed = {{2013,7, 13}, {11, 44, 33}},
    Qid = hive_query:generate_id(Hql, Seed),
    ?assertEqual("d13905dae94f1443a6fb542190891498", Qid).

tuple_to_list_recursively1_test() ->
    TupleToListR = hive_query:tuple_to_list_deeply({{2013, 7, 13}, {11, 44, 33}}),
    ?assertEqual("2013713114433", TupleToListR).
