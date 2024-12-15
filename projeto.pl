% Tiago Dias 102613
:- use_module(library(clpfd)). % para pode usar transpose/2
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % ver listas completas
:- [puzzles]. % Ficheiro dado. A avaliação terá mais puzzles.
:- [codigoAuxiliar]. % Ficheiro dado. Não alterar.
% Atenção: não deves copiar nunca os puzzles para o teu ficheiro de código
% Segue-se o código

visuliza([]) :- !.
visuliza([H | T]) :-
  writeln(H),
  visuliza(T).