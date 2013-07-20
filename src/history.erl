-module(history).

-compile(export_all).

-include("history.hrl").

-include_lib("stdlib/include/qlc.hrl").

do_this_once() ->
    mnesia:create_schema([node()]),
    mnesia:start(),   
    mnesia:create_table(history, [{attributes, record_info(fields, history)}]),
    mnesia:create_table(query_result, [{attributes, record_info(fields, query_result)}]),
    mnesia:stop().

start() ->
    mnesia:start(),
    mnesia:wait_for_tables([history], 20000).

create_history(Query_id, Hql, Status, Start_at, End_at) ->
    #history{query_id = Query_id, hql = Hql, status = Status, start_at = Start_at, end_at = End_at}.

update_history(H) ->
    mnesia:transaction(fun() -> mnesia:write(H) end).

get_histories() ->
    do(qlc:sort(qlc:q([X || X <- mnesia:table(history)]),[{order,  
        fun(H1, H2) ->
            #history{end_at = End1} = H1,
            #history{end_at = End2} = H2,
            End1 > End2
        end}])
    ).

get_history(Qid) ->
    F = fun() -> mnesia:read({history, Qid}) end,
    {atomic, Val} = mnesia:transaction(F),
    [H|_] = Val,
    H.

create_result(Query_id, Result) ->
    #query_result{query_id = Query_id, result = Result}.

update_result(R) ->	    	
    mnesia:transaction(fun() -> mnesia:write(R) end).

get_result(Qid) ->
    F = fun() -> mnesia:read({query_result, Qid}) end,
    {atomic, Val} = mnesia:transaction(F),
    [H|_] = Val,
    H.

do(Q) ->
    F = fun() -> qlc:e(Q) end,
    {atomic, Val} = mnesia:transaction(F),
    Val.
			 
