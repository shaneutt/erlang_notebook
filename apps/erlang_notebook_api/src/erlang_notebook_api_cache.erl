%% -------------------------------------------------------------------
%% @doc caching!
%% -------------------------------------------------------------------
-module(erlang_notebook_api_cache).
-export([init/0, get/1, set/2]).

%%====================================================================
%% API functions
%%====================================================================

%% TODO - eventually should allow for multiple backends, currently only memcached is supported

%% startup the connection to the cache
init() ->
  mcd:start_link(?MODULE, []).

%% get the value of a key by name
get(Key) ->
  mcd:get(?MODULE, Key).

%% set the value of a key by name
set(Key, Value) ->
  case mcd:set(?MODULE, Key, Value) of
    {ok, Data}                 -> Data;
    {error, {ErrorType, Data}} -> lager:warning("a [~p] occurred: [~p]", [ErrorType, Data])
  end.
