:- module(fuzzing, [wordlist/3,
                    suggest_wordlist/3,
                    assert_wordlist/3]).



:- dynamic wordlist/3.          % wordlist(Tool, WordlistType, Path)

fuzz_type(dirbust).
fuzz_type(api_enum).
fuzz_type(injection).
fuzz_type(idor).

suggest_wordlist(Tool, WordlistType, Result) :-
    wordlist(Tool, WordlistType, Result).

assert_wordlist(Tool, WordlistType, Path) :-
    (   wordlist(Tool, WordlistType, Path)
    ->  true
    ;   assertz(wordlist(Tool, WordlistType, Path))
    ).
