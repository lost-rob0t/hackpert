% tools_json_xml.pl
% Registry of scanning / discovery tools limited to JSON and XML outputs.
% SWI-Prolog module.

:- module(tools_define,
          [
            tool/1,
            tool_run/3,
            tool_output_file/2,
            tool_produces/2,
            tool_def/2,
            tool_use/2,
            tool_use/2,
            suggest_tool/2,
            suggest_tool/3.
          ]).
:- dynamic tool/1.              % tool(Name).
:- dynamic tool_run/3           % tool_run(Program, Target, Tool)
:- dynamic tool_def/4.          % tool_def(Program, Target, Arguments, OutputFile).
:- dynamic target/3.            % target(Program, Target, Type).
:- dynamic current_phase/3
:- dynamic workflow/4           % worflow(Name, [Tool1, Tool2], [asset_disovery, tech])
%:- dynamic tool_usecase/2.     % tool_usecase(Name, UseCase).
%:- dynamic tool_takes/2.     % tool_takes(Name, Type).
%:- dynamic parse_tool/2.       % parseTool(ToolName, Input).
%:- dynamic parse_queue/2.      % parse_queue(Tool, Input)
:- use_module(library(time)).
:- use_module("targets.prolog").
:- use_module("operations.prolog").
:- use_module("fuzzing.prolog").
:- use_module("scope.prolog").
:- consult('tools/tools.prolog').

% phase_workflow(default, [asset_discovery, port_scan, content_discovery, fuzzing, vuln_scan, tech]).

% phase(asset_discovery).
% phase(fuzzing).
% phase(content_discovery).
% phase(port_scan).
% phase(vuln_scan).
% phase(tech).
% phase_map(url, fuzzing).
% phase_map(host, port_scan).
% phase_map(url, vuln_scan).
% phase_map(host, vuln_scan).
% phase_map(url, vuln_scan).
% phase_map(host, tech).
% phase_map(url, tech).
% phase_map(domain, tech).

% IDEA tool_workflow(Name, [Tool1, Tool2, Tool3] [phase map])
% add a new workflow.
% define_workflow(Name, Tools, Phases) :-
%     retractall(worflow(Name, _, _)),
%     assertz(worflow(Name, Tools, Phases)),
%     format("workflow ~w registered.~n", [Name]).
% % remove the workflow.
% unregister_workflow(Name) :-
%     retractall(registered_workflow(Name, _, _)),
%     format('workflow ~w unregistered~n', [Name]).

% % remove all workflows.
% cleanup_workflows() :-
%     retractall(registered_workflow(_, _, _)),
%     format('workflow ~w unregistered~n', [Name]).



% Suggest a tool based on the target type.
% suggests a tool by its use case.
suggest_tool_by_use(Use, Result) :- tool_use(Result, Use).

suggest_tool_by_result(Type, Tool) :-
    tool_produces(Tool, List),
    member(Type, List).

suggest_tool(Target, Result) :-
    target(_, Target, Type),
    tool_takes(Result, Type).

suggest_tool(Target, UseCase, Result) :-
    target(_, Target, Type),
    tool_use(Target, UseCase),
    tool_takes(Result, Type).



% First, get the targets available tools for its type.
% Then I add constraint on phase.
suggest_tool_by_phase(Target, Phase, Result) :-
    suggest_tool(Target, Result),
    tool_phase(Result, Phase).

% Build a Per tool timstamped directory
tool_output_dir(Tool, Result) :-
    scans_dir(Path),
    string_lower(Tool, ToolLower),
    operations:iso8601_now(ISO),
    directory_file_path(Path, ToolLower, ToolDir),
    directory_file_path(ToolDir, ISO, Result),
    operations:ensure_dir(Result).



% replace the tools arguments.
instantiate_cmd(_, _, [], []).

instantiate_cmd(Target, Tool, ['{target}'|ArgsTail], [Target|ResultTail]) :-
    instantiate_cmd(Target, Tool, ArgsTail, ResultTail).

instantiate_cmd(Target, Tool, ['{output_file}'|ArgsTail], [ToolOutputFile|ResultTail]) :-
    tool_output_dir(Tool, ToolDir),
    tool_output_file(Tool, FileName),
    directory_file_path(ToolDir, FileName, ToolOutputFile),
    instantiate_cmd(Target, Tool, ArgsTail, ResultTail).

instantiate_cmd(Target, Tool, [H|T], [H|ResultTail]) :-
    instantiate_cmd(Target, Tool, T, ResultTail).

% Run the current tool with template replacing its arguments.
run_tool(Tool, Target) :-
    % TODO Check if target is in scope
    curent_target(Target),
    tool_def(Tool, Template),
    instantiate_cmd(Target, Tool, Template, ArgResult),
    process_create(path(Tool), [ArgResult]).

run_target(Target) :-
    suggest_tool(Target, Tool),
