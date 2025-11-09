:- module(operations,
          [ set_current_op/0,
            current_operation/1,
            current_path/1,
            scans_dir/1,
            config_dir/1,
            expert_dir/1,
            expert_config/1,
            expert_statefile/1,
            iso8601_now/1,
            ensure_dir/1
          ]).



:- dynamic operation/1.
:- dynamic current_operation/1.
:- dynamic tool_run/4. % tool_run/4 Program Target Arguments OutputPath
:- dynamic tool_def/2. %

:- use_module(library(time)).


iso8601_now(ISO) :-
    get_time(Now),
    format_time(atom(ISO), '%FT%T%z', Now).


current_operation(Result) :- getenv("HACKMODE_OP", Result).

current_path(Result) :- getenv("HACKMODE_PATH", Result).

set_current_op() :-
    current_operation(Name),
    assertz(current_operation(Name)).

scans_dir(Result) :-
    current_path(Path),
    directory_file_path(Path, 'scans', Result).

config_dir(Result) :-
    current_path(Path),
    directory_file_path(Path, '.config', Result).

targets_file(Result) :-
    config_dir(Config)
    directory_file_path(Path, 'targets.txt', Result).

inscope_file(Result) :-
    config_dir(Config)
    directory_file_path(Path, 'inscope.txt', Result).

inscope_file(Result) :-
    config_dir(Config)
    directory_file_path(Path, 'outscope.txt', Result).

expert_dir(Result) :-
    config_dir(ConfigPath),
    directory_file_path(ConfigPath, 'expert', Result).

expert_config(Result) :-
    getenv("USER", User),
    directory_file_path("/home", User, ConfigDir),
    directory_file_path(ConfigDir, "hackmode-expert", ExpertDir),
    directory_file_path(ExpertDir, "config.prolog", Result).


expert_statefile(Result) :-
    expert_dir(Dir),
    directory_file_path(Dir, 'expert-state.prolog', Result).




ensure_dir(Dir) :-
    (   exists_directory(Dir)
    ->  true
    ;   make_directory_path(Dir)
     ).
