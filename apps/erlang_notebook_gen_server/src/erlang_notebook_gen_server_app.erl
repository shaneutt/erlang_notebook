%%%-------------------------------------------------------------------
%% @doc erlang_notebook_gen_server public API
%% @end
%%%-------------------------------------------------------------------
-module(erlang_notebook_gen_server_app).
-behaviour(application).
-export([start/2, stop/1]). %% Application callbacks

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    erlang_notebook_gen_server_sup:start_link().

stop(_State) ->
    ok.
