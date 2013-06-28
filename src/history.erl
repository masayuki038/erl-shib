-module(history).

-compile(export_all).

-include("history.hrl").

-include_lib("stdlib/include/qlc.hrl").

do_this_once() ->
    mnesia:create_schema([node()]),
    mnesia:start(),   
    mnesia:create_table(history, [{attributes, record_info(fields, history)}]),
    mnesia:stop().

start() ->
    mnesia:start(),
    mnesia:wait_for_tables([history], 20000).

create_history(Query_id, Hql, Status, Start_at, End_at) ->
    #history{query_id = Query_id, hql = Hql, status = Status, start_at = Start_at, end_at = End_at}.

add_history(H) ->
    mnesia:transaction(fun() -> mnesia:write(H) end).

get_histories() ->
    do(qlc:q([X || X <- mnesia:table(history)])).

do(Q) ->
    F = fun() -> qlc:e(Q) end,
    {atomic, Val} = mnesia:transaction(F),
    Val.
			 
