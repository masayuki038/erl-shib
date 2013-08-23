-module(hive).

-compile(export_all).

get_connection() ->
    Host = econfig:get_value(erl_shib, "hive", "host"),
    Port = econfig:get_value(erl_shib, "hive", "port"),
    error_logger:info_report(io:format("Host: ~p~n", [Host])),
    error_logger:info_report(io:format("Port: ~p~n", [Port])),
    thrift_client_util:new(Host, list_to_integer(Port), thriftHive_thrift, []).
