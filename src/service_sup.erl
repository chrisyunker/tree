-module(service_sup).

-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

%% ===================================================================
%% API functions
%% ===================================================================

start_link(Name) ->
    Id = list_to_atom("service_sup_" ++ Name),
    supervisor:start_link({local, Id}, ?MODULE, [Name]).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([Name]) ->
    io:format("[service_sup] init: ~p~n", [Name]),
    ChildSpec = {{service, Name},
                 {service, start_link, [Name]},
                 permanent, infinity, supervisor, [service]},
    {ok, {{one_for_one, 5, 10}, [ChildSpec]}}.

