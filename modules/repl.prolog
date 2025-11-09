:- use_module('operations.prolog').
:- use_module('targets.prolog').
:- use_module('tools_define.prolog').


repl :-
    write('HM> '), flush_output,
    read_line_to_string(user_input, Line),
    (   Line == 'quit' ; Line == end_of_file
    ->  writeln('Exiting...')
    ;   catch(handle_input(Line),
              E, (format("Error: ~w~n", [E]))),
        repl
    ).

handle_input(Line) :-
    split_string(Line, " ", "\s\t\n", Parts),
    (   Parts = [Command|Args]
    ->  dispatch(Command, Args)
    ;   writeln("coudnt get a command.")
    ).

dispatch('load_targets', [FilePath|Rest]) :-
    read_targets_file(FilePath).
