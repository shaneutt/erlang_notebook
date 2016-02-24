-module('erlang_notebook_api_app').
-behaviour(application).
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
  {ok, Pid} = erlang_notebook_api_sup:start_link(),
  %%{ok, _}   = erlang_notebook_api_cache:init(),
  {ok, _}   = cowboy_start(), %% https://github.com/ninenines/cowboy
  {ok, Pid}.

stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================

cowboy_start() ->
  Dispatch = cowboy_router:compile([
    {'_', [
      %% route based on path :named argument is a capture that can be collected with cowboy_req:binding(named, Req)
      {"/",                       erlang_notebook_api_base,   []},
      {"/server",                 erlang_notebook_api_server, list},
      {"/server/:hostname",       erlang_notebook_api_server, get},
      %% [...] is a capture that will send the path contents to the module (in this case erlang_notebook_api_server)
      %% and will be collectable with cowboy_req:path_info(Req)
      {"/server/:hostname/[...]", erlang_notebook_api_server, get}
    ]}
  ]),
  cowboy:start_http(
    http_api,
    100, %% how many nodes to spin up (should default to whatever you think your max will be)
    [{ip, {127,0,0,1}},
    {port, 8081}],
    [{env, [{dispatch, Dispatch}]}]
  ).
