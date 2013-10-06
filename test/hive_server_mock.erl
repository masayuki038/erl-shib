-module(hive_server_mock).

-export([start/0, stop/0, handle_function/2]).

-include_lib("eunit/include/eunit.hrl").
-include("queryplan_types.hrl").

start() ->
  {ok, _} = thrift_socket_server:start([{name, mock_server}, {port, 10000}, {service, thriftHive_thrift}, {handler, hive_server_mock}]),
  ok.

stop() ->
    thrift_socket_server:stop(mock_server).

handle_function(Function, Params) ->
    ?debugVal(Function),
    ?debugVal(Params),
    case Function of
	execute ->
	    {reply, Params};
	fetchOne ->
	    {reply, "a\t1"};
	fetchAll ->
	    {reply, ["a\t1", "b\t2", "c\t3", "d\t1", "e\t2", "f\t3", "a\t4", "b\t5"]};
	getQueryPlan ->
	    {reply, #queryPlan{queries = [], done = true, started = true}}
    end.
