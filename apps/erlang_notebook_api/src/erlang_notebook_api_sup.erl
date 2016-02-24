%%%-------------------------------------------------------------------
%% @doc erlang_notebook_api top level supervisor.
%% @end
%%%-------------------------------------------------------------------
-module('erlang_notebook_api_sup').
-behaviour(supervisor).
-export([start_link/0]). %% API
-export([init/1]).       %% Supervisor callbacks
-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    {ok, { {one_for_all, 0, 1}, []} }.
