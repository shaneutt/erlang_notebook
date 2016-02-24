%% -------------------------------------------------------------------
%% @doc base page for the API providing documentation and help
%% -------------------------------------------------------------------
-module(erlang_notebook_api_base).
-export([init/2]).

%%====================================================================
%% API functions
%%====================================================================

init(Req, Page) ->
  Data = handle_request(Req),
  Body = jsx:encode(Data),
	Req2 = cowboy_req:reply(200, [{<<"content-type">>, <<"text/json">>}], Body, Req),
	{ok, Req2, Page}.

%%====================================================================
%% Internal functions
%%====================================================================

handle_request(_Req) ->
  %% lager:warning("api base unimplemented", [Req]),
  #{todo => documentation}.
