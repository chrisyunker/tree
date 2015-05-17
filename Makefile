.PHONY: clean

all: compile

get-deps:
	./rebar get-deps

compile: get-deps
	./rebar compile

app: get-deps
	./rebar compile skip_deps=true -f

test: compile
	./rebar eunit

clean:
	./rebar clean

