-module(hive_query).

-export([generate_id/2]).
-export([tuple_to_list_deeply/1]).

-spec generate_id(binary(), _) -> [integer()]. 
generate_id(Hql, Seed) ->
    Md5_bin = erlang:md5(lists:concat([binary_to_list(Hql), ";", tuple_to_list_deeply(Seed)])),
    Md5_list = binary_to_list(Md5_bin),
    lists:flatten(list_to_hex(Md5_list)).

-spec list_to_hex([byte()]) -> [[integer(),...]].
list_to_hex(L) ->
    lists:map(fun(X) -> int_to_hex(X) end, L).

int_to_hex(N) when N < 256 ->
    [hex(N div 16), hex(N rem 16)].

hex(N) when N < 10 ->
    $0 + N;
hex(N) when N >= 10, N < 16 ->
    $a + (N-10).
		      
tuple_to_list_deeply([]) -> [];
tuple_to_list_deeply(T) when is_tuple(T) ->
    tuple_to_list_deeply(tuple_to_list(T));
tuple_to_list_deeply([H|L]) ->
    lists:concat([tuple_to_list_deeply(H), tuple_to_list_deeply(L)]);
tuple_to_list_deeply(T) ->
    T.
