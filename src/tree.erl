-module(tree).

-export([create/1,
         terminate/1,
         get_tree/0]).


create(Name) ->
    service_sup_sup:start_service(Name).

terminate(Name) ->
    service_sup_sup:terminate_service(Name).


get_tree() ->
    Module = service_sup_sup,
    Pid = erlang:whereis(Module),
    {registered_name, Name} = erlang:process_info(Pid, registered_name),
    get_tree(Name, Pid, supervisor, Module, 0).

get_tree(Name, Pid, worker, Module, Level) ->
    display(Level, Module, worker, Name, Pid);
get_tree(Name, Pid, supervisor, Module, Level) ->
    display(Level, Module, supervisor, Name, Pid),
    case supervisor:which_children(Pid) of
        ok ->
            ok;
        [] ->
            ok;
        Items ->
            lists:foreach(
              fun({N, P, T, [M]}) ->
                      get_tree(N, P, T, M, Level + 1)
              end, Items)
    end.


display(Level, Module, Type, Name, Pid) ->
    [io:format("  ") || _ <- lists:seq(1, Level)],
    io:format("[~p] ~p:~p (~p)~n", [Type, Module, Name, Pid]).
