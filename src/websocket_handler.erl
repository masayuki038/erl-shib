-module(websocket_handler).

-behaviour(cowboy_websocket_handler).
-export([init/3]).
-export([websocket_init/3]).
-export([websocket_handle/3]).
-export([websocket_info/3]).
-export([websocket_terminate/3]).

init({tcp, http}, _Req, _Opts) ->
    error_logger:info_report("init/3"),
    {upgrade, protocol, cowboy_websocket}.

websocket_init(_TransportName, Req, _Opts) -> 
    error_logger:info_report("websocket_init/3"),
    erlang:start_timer(1000, self(), <<"Hello!">>),
        {ok, Req, undefined_state}.
 
websocket_handle({text, Msg}, Req, State) ->
    error_logger:info_report("websocket_handle/3a"),
    error_logger:info_report(Msg),
    {reply, {text, << "That's what she said! ", Msg/binary >>}, Req, State};
websocket_handle(_Data, Req, State) ->
    error_logger:info_report("websocket_handle/3b"),
    {ok, Req, State}.
 
websocket_info({timeout, _Ref, Msg}, Req, State) ->
    error_logger:info_report("websocket_info/3a"),
    erlang:start_timer(1000, self(), <<"How' you doin'?">>),
    {reply, {text, Msg}, Req, State};
websocket_info(_Info, Req, State) ->
    error_logger:info_report("websocket_info/3b"),
    {ok, Req, State}.
 
websocket_terminate(_Reason, _Req, _State) -> 
    error_logger:info_report("websocket_terminate/3"),
    ok.
