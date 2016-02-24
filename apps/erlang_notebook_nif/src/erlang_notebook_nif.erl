-module(erlang_notebook_nif).
-export([repeat/2]).
-on_load(init/0).

%% http://www.rebar3.org/docs/building-cc

-define(APPNAME, erlang_notebook_nif).
-define(LIBNAME, erlang_notebook_nif).

repeat(_, _) ->
    not_loaded(?LINE).

init() ->
    SoName = case code:priv_dir(?APPNAME) of
        {error, bad_name} ->
            case filelib:is_dir(filename:join(["..", priv])) of
                true ->
                    filename:join(["..", priv, ?LIBNAME]);
                _ ->
                    filename:join([priv, ?LIBNAME])
            end;
        Dir ->
            filename:join(Dir, ?LIBNAME)
    end,
    erlang:load_nif(SoName, 0).

not_loaded(Line) ->
    exit({not_loaded, [{module, ?MODULE}, {line, Line}]}).
