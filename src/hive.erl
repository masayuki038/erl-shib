-module(hive).

-compile(export_all).

get_connection() ->
    Host = econfig:get_value(erl_shib, "hive", "host"),
    Port = econfig:get_value(erl_shib, "hive", "port"),
    lager:info(io:format("Host: ~p~n", [Host])),
    lager:info(io:format("Port: ~p~n", [Port])),
    thrift_client_util:new(Host, list_to_integer(Port), thriftHive_thrift, []).
