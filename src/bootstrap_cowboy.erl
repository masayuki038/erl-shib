-module(bootstrap_cowboy).

-export([start/0]).

start() ->
    ok = application:start(crypto),
    ok = application:start(ranch),
    ok = application:start(cowboy),
    ok = application:start(gproc),
    ok = application:start(econfig),
    ok = econfig:register_config(erl_shib, ["./erl_shib.ini"], [autoreload]),
    true = econfig:subscribe(erl_shib),
    history:do_this_once(),
    history:start(),    
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", toppage_handler, []},
            {"/websocket", websocket_handler, []},
            {"/histories", history_handler, []},
            {"/cluster/status", cluster_status_handler, []},
            {"/result/full/:qid", result_full_handler, []},
            {"/result/head/:qid", result_head_handler, []},
            {"/download/csv/:qid", csv_download_handler, []},
            {"/download/tsv/:qid", tsv_download_handler, []},
            {"/static/[...]", cowboy_static, [
                {directory, {priv_dir, erl_shib, [<<"static">>]}},
                {mimetypes, {fun mimetypes:path_to_mimes/2,default}}
            ]}
        ]}
    ]),
    Port = econfig:get_value(erl_shib, "server", "port"),
    {ok, _} = cowboy:start_http(sample_http_handler, 100, [{port, list_to_integer(Port)}], [{env, [{dispatch, Dispatch}]}]),
    ok.
    
