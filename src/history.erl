-module(history).

-compile(export_all).

-include("history.hrl").

-include_lib("stdlib/include/qlc.hrl").

do_this_once() ->
     ok.

clean_start() ->
    Node = node(),
    mnesia:delete_schema([Node]),
    start().

start() ->
    Node = node(),
    case mnesia:create_schema([Node]) of
        ok -> prepare_db(true, Node);
        {error, {Node, {already_exists, Node}}} ->
            prepare_db(false, Node); 
        _ -> error
    end.

stop() ->
    mnesia:stop().

-spec prepare_db(_, _) -> any().
prepare_db(CreateTables, Node) ->
    ok = mnesia:start(),
    case CreateTables of
        true -> 
	    ok = create_tables(Node);
        false -> ok
     end,
    mnesia:wait_for_tables([history, query_result], 20000).

-spec create_tables(_) -> ok.
create_tables(Node) ->
    mnesia:create_table(history, [{attributes, record_info(fields, history)}, {disc_copies, [Node]}]),
    mnesia:create_table(query_result, [{attributes, record_info(fields, query_result)}, {disc_copies, [Node]}]),
    ok.

-spec delete_tables() -> ok.
delete_tables() ->
    ok = mnesia:delete_table(history),
    ok = mnesia:delete_table(query_result),
    ok.
    
-spec create_history(undefined | [integer()], undefined | binary(), _, _, _) -> history().
create_history(Query_id, Hql, Status, Start_at, End_at) ->
    #history{query_id = Query_id, hql = Hql, status = Status, start_at = Start_at, end_at = End_at}.

-spec get_histories() -> list().
get_histories() ->
    take(20, do(qlc:sort(qlc:q([X || X <- mnesia:table(history)]),[{order,  
        fun(H1, H2) ->
            #history{start_at = Start1} = H1,
            #history{start_at = Start2} = H2,
            Start1 > Start2
        end}])
    )).

take(0, _) -> [];
take(_, []) -> [];
take(N, [X | Xs]) when N > 0 -> [X | take(N-1, Xs)].

-spec get_history(_) -> any().
get_history(Qid) ->
    F = fun() -> mnesia:read({history, Qid}) end,
    {atomic, Val} = mnesia:transaction(F),
    [H|_] = Val,
    H.

-spec update_history(_) -> {aborted, _} | {atomic, _}.
update_history(H) ->
    mnesia:transaction(fun() -> mnesia:write(H) end).

-spec delete_history(_) -> {aborted, _} | {atomic, _}.
delete_history(Qid) ->
    mnesia:transaction(fun() -> mnesia:delete({history, Qid}) end).

-spec create_result(undefined | [integer()], _) -> query_result().
create_result(Query_id, Result) ->
    #query_result{query_id = Query_id, result = Result}.

-spec get_result(_) -> any().
get_result(Qid) ->
    F = fun() -> mnesia:read({query_result, Qid}) end,
    {atomic, Val} = mnesia:transaction(F),
    [H|_] = Val,
    H.

-spec update_result(_) -> {aborted, _} | {atomic, _}.
update_result(R) ->	    	
    mnesia:transaction(fun() -> mnesia:write(R) end).

-spec delete_result(_) -> {aborted, _} | {atomic, _}.
delete_result(Qid) ->	    	
    mnesia:transaction(fun() -> mnesia:delete({query_result, Qid}) end).

-spec do(_) -> any().
do(Q) ->
    F = fun() -> qlc:e(Q) end,
    {atomic, Val} = mnesia:transaction(F),
    Val.
			 
