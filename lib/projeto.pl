% Tiago Dias 102613
:- use_module(library(clpfd)). % para pode usar transpose/2
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % ver listas completas
:- [puzzles]. % Ficheiro dado. A avaliação terá mais puzzles.
:- [codigoAuxiliar]. % Ficheiro dado. Não alterar.
% Atenção: não deves copiar nunca os puzzles para o teu ficheiro de código
% Segue-se o código

visualiza(Lista) :-
  is_list(Lista),
  escreve_lista(Lista).

escreve_lista([]).
escreve_lista([H|T]) :-
  writeln(H),
  escreve_lista(T).

visualizaLinha(Lista) :-
  is_list(Lista),      
  print_index(Lista, 1). 

print_index([], _).
print_index([H|T], N) :-
  format('~d: ~w~n', [N, H]),
  N1 is N + 1,               
  print_index(T, N1).