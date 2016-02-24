-module(erlang_notebook_web_page).

-export([init/2]).

init(Req, Page) ->
	PageBinary = atom_to_binary(Page, utf8),
	Template   = binary_to_existing_atom(<<"erlang_notebook_web_", PageBinary/binary, "_dtl">>, utf8),
	{ok, Body} = Template:render([{page, PageBinary} |cowboy_req:bindings(Req)]),
	Req2       = cowboy_req:reply(200, [{<<"content-type">>, <<"text/html">>}], Body, Req),
	{ok, Req2, Page}.
