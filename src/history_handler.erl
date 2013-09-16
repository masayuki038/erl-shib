-module(history_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-include("history.hrl").

init(_Transport, Req, []) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    Histories = history:get_histories(),
    lager:info(io_lib:format("Histories: ~p", [length(Histories)])),    
    Structured = lists:map(fun(History) -> ?record_to_struct(history, History) end, Histories),
    Json = jiffy:encode(Structured),
    {ok, Req2} = cowboy_req:reply(200, [{<<"Content-Type">>, <<"application/json">>}], Json, Req),
    {ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
    ok.
