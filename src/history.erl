-module(history).

-compile(export_all).

-include("history.hrl").

-include_lib("stdlib/include/qlc.hrl").

do_this_once() ->
     ok.

start() ->
    Node = node(),
    case mnesia:create_schema([Node]) of
        ok -> prepare_db(true, Node);
        {error, {Node, {already_exists, Node}}} ->
            prepare_db(false, Node);
        _ -> error
    end.

prepare_db(First, Node) ->
    ok = mnesia:start(),
    case First of
        true -> 
	    ok = create_tables(Node);
        _ -> ok
    end,
    mnesia:wait_for_tables([history, query_result], 20000).

create_tables(Node) ->
    mnesia:create_table(history, [{attributes, record_info(fields, history)}, {disc_copies, [Node]}]),
    mnesia:create_table(query_result, [{attributes, record_info(fields, query_result)}, {disc_copies, [Node]}]),
    ok.
    

create_history(Query_id, Hql, Status, Start_at, End_at) ->
    #history{query_id = Query_id, hql = Hql, status = Status, start_at = Start_at, end_at = End_at}.

update_history(H) ->
    mnesia:transaction(fun() -> mnesia:write(H) end).

get_histories() ->
    do(qlc:sort(qlc:q([X || X <- mnesia:table(history)]),[{order,  
        fun(H1, H2) ->
            #history{start_at = Start1} = H1,
            #history{start_at = Start2} = H2,
            Start1 > Start2
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
			 
