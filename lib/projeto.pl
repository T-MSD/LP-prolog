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

equal_length(L1, L2) :-
  length(L1, Size1),
  length(L2, Size2),
  Size1 =:= Size2.


% Insere Varios Objetos
insereVariosObjectos(ListaCoords, Tabuleiro, ListaObjs) :-
  equal_length(ListaCoords, ListaObjs),
  insereVariosObjectosAux(ListaCoords, Tabuleiro, ListaObjs).

insereVariosObjectosAux([], _, []).
insereVariosObjectosAux([Coord | RestoCoord], Tabuleiro, [Obj | RestoObj]) :-
  insereObjecto(Coord, Tabuleiro, Obj),
  insereVariosObjectosAux(RestoCoord, Tabuleiro, RestoObj).


% Insere Pontos à volta
inserePontosVolta(Tabuleiro, (L, C)) :-