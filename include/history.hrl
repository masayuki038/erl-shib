-record(history, {query_id :: [integer()], hql :: binary(), status, start_at, end_at}).
-type history()::#history{}.

-record(query_result, {query_id :: [integer()], result}).
-type query_result()::#query_result{}.

-define(record_to_struct(RecordName, Record),
  {lists:zip(
      lists:map(fun(F) -> list_to_binary(atom_to_list(F)) end, record_info(fields, RecordName)),
      lists:map(
        fun(undefined) ->
		null;
           (E) when is_binary(E) -> 
                list_to_atom(binary_to_list(E));
           (E) when is_list(E) ->
                list_to_atom(E);
           (E) -> E
        end,
        tl(tuple_to_list(Record))
      )
    )
  }
).
