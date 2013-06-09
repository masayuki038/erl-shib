-module(thrift_hive_tests).
-include_lib("eunit/include/eunit.hrl").

fetchOne_test_() ->
    {timeout, 1200, 
    ?_assertEqual(
        {ok, "a\t 1"}, 
        begin thrift_hive:fetch_one("select * from test") end
    )}.

fetchAll_test_() ->
    {timeout, 1200,
    fun() ->
        {ok, Lst} = thrift_hive:fetch_all("select * from test"),
        ?assertEqual(["a\t 1", "b\t 2", "c\t 3", "d\t 1", "e\t 2", "f\t 3", "a\t 4", "b\t 5"], Lst)
    end}.
    
