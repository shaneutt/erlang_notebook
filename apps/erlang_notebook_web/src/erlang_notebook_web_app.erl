%%%-------------------------------------------------------------------
%% @doc erlang_notebook_web public API
%% @end
%%%-------------------------------------------------------------------

-module(erlang_notebook_web_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    {ok, Pid} = erlang_notebook_web_sup:start_link(),
    {ok, _}   = cowboy_start(),
    {ok, Pid}.

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================

cowboy_start() ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/",             erlang_notebook_web_page,   index},
            {"/static/[...]", cowboy_static,              {priv_dir, erlang_notebook_web, "static"}},
            {"/[...]",        cowboy_static,              {priv_dir, erlang_notebook_web, "pages"}}
        ]}
    ]),
    cowboy:start_http(
        http,
        100, %% number of ranch listeners
        [{ip, {127,0,0,1}},
        {port, 8080}],
        [{env, [{dispatch, Dispatch}]}]
    ).
