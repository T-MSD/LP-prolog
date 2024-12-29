% Tiago Dias 102613
:- use_module(library(clpfd)). % para pode usar transpose/2
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % ver listas completas
:- [puzzles]. % Ficheiro dado. A avaliação terá mais puzzles.
:- [codigoAuxiliar]. % Ficheiro dado. Não alterar.
% Atenção: não deves copiar nunca os puzzles para o teu ficheiro de código
% Segue-se o código

% Visualiza
visualiza([]).
visualiza([H|T]) :-
  writeln(H),
  visualiza(T). 


% Visualiza Linha
visualizaLinha(Lista) :-      
  print_index(Lista, 1). 

print_index([], _).
print_index([H|T], N) :-
  format('~d: ~w~n', [N, H]),
  N1 is N + 1,               
  print_index(T, N1).


% Insere Objeto
insereObjecto((L, C), Tabuleiro, Obj) :-
  nth1(L, Tabuleiro, Linha),
  nth1(C, Linha, Element),
  var(Element), !,                                
  Element = Obj.                    
insereObjecto(_, _, _).


% Insere Varios Objetos
equal_length(L1, L2) :-
  length(L1, Size1),
  length(L2, Size2),
  Size1 =:= Size2.

insereVariosObjectos(ListaCoords, Tabuleiro, ListaObjs) :-
  equal_length(ListaCoords, ListaObjs),
  insereVariosObjectosAux(ListaCoords, Tabuleiro, ListaObjs).

insereVariosObjectosAux([], _, []).
insereVariosObjectosAux([Coord | RestoCoord], Tabuleiro, [Obj | RestoObj]) :-
  insereObjecto(Coord, Tabuleiro, Obj),
  insereVariosObjectosAux(RestoCoord, Tabuleiro, RestoObj).


% Insere Pontos
inserePontos(_, []) :- !.
inserePontos(Tabuleiro, [(L, C) | T]) :-
  nth1(L, Tabuleiro, Linha),
  nth1(C, Linha, Element),
  var(Element),                                
  Element = 'p',                   
  inserePontos(Tabuleiro, T), !.
inserePontos(Tabuleiro, [_ | T]) :-
  inserePontos(Tabuleiro, T), !.


% Insere Pontos à volta
inserePontosVolta(Tabuleiro, (L, C)) :-
  Top_left_x is L - 1,
  Top_left_y is C - 1,

  Top_mid_x is L - 1,
  Top_mid_y is C,
  
  Top_right_x is L - 1,
  Top_right_y is C + 1,

  Mid_left_x is L,
  Mid_left_y is C - 1,

  Mid_right_x is L,
  Mid_right_y is C + 1,

  Bottom_left_x is L + 1,
  Bottom_left_y is C - 1,

  Bottom_mid_x is L + 1,
  Bottom_mid_y is C,

  Bottom_right_x is L + 1,
  Bottom_right_y is C + 1,

  Array = [(Top_left_x, Top_left_y), (Top_mid_x, Top_mid_y), (Top_right_x, Top_right_y), (Mid_left_x, Mid_left_y), (Mid_right_x, Mid_right_y), (Bottom_left_x, Bottom_left_y), (Bottom_mid_x, Bottom_mid_y), (Bottom_right_x, Bottom_right_y)],
  inserePontos(Tabuleiro, Array).


% Objetos em Coordenadas
objectosEmCoordenadas([], _, []).
objectosEmCoordenadas([(L, C) | T], Tabuleiro, [Obj | RestoObj]) :-
  nth1(L, Tabuleiro, Linha),
  nth1(C, Linha, Element),
  Element = Obj,
  objectosEmCoordenadas(T, Tabuleiro, RestoObj).


% Coordenadas Objetos
coordObjectos(_, _, [], [], 0) :- !.
coordObjectos(_, _, [], Resto, _) :-
  sort(Resto, RestoOrdenado),
  Resto = RestoOrdenado, !.

coordObjectos(Obj, Tabuleiro, [(L,C) | T], [(L,C) | Resto], NumObjectos) :-
  nth1(L, Tabuleiro, Linha),
  nth1(C, Linha, Element),
  Element == Obj,
  coordObjectos(Obj, Tabuleiro, T, Resto, UpdatedNum),
  NumObjectos is UpdatedNum + 1, !.

coordObjectos(Obj, Tabuleiro, [(L,C) | T], [(L,C) | Resto], NumObjectos) :-
  var(Obj),
  nth1(L, Tabuleiro, Linha),
  nth1(C, Linha, Element),
  var(Element),
  coordObjectos(Obj, Tabuleiro, T, Resto, UpdatedNum),
  NumObjectos is UpdatedNum + 1, !.

coordObjectos(Obj, Tabuleiro, [_ | T], Resto, NumObjectos) :-
  coordObjectos(Obj, Tabuleiro, T, Resto, NumObjectos), !.


% Coordenadas Vars
coordenadasVars(Tabuleiro, ListaVars) :-
  findall((L, C), coordenadaVariavel(Tabuleiro, L, C), ListaVars),
  sort(ListaVars, ListaVars).

coordenadaVariavel(Tabuleiro, L, C) :-
  nth1(L, Tabuleiro, Linha),
  nth1(C, Linha, Elem),
  var(Elem).