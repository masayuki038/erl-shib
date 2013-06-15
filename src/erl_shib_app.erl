-module(erl_shib_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    ok = bootstrap_cowboy:start(),
    erl_shib_sup:start_link().

stop(_State) ->
    ok.
