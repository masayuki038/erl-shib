-module(tsv_download_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-include("history.hrl").

init(_Transport, Req, []) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    {BinaryQid, Req2} = cowboy_req:binding(qid, Req),
    Qid = binary_to_list(BinaryQid),
    lager:info(io_lib:format("Qid: ~p", [Qid])),
    Filename = io_lib:format("attachment; filename=~p.tsv", [Qid]),
    #query_result{result = Result} = history:get_result(Qid),
    ResultAsText = string:join(Result, "\n"),
    {ok, Req3} = cowboy_req:reply(200, [{<<"Content-Type">>, <<"text/tab-separated-values">>}, {<<"Content-Disposition">>, list_to_binary(Filename)}], ResultAsText, Req2),
    {ok, Req3, State}.

terminate(_Reason, _Req, _State) ->
    ok.
