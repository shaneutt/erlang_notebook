-module(erlang_notebook_mnesia_db).
-export([init/0, get_item/0, set_item/0]).
-export_type([erlang_notebook_item/0]).
-define(TABLENAME, erlang_notebook_config).
-define(INTERVAL, 300000).

%%====================================================================
%% API functions for setup and initialization
%%====================================================================

-type erlang_notebook_item() :: binary().

-spec init() -> ok.

init() ->
  Nodes = application:get_env(erlang_notebook, nodes, [node()]),
  % add our Nodes to the mnesia database over the network
  mnesia:change_config(extra_db_nodes, Nodes),
  % check to see if the table we're looking for exists already in mnesia across all Nodes
  TableExists = lists:member(erlang_notebook_config, mnesia:system_info(tables)),
  if
    % if the table already exists in the cluster, one of our Nodes has already created it and
    % we can simply add a copy of the existing table to this node()
    TableExists -> mnesia:add_table_copy(erlang_notebook_config, node(), ram_copies);
    % if the table doesn't exist then we are the first node() here and we should create the table
    not TableExists -> mnesia:create_table(erlang_notebook_config, [{ram_copies, Nodes}])
  end,
  % ensure that the schemas sync properly, and wait for them to sync
  ok = mnesia:wait_for_tables([schema, erlang_notebook_config], 10000),
  % for this test app we're just going to add new random data every once in a while
  timer:apply_after(?INTERVAL, erlang_notebook_mnesia_db, set_item, []),
  ok.

%%====================================================================
%% API functions for setting and retrieving data
%%====================================================================

-spec get_item() -> {ok, erlang_notebook_item()} | {error, noitem}.

get_item() ->
  % mnesia queries are anonymous functions that use mnesia's query functions
  % inside a transaction. http://learnyousomeerlang.com/mnesia
  Query = fun() ->
    case mnesia:read(?TABLENAME, item) of
      % in this case we should have a unique record, so just expect one result, get the
      % Item by the ?TABLENAME and term(), and if it matches capture it and return success
      [{?TABLENAME, item, Item}] -> {ok, Item};
      % otherwise error
      [] -> {error, noitem}
    end
  end,
  % run the Query in a transaction
  mnesia:activity(transaction, Query).

%%====================================================================
%% Internal functions
%%====================================================================

-spec set_item() -> {ok, erlang_notebook_item()}.

set_item() ->
  Query = fun() ->
    % http://erlang.org/doc/man/crypto.html
    Item = crypto:rand_bytes(32),
    ok   = mnesia:write({?TABLENAME, item, Item}),
    {ok, Item}
  end,
  mnesia:activity(transaction, Query).
