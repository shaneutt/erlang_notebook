-module(erlang_notebook_api_server).
-export([init/2]).

%% http://ninenines.eu/docs/en/cowboy/1.0/guide/req_body/

init(Req, list) ->
  List = erlang_notebook_api_server_data:list_servers(),
  Body = jsx:encode(List),
	Req2 = cowboy_req:reply(200, [{<<"content-type">>, <<"text/json">>}], Body, Req),
	{ok, Req2, list};
init(Req, Path) ->
  Hostname = cowboy_req:binding(hostname, Req),
  PathInfo = cowboy_req:path_info(Req),
  Server   = erlang_notebook_api_server_data:get(Hostname, PathInfo),
  Body     = jsx:encode(Server),
	Req2     = cowboy_req:reply(200, [{<<"content-type">>, <<"text/json">>}], Body, Req),
	{ok, Req2, Path}.
