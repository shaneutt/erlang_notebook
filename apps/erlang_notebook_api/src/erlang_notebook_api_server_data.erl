-module(erlang_notebook_api_server_data).
-export([get/2, list_servers/0]).

%%====================================================================
%% API functions
%%====================================================================

get(Hostname, undefined) when is_binary(Hostname) ->
  get(Hostname, []);
get(Hostname, _PathInfo) when is_binary(Hostname), is_list(_PathInfo) ->
  #{
    <<"host.server1.com">> => <<"192.168.1.2">>
  }.

list_servers() ->
  #{
    <<"host.server1.com">> => <<"192.168.1.2">>,
    <<"host.server2.com">> => <<"192.168.1.3">>
  }.
