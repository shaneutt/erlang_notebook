%%%-------------------------------------------------------------------
%% @doc erlang_notebook_gen_server top level supervisor.
%% @end
%%%-------------------------------------------------------------------
-module(erlang_notebook_gen_server_sup).
-behaviour(supervisor).
-export([start_link/0]). %% API
-export([init/1]).       %% Supervisor callbacks
-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

%% called from app:start
start_link() -> supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% child macro used to simplify the child definition in init
-define(CHILD(Module, Args), %% how to call the macro (?CHILD(name_of_module, Args))
  #{
    id    => Module, %% the id you want to give the child (name of the module)
    start => {       %% how to start the child
      Module,        %% which module to call
      start_link,    %% which function in the Module to call
      Args           %% function arguments
    }}).
init([]) ->
    %% this is the old method: {ok, { {one_for_all, 0, 1}, []} }.
    %% the new way is:         Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
    %%
    %% the following is the new hashmap method:
    {ok, {
      #{
        %% http://erlang.org/doc/design_principles/sup_princ.html
        %%
        %% in this case we want a simple_one_for_one that allows a maximum restart
        %% intensity of 5 restarts for a 10 second period.
        strategy  => simple_one_for_one, %% failover strategy (optional)
        intensity => 5,                  %% how many restarts to allow in "period" (optional)
        period    => 10                  %% period (in seconds) (optional)
      },
      [
        %% use our above macro to define the ChildSpecs
        ?CHILD(erlang_notebook_gen_server_worker, []) %% child definition
      ]
    }}.

%%====================================================================
%% Internal functions
%%====================================================================
