-module(erlang_notebook_gen_server_worker).
-behaviour(gen_server). %% http://learnyousomeerlang.com/clients-and-servers
-define(SERVER, ?MODULE).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/1]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

%% {ok, Worker} = supervisor:start_child(erlang_notebook_gen_server_sup, [self()]).
start_link(Pid) ->
    gen_server:start_link(?MODULE, Pid, []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

%% The first one is an init/1 function.
%% It is similar to the one we've used with my_server in that it is
%% used to initialize the server's state and do all of these one-time
%% tasks that it will depend on. The function can return {ok, State},
%% {ok, State, TimeOut}, {ok, State, hibernate}, {stop, Reason} or ignore.
init(Args) -> {ok, Args}.

%% synchronous requests
%%
%% gen_server:call(Worker, Args).
handle_call(_Request, _From, State) -> {reply, ok, State}.

%% asyncronous requests
%%
%% gen_server:cast(Worker, Args).
handle_cast(_Msg, State) -> {noreply, State}.

%% handle messages sent with ! (asyncronously)
%%
%% Worker ! Message
handle_info(_Info, State) -> {noreply, State}.

%% called when handle_call, handle_cast, or handle_info returns a tuple of
%% the form {stop, Reason, NewState} or {stop, Reason, Reply, NewState}.
%% (also called when the parent dies if gen_server is trapping exits)
terminate(_Reason, _State) -> ok.

%% The function code_change/3 is there to let you upgrade code.
%% It takes the form code_change(PreviousVersion, State, Extra).
%% Here, the variable PreviousVersion is either the version term
%% itself in the case of an upgrade (read More About Modules again
%% if you forget what this is), or {down, Version} in the case of
%% a downgrade (just reloading older code).
%%
%% The State variable holds all of the current's server state so you can convert it.
code_change(_OldVsn, State, _Extra) -> {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------
