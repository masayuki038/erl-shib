-module(bootstrap_cowboy).

-export([start/0]).

start() ->
    application:set_env(lager, handlers, [
      {lager_console_backend, info},
      {lager_file_backend, [
        {"error.log", error, 10485760, "$D0", 5},
        {"console.log", info, 10485760, "$D0", 5}
      ]}
    ]),
    ok = econfig:register_config(erl_shib, ["./erl_shib.ini"], [autoreload]),
    true = econfig:subscribe(erl_shib),
    history:do_this_once(),
    history:start(),
    case econfig:get_value(erl_shib, "hive", "type") of
        "hive" ->
            ok;
        "mock" ->
	    ok = hive_server_mock:start()
    end,
    
    Prefix = helper:get_request_prefix(),
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
    
