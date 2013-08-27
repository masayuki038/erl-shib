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
    Prefix = econfig:get_value(erl_shib, "server", "prefix"),
    Dispatch = cowboy_router:compile([
        {'_', [
            {Prefix ++ "/", toppage_handler, []},
            {Prefix ++ "/websocket", websocket_handler, []},
            {Prefix ++ "/histories", history_handler, []},
            {Prefix ++ "/cluster/status", cluster_status_handler, []},
            {Prefix ++ "/query/cancel/:qid", query_cancel_handler, []},
            {Prefix ++ "/history/delete/:qid", history_delete_handler, []},
            {Prefix ++ "/result/full/:qid", result_full_handler, []},
            {Prefix ++ "/result/head/:qid", result_head_handler, []},
            {Prefix ++ "/download/csv/:qid", csv_download_handler, []},
            {Prefix ++ "/download/tsv/:qid", tsv_download_handler, []},
            {Prefix ++ "/static/[...]", cowboy_static, [
                {directory, {priv_dir, erl_shib, [<<"static">>]}},
                {mimetypes, {fun mimetypes:path_to_mimes/2,default}}
            ]}
        ]}
    ]),
    Port = econfig:get_value(erl_shib, "server", "port"),
    {ok, _} = cowboy:start_http(sample_http_handler, 100, [{port, list_to_integer(Port)}], [{env, [{dispatch, Dispatch}]}]),
    ok.
    
