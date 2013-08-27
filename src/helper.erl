-module(helper).

-compile(export_all).

get_request_prefix() ->
    PrefixTmp = econfig:get_value(erl_shib, "server", "prefix"),
    case PrefixTmp of 
        undefined -> Prefix = "";
        _ -> Prefix = PrefixTmp
    end,
    error_logger:info_report("Prefix ~p", [Prefix]),
    Prefix.    
