-module(history_delete_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-include("history.hrl").

init(_Transport, Req, []) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    {BinaryQid, Req2} = cowboy_req:binding(qid, Req),
    Qid = binary_to_list(BinaryQid),
    {atomic, ok} = history:delete_history(Qid),
    {atomic, ok} = history:delete_result(Qid),
    {ok, Req3} = cowboy_req:reply(200, [], <<"">>, Req2),
    {ok, Req3, State}.

terminate(_Reason, _Req, _State) ->
    ok.
