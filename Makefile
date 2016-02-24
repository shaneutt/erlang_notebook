REBAR := `pwd`/rebar3

all: test release

compile:
	@$(REBAR) compile

doc:
	@$(REBAR) edoc

test:
	@$(REBAR) do eunit

test-all:
	@$(REBAR) do xref, dialyzer, eunit, ct, cover

release:
	@$(REBAR) release

run:
	@$(REBAR) run

tar:
	@$(REBAR) as prod tar

clean:
	@$(REBAR) clean

shell:
	@$(REBAR) shell

.PHONY: release test all compile clean
