
%part1(Depth First Search)

game(N, M, X1, Y1, X2, Y2, Res) :-
    initialize_board(N, M, B),
    addElemToBoard(B, X1, Y1, 1, NB),
    addElemToBoard(NB, X2,Y2, 1, R),
    search([R], [], M, N, Res).


search([],[_|T],_,_,T):-!.

search(Open, Closed, M, N, R):-
	Open = [CurrentNode|RestOfOpen],
	getChildren(CurrentNode, RestOfOpen, Closed, M, N, Children),
	append(RestOfOpen, Children, NewOpen), %BFS
     append(Closed, [CurrentNode], NewClosed),
	search(NewOpen, NewClosed, M, N, R).


getChildren(State, Open, Closed, M, N, Children):-
    findall(NextState, getNextState(State, Open, Closed, M, N, NextState), Children).


getNextState(State, Open, Closed, M, N, NextState):-
	isEmpty(State, RI, CI),
    move(State, RI, CI, M, N, NextState),
	not(member(NextState, Open)),
	not(member(NextState, Closed)).




%part2(Greedy best-first Algorithm)

game1(N, M, X1, Y1, X2, Y2, Res, Dominos) :-
    initialize_board(N, M, B),
    addElemToBoard(B, X1, Y1, 1, NB),
    addElemToBoard(NB, X2,Y2, 1, R),
    findall(_,isEmpty(R,_,_),ListOfEmp),
    length(ListOfEmp, NumOfEmptyCells),
    Goal is floor(NumOfEmptyCells/2),
    ( search1([[R,10000]],[], M, N, Goal, Res, Dominos) -> true;
	 GG is Goal-1, search1([[R,10000]], [], M, N, GG, Res, Dominos) ).


search1(Open, _, M, N, G, CurrentState, NoOfDominos):-
	getBestState(Open, Node, _),
      Node = [CurrentState,H],
	NoOfDominos is floor(( M*N - (2+H) ) / 2),
	NoOfDominos = G,!.


search1(Open, Closed, M, N, G, R, NoOfDominos):-
	getBestState(Open, CurrentNode, RestOfOpen),
	getChildren1(CurrentNode, RestOfOpen, Closed, M, N, Children),
	append(RestOfOpen, Children, NewOpen), %BFS
      append(Closed, [CurrentNode], NewClosed),
	search1(NewOpen, NewClosed, M, N, G, R, NoOfDominos).

getChildren1(State, Open, Closed, M, N, Children):-
    findall(NextNode, getNextState1(State, Open, Closed, M, N, NextNode), Children).


getNextState1(Node, Open, Closed, M, N, NextNode):-
	Node = [State,_],
	isEmpty(State, RI, CI),
    move(State, RI, CI, M, N, NextState),
    calculateH(NextState, H),
	NextNode = [NextState,H],
    not(member(NextNode, Open)),
    not(member(NextNode, Closed)).


calculateH(State, NumOfEmptyCells):-
	findall(_,isEmpty(State,_,_),ListOfEmptyCells),
    length(ListOfEmptyCells, NumOfEmptyCells).

getBestState(Open, BestChild, Rest):-
    findMin(Open, BestChild),
    delete(Open, BestChild, Rest).


findMin([X], X):- !.
findMin([Head|T], Min):-
	findMin(T, TmpMin),
     Head = [_,HeadH],
	TmpMin = [_,TmpH],
	(TmpH < HeadH -> Min = TmpMin ; Min = Head).




initialize_board(N,M,Board) :-
    length(Board, N),
    initialize_rows(M, Board).

initialize_rows(_, []):-!.
initialize_rows(M, [Row|Rows]) :-
    length(Row, M),
    maplist(=(0), Row), %to initialize this row with 0
    initialize_rows(M, Rows).

addElemToBoard(Board, X, Y, Val, NewBoard) :-
    nth1(X, Board, Row),
    put(Row, Y, Val, NewRow),
    put(Board, X, NewRow, NewBoard).

put([_|T], 1, X, [X|T]):-!.
put([H|T], I, X, [H|Z]) :-
    NI is I - 1,
    put(T, NI, X, Z).


move(State, RI, CI, M, N, NextState):-
    horizontal(State, RI, CI, M, NextState); vertical(State, RI, CI, N,NextState).

horizontal(B,RI,CI,M,NextState):-
    not(CI = M),
    NCI is CI+1,
    isEmpty(B, RI, NCI),
    addElemToBoard(B, RI, CI, #, NB),
    addElemToBoard(NB, RI, NCI, #, NextState).

vertical(B,RI,CI,N,NextState):-
    not(RI = N),
    NRI is RI+1,
    isEmpty(B, NRI, CI),
    addElemToBoard(B, RI, CI, #, NB),
    addElemToBoard(NB, NRI, CI, #, NextState).

isEmpty(Board, RowIndex, ColIndex) :-
    nth1(RowIndex, Board, Row),
    nth1(ColIndex, Row, 0).




