-module(service_sup_sup).

-behaviour(supervisor).

%% API
-export([start_link/0,
         start_service/1,
         terminate_service/1,
         start_simple_service/1,
         terminate_simple_service/1]).

%% Supervisor callbacks
-export([init/1]).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_service(Name) ->
    io:format("[service_sup_sup] start_service: ~p~n", [Name]),
    ChildSpec = {{service_sup, Name},
                 {service_sup, start_link, [Name]},
                 permanent, infinity, supervisor, [service_sup]},
    supervisor:start_child(?MODULE, ChildSpec).

terminate_service(Name) ->
    io:format("[service_sup_sup] terminate_service: ~p~n", [Name]),
    ok = supervisor:terminate_child(?MODULE, {service_sup, Name}),
    ok = supervisor:delete_child(?MODULE, {service_sup, Name}).

start_simple_service(Name) ->
    io:format("[service_sup_sup] start_simple_service: ~p~n", [Name]),
    ChildSpec = {{service, Name},
                 {service, start_link, [Name]},
                 permanent, 5000, worker, [service]},
    supervisor:start_child(?MODULE, ChildSpec).

terminate_simple_service(Name) ->
    io:format("[service_sup_sup] terminate_simple_service: ~p~n", [Name]),
    ok = supervisor:terminate_child(?MODULE, {service, Name}),
    ok = supervisor:delete_child(?MODULE, {service, Name}).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    io:format("[service_sup_sup] init~n"),
    {ok, {{one_for_one, 5, 10}, []}}.

