-module(bootstrap_cowboy).

-export([start/0]).

start() ->
    ok = application:start(crypto),
    ok = application:start(ranch),
    ok = application:start(cowboy),
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", toppage_handler, []},
            {"/websocket", websocket_handler, []},
            {"/static/[...]", cowboy_static, [
                {directory, {priv_dir, erl_shib, [<<"static">>]}},
                {mimetypes, {fun mimetypes:path_to_mimes/2,default}}
            ]}
        ]}
    ]),
    {ok, _} = cowboy:start_http(sample_http_handler, 100, [{port, 8080}], [{env, [{dispatch, Dispatch}]}]),
    ok.
    
