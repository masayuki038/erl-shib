-module(bootstrap_cowboy).

-export([start/0]).

start() ->
    ok = application:start(crypto),
    ok = application:start(ranch),
    ok = application:start(cowboy),
    Dispatch = cowboy_router:compile([
        {'_', [
            {'_', websocket_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_http(sample_http_handler, 100, [{port, 19860}], [{env, [{dispatch, Dispatch}]}]),
    ok.
    
