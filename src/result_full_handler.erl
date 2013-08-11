-module(result_full_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-include("history.hrl").

init(_Transport, Req, []) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    {BinaryQid, Req2} = cowboy_req:binding(qid, Req),
    Qid = binary_to_list(BinaryQid),
    error_logger:info_report(io_lib:format("Qid: ~p", [Qid])),
    #query_result{result = Result} = history:get_result(Qid),
    {ok, Req2} = cowboy_req:reply(200, [{<<"Content-Type">>, <<"text/plain">>}], string:join(Result, "\n"), Req),
    {ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
    ok.
