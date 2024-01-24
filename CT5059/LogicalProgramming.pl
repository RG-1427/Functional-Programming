%Libraries
:- use_module(library(readutil)).
:- use_module(library(pairs)).

%List of connecting words
connectingWord("and").
connectingWord("or").
connectingWord("to").
connectingWord("also").
connectingWord("the").
connectingWord("like").
connectingWord("as").
connectingWord("too").
connectingWord("but").
connectingWord("unlike").
connectingWord("for").
connectingWord("an").
connectingWord("in").
connectingWord("a").
connectingWord("from").

%List of threat words
threatWord("threat").
threatWord("vulnerabilities").
threatWord("attack").
threatWord("loopholes").
threatWord("whitelist").
threatWord("blacklist").
threatWord("hash").
threatWord("encryption").

% Reading email, sorting list, counting elements, displaying elements
% and labeling the email
email(File, String):-
    %Reading the file to lower case
    read_file_to_codes(File, Codes, []),
    string_codes(String, Codes),
    string_lower(String, Lower),
    %Splitting the file
    split_string(Lower, " :();!.\n", ",", L),
    %Counting and sorting the elements
    elem_count(L, Nl),
    transpose_pairs(Nl, Sl),
    sort(0, @>, Sl, Fl),
    %Printing the 10 elements
    print(Fl, 10, Dl),
    write(Dl),
    %Counting the threat words
    threats_count(L, Tl),
    transpose_pairs(Tl, Flag),
    %Finding the repition of each threat word
    pairs_keys(Flag, Counter),
    sumlist(Counter, Val),
    nl,
    %Deciding if the email is suspicious or benign
    Val > 4 ->
    write("This email is suspicious!");
    write("This email is benign").

%Sorting the counted elements list
elem_count(Lst, LstCount) :-
   sort(Lst, LstSorted),
   findall(Elem-Count, (
        member(Elem, LstSorted), elem_in_list(Elem, Lst, Count)
   ), LstCount).

%Counting the elements
elem_in_list(Elem, Lst, Count) :-
    Elem \=="",
    \+ connectingWord(Elem),
    aggregate_all(count, member(Elem, Lst), Count).

%Printing the 10 top elements in the list
print([_|_], 0, []).
print([H|_],1,[H]).
print([X|T1],N,[X|T2]):-
    N>=0,
    N1 is N-1,
    print(T1,N1,T2).

%Sorting the counted threat words
threats_count(Lst, LstCount) :-
   sort(Lst, LstSorted),
   findall(Elem-Count, (
        member(Elem, LstSorted), threats_in_list(Elem, Lst, Count)
   ), LstCount).

%Counting the threat words
threats_in_list(Elem, Lst, Count) :-
   threatWord(Elem),
   aggregate_all(count, member(Elem, Lst), Count).

