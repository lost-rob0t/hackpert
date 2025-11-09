:- dynamic scope/3. % inscope(inscope/outscope, Program, Scope, Type) Type being of wildcard, url, domain, host
:- dynamic no_scope/1. % inscope(inscope/outscope, Program, Scope, Type) Type being of wildcard, url, domain, host



:- use_module('targets.prolog').
:- use_module(library(pcre)).
:- assertz(no_scope(true)). % Default we dont have scope
% LLM derived.
wildcard_domain_regex('^\\*\\.[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$').
wildcard_scope_regex('^\\*[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$').
url_regex('\\Ahttps?://([^/:]+)(?::[0-9]+)?(?:/.*)?\\z').

scop_is_wildcard(Wildcard) :-
    wildcard_domain_regex(DotString),
    wildcard_domain_regex(WithoutDot),
    (   re_match(DotString, Wildcard)
    ->  true
    ;   re_match(WithoutDot, Wildcard)
    ).

classify_scope(Input, wildcard) :- is_wildcard(Input).

classify_scope(Input, url) :- targets:is_url(Input).


classify_scope(Input, domain) :- targets:is_domain(Input).

classify_scope(Input, host) :- targets:is_host(Input).

% Default rule when no scope is defined
inscope(_Target) :-
    no_scope(_), !.

inscope(Target) :-
    scope(inscope, _, Target, _).



outscope(Target) :-
    scope(outscope, _, Target, _).

add_scope(inscope, Target) :-
    retractall(no_scope(_)),
    classify_scope(Target, ScopeType),
    retractall(scope(inscope, _, Target, ScopeType)),
    current_operation(Operation),
    asserta(scope(inscope, Operation, Target, ScopeType)).


add_scope(outscope, Target) :-
    retractall(no_scope(_)),
    classify_scope(Target, ScopeType),
    retractall(scope(outscope, _, Target, ScopeType)),
    current_operation(Operation),
    asserta(scope(inscope, Operation, Target, ScopeType)).
