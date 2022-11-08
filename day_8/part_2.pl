segment_name(a).
segment_name(b).
segment_name(c).
segment_name(d).
segment_name(e).
segment_name(f).
segment_name(g).

segment_list(0, [a, b, c, e, f, g]).
segment_list(1, [c, f]).
segment_list(2, [a, c, d, e, g]).
segment_list(3, [a, c, d, f, g]).
segment_list(4, [b, c, d, f]).
segment_list(5, [a, b, d, f, g]).
segment_list(6, [a, b, d, e, f, g]).
segment_list(7, [a, c, f]).
segment_list(8, [a, b, c, d, e, f, g]).
segment_list(9, [a, b, c, d, f, g]).

segment(X, Y) :-
	segment_list(X, L),
	member(Y, L).

num_segments(X, N) :-
	segment_list(X, L),
	length(L, N).

assoc_list([], [], []).
assoc_list([X|Xs], [Y|Ys], [Z|Zs]) :-
	Z = X-Y,
	assoc_list(Xs, Ys, Zs).

other_segment(Given, Other) :-
	segment_name(Other),
	\+ Other = Given.

pairs_jive(A-B, C-D) :-
	(
		(A = C, B = D);
		(\+ A = C, \+ B = D)
	).

mapping_compliant([], _).
mapping_compliant([A-B|Ms], MappingSeen) :-
	forall(member(Pair, MappingSeen), pairs_jive(A-B, Pair)),
	mapping_compliant(Ms, MappingSeen).

mapping_helper([], [], Mapping, Mapping).
mapping_helper([P|Ps], Ns, Mapping, MappingSeen) :-
	length(P, Len),
	member(N, Ns),
	num_segments(N, Len),
	segment_list(N, SegList),

	permutation(P, PPerm),
	assoc_list(PPerm, SegList, M1),

	mapping_compliant(M1, MappingSeen),
	union(M1, MappingSeen, MappingSeen1),

	delete(Ns, N, Ns1),
	mapping_helper(Ps, Ns1, Mapping, MappingSeen1).

sort_pattern(<, P1, P2) :-
	length(P1, N1),
	length(P2, N2),
	N1 < N2.

sort_pattern(>, P1, P2) :-
	length(P1, N1),
	length(P2, N2),
	N1 > N2.

sort_pattern(Delta, P1, P2) :-
	length(P1, N1),
	length(P2, N2),
	N1 = N2,
	compare(Delta, P1, P2).

segment_mapping(Patterns, Mapping) :-
	predsort(sort_pattern, Patterns, SortedPatterns),
	findall(N, segment_list(N, _), Ns),
	mapping_helper(SortedPatterns, Ns, Mapping, []).

assoc_val(X, [X-Y|_], Y).
assoc_val(X, [_-_|T], N) :-
	assoc_val(X, T, N).

apply_map_to_segs([], [], _).
apply_map_to_segs([X|Xs], [Y|Ys], Mapping) :-
	assoc_val(X, Mapping, Y),
	apply_map_to_segs(Xs, Ys, Mapping).

get_n(Segs, Mapping, N) :-
	apply_map_to_segs(Segs, Segs1, Mapping),
	sort(Segs1, Segs2),
	segment_list(N, Segs2).

display_number([], _, _, N, N).
display_number([D|Ds], Mapping, Mult, Acc, N) :-
	get_n(D, Mapping, Digit),
	Acc1 is Acc + Digit * Mult,
	Mult1 is Mult * 10,
	display_number(Ds, Mapping, Mult1, Acc1, N).

display_val(Patterns, Displays, N) :-
	segment_mapping(Patterns, Mapping),
	reverse(Displays, DisplaysRev),
	display_number(DisplaysRev, Mapping, 1, 0, N).

answer_helper(P, D, N) :-
	to_solve(P, D),
	display_val(P, D, N).

answer(N) :-
	findall(X, answer_helper(_, _, X), Xs),
	sum_list(Xs, N).
