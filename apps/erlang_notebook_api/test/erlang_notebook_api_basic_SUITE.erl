-module(erlang_notebook_api_basic_SUITE).
-include_lib("eunit/include/eunit.hrl").
-include_lib("common_test/include/ct.hrl").
-export([
	all/0, groups/0,
	init_per_suite/1, end_per_suite/1,
	init_per_testcase/2, end_per_testcase/2,
	init_per_group/2, end_per_group/2,
	%% group: boot
	test_boot_erlang_notebook_api/1
	%% group: basic
	%% TODO
]).

%%%===================================================================
%%% CT Callbacks
%%%===================================================================

all() -> [
		{group, boot},
		{group, basic}
	].

groups() -> [
		{boot, [], [
			test_boot_erlang_notebook_api
		]},
		{basic, [], [
			%% TODO
		]}
	].


init_per_suite(Config) ->
    stop_system(),
    start_system(),
    timer:sleep(1000),
    Config.

end_per_suite(_Config) ->
    stop_system(),
    ok.

init_per_testcase(_Suite, Config) ->
    Config.

end_per_testcase(_Suite, _Config) ->
    ok.

init_per_group(basic, Config) ->
	{ok, _} = application:ensure_all_started(cowboy),
	{ok, _} = application:ensure_all_started(jsx),
	{ok, _} = application:ensure_all_started(mcd),
	Config;
init_per_group(_, Config) -> Config.

end_per_group(basic, _Config) ->
	application:stop(inets);
end_per_group(_, _Config) -> ok.

%%%===================================================================
%%% TESTS
%%%===================================================================

%%--------------------------------------------------------------------
%% Group : boot
%%--------------------------------------------------------------------

test_boot_erlang_notebook_api(_Config) ->
	% Simple check to ensure that app boots.
	lists:member(
		erlang_notebook_api,
		[ App || {App, _Desc, _Ver} <- application:which_applications()]
	).

%%--------------------------------------------------------------------
%% Group : basic
%%--------------------------------------------------------------------

%% TODO

%%%===================================================================
%%% Internal Functions
%%%===================================================================

start_system() ->
  {ok, _Started} = erlang_notebook_api:start().

stop_system() ->
  _ = erlang_notebook_api:stop().
