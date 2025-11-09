:- module(targets, [target/3,
                    add_target/1,
                    is_host/1,
                    is_domain/1,
                    is_url/1,
                    ipv4_regex/1,
                    ipv6_regex/1,
                    domain_regex/1,
                    cleanup_targets/0]).


:- use_module('operations.prolog').
:- use_module(library(pcre)).
:- use_module(library(apply)). % TODO do i still need this?

:- dynamic target/3. % target(Program, Target, Type)
% Maybe i should just merge these?
% WARNING LLM derived regex.
ipv4_regex("^((?:25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})(?:\\.(?:25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})){3})$").
ipv6_regex('^(([0-9a-fA-F]{1,4}:){1,7}[0-9a-fA-F]{1,4})$').
domain_regex('^([a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\\.[a-zA-Z]{2,})$').
url_regex('\\Ahttps?://([^/:]+)(?::[0-9]+)?(?:/.*)?\\z').


is_host(Host) :-
    (   ipv4_regex(Ipv4), re_match(Ipv4, Host)
    ;   ipv6_regex(Ipv6), re_match(Ipv6, Host)
    ).
% is_host(Host) :-
%     ipv4_regex(Ipv4), re_match(Rx, Host)
%     ; ipv6(Ipv6), re_match(Ipv6, Host).



is_url(Url) :-
    url_regex(Rx), re_match(Rx, Url).

is_domain(Domain) :- domain_regex(Rx), re_match(Rx, Domain).

classify_target(Domain, domain) :- is_domain(Domain).

classify_target(Host, host) :- is_host(Host).

classify_target(Url, url) :- is_url(Url), !.

classify_target(_, unknown).




add_target(TargetStr) :-
    classify_target(TargetStr, ResultType),
    current_operation(Operation), % Todo Inject check scope
                                  % here to ensure only inscope targets are allowed
    retractall(target(_, TargetStr, _)),
    assertz(target(Operation, TargetStr, ResultType)).

read_targets_file(FilePath) :-
    open(FilePath, read, In),
    process_target(In),
    close(In).

process_target(Input) :-
    read_line_to_string(Input, Line),
    (   Line == end_of_file
    ->  true
    ;   add_target(Line)
    ).




cleanup_targets() :-
    retractall(target(_, _, _)).

cleanup_targets_of_type(Type) :-
    retractall(target(_, _, Type)).
