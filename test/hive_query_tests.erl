-module(hive_query_tests).
-include_lib("eunit/include/eunit.hrl").

md5_test() ->
    Hql = "select * from test",
    Seed = "20130625022913243",
    Qid = hive_query:generate_id(Hql, Seed),
    ?assertEqual("859b801ad03b90772738fe3f3dc2b687", Qid).
