-module(helper).

-compile(export_all).

get_request_prefix() ->
    PrefixTmp = econfig:get_value(erl_shib, "server", "prefix"),
    case PrefixTmp of 
        undefined -> Prefix = "";
        _ -> Prefix = PrefixTmp
    end,
    lager:info("Prefix ~p", [Prefix]),
    Prefix.    
