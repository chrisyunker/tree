-module(service).

-behaviour(gen_server).

%% API
-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {name :: string()}).

%% ===================================================================
%% API
%% ===================================================================
start_link(Name) ->
    Id = list_to_atom("service_" ++ Name),
    gen_server:start_link({local, Id}, ?MODULE, [Name], []).

%% ===================================================================
%% gen_server callbacks
%% ===================================================================
init([Name]) ->
    io:format("[service] init name: ~p~n", [Name]),
    {ok, #state{name = Name}}.

handle_call(_Message, _From, State) ->
    Response = ok,
    {reply, Response, State}.

handle_cast(_Message, State) ->
    {noreply, State}.

handle_info(_Message, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    io:format("[service] terminate name: ~p~n", [State#state.name]),
    ok.

code_change(_OldVersion, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Private functions
%%%===================================================================

