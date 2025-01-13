% Tiago Dias 102613
:- use_module(library(clpfd)). % para pode usar transpose/2
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % ver listas completas
:- [puzzles]. % Ficheiro dado. A avaliação terá mais puzzles.
:- [codigoAuxiliar]. % Ficheiro dado. Não alterar.
% Atenção: não deves copiar nunca os puzzles para o teu ficheiro de código
% Segue-se o código

% Visualiza/1: Escreve por linha cada elemento da lista
visualiza([]).
visualiza([H|T]) :-
  writeln(H),
  visualiza(T). 


% VisualizaLinha/1: Escreve por linha o número da linha e o elemento 
visualizaLinha(Lista) :-      
  printIndex(Lista, 1). 

% printIndex/2: Define o formato e printa o número da linha
printIndex([], _).
printIndex([H|T], N) :-
  format('~d: ~w~n', [N, H]),
  N1 is N + 1,               
  printIndex(T, N1).


% insereObjeto/3: Insere o objeto 'Obj' nas coordenadas (l, C)
insereObjecto((L, C), Tabuleiro, Obj) :-
  nth1(L, Tabuleiro, Linha),
  nth1(C, Linha, Element),
  var(Element), !,                                
  Element = Obj.                    
insereObjecto(_, _, _).


% verificaCompriemnto/2: Verifica se o comprimento das listas é igual
verificaComprimento(L1, L2) :-
  length(L1, Size1),
  length(L2, Size2),
  Size1 =:= Size2.

% insereVariosObjetos/3: Insere os objetos da ListaObjs nas coordenadas 
% da lista ListaCoords
insereVariosObjectos(ListaCoords, Tabuleiro, ListaObjs) :-
  verificaComprimento(ListaCoords, ListaObjs),
  insereVariosObjectosAux(ListaCoords, Tabuleiro, ListaObjs).

% insereVariosObjectosAux/2: Função auxiliar que itera pelas lista 
% e insere os objetos
insereVariosObjectosAux([], _, []).
insereVariosObjectosAux([Coord | RestoCoord], Tabuleiro, [Obj | RestoObj]) :-
  insereObjecto(Coord, Tabuleiro, Obj),
  insereVariosObjectosAux(RestoCoord, Tabuleiro, RestoObj).


% inserePontos/2: Aplica pontos em todas as variáveis da lista
inserePontos(_, []) :- !.
inserePontos(Tabuleiro, [(L, C) | T]) :-
  nth1(L, Tabuleiro, Linha),
  nth1(C, Linha, Element),
  var(Element),                                
  Element = 'p',                   
  inserePontos(Tabuleiro, T), !.
inserePontos(Tabuleiro, [_ | T]) :-
  inserePontos(Tabuleiro, T), !.


% inserePontosVolta/2: Insere pontos nas 8 posições adjacentes à coordenada 
% (L, C)
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

  Array = [
    (Top_left_x, Top_left_y), (Top_mid_x, Top_mid_y), 
    (Top_right_x, Top_right_y), (Mid_left_x, Mid_left_y), 
    (Mid_right_x, Mid_right_y), (Bottom_left_x, Bottom_left_y), 
    (Bottom_mid_x, Bottom_mid_y), (Bottom_right_x, Bottom_right_y)],
  inserePontos(Tabuleiro, Array).


% objetosEmCOordenadas/3: Verifica se o objeto das coordenads (L, C) 
% é igual a Obj para todos os elementos daa lista
objectosEmCoordenadas([], _, []).
objectosEmCoordenadas([(L, C) | T], Tabuleiro, [Obj | RestoObj]) :-
  nth1(L, Tabuleiro, Linha),
  nth1(C, Linha, Element),
  Element = Obj,
  objectosEmCoordenadas(T, Tabuleiro, RestoObj).


% coordObjetos/5: Guarda as coordenadas da lista que contêm objetos do tipo Obj
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


% coordenadasVars/2: É verdade se ListaVars for a lista com as coordenadas das 
% variáveis do tabuleiro
coordenadasVars(Tabuleiro, ListaVars) :-
  findall((L, C), coordenadaVariavel(Tabuleiro, L, C), ListaVars),
  sort(ListaVars, ListaVars).

% coordenadaVariavel/3: Verifica se existe uma variável na coordenada (L, C)
coordenadaVariavel(Tabuleiro, L, C) :-
  nth1(L, Tabuleiro, Linha),
  nth1(C, Linha, Element),
  var(Element).


% fechaListaCoordenadas_H1/2: Função auxiliar para fechaListaCoordenadas
% Insere pontos na coordenadas da lista
fechaListaCoordenadas_H1(_, []) :- !.
fechaListaCoordenadas_H1(Tabuleiro, [(L,C) | T]) :-
  insereObjecto((L,C), Tabuleiro, 'p'),
  fechaListaCoordenadas_H1(Tabuleiro, T).

% fechaListaCoordenadas_H2_3/2: Função auxiliar para fechaListaCoordenadas
% Por cada coordenada insere uma estrela em (L, C) e pontos à volta
fechaListaCoordenadas_H2_3(_, []) :- !.
fechaListaCoordenadas_H2_3(Tabuleiro, [(L,C) | T]) :-
  insereObjecto((L,C), Tabuleiro, 'e'),
  inserePontosVolta(Tabuleiro, (L,C)),
  fechaListaCoordenadas_H2_3(Tabuleiro, T).

% h1: sempre que a linha, coluna ou região associada à lista de coordenadas 
% tiver 2 duas estrelas, enche as restantes coordenadas de pontos;

% h2: sempre que a linha, coluna ou região associada à lista de coordenadas 
% tiver uma única estrela e uma única posição livre, insere uma estrela 
% na posição livre e insere pontos à volta da estrela;

% h3: sempre que a linha, coluna ou região associada à lista de coordenadas 
% não tiver nenhuma estrela e tiver duas únicas posições livres, 
% insere uma estrela em cada posição livre e insere pontos à volta 
% de cada estrela inserida;

% fechaListaCoordenadas/2: Aplica h1, h2 e h3
fechaListaCoordenadas(Tabuleiro, Lista) :-
  coordObjectos('e', Tabuleiro, Lista, _, N),
  N == 2,
  coordObjectos(_, Tabuleiro, Lista, LCO, _),
  fechaListaCoordenadas_H1(Tabuleiro, LCO), !.

fechaListaCoordenadas(Tabuleiro, Lista) :-
  coordObjectos('e', Tabuleiro, Lista, _, N1),
  coordObjectos(_, Tabuleiro, Lista, LCO, N2),
  N1 == 1,
  N2 == 1,
  fechaListaCoordenadas_H2_3(Tabuleiro, LCO), !.

fechaListaCoordenadas(Tabuleiro, Lista) :-
  coordObjectos('e', Tabuleiro, Lista, _, N1),
  coordObjectos(_, Tabuleiro, Lista, LCO, N2),
  N1 == 0,
  N2 == 2,
  fechaListaCoordenadas_H2_3(Tabuleiro, LCO), !.

fechaListaCoordenadas(_, _) :- !.


% fecha/2: Aplica fechaListaCoordenadas nas listas da ListaListasCoord
fecha(_, []) :- !.
fecha(Tabuleiro, [H | T]) :-
  fechaListaCoordenadas(Tabuleiro, H),
  fecha(Tabuleiro, T).


% checkVar/2: Verifica se todos os conjuntos de coordenadas contêm uma variável
checkVar(_, []) :- !.
checkVar(Tabuleiro, [(L, C) | T]) :-
  coordenadaVariavel(Tabuleiro, L, C),
  checkVar(Tabuleiro, T).

% verificaForaSeq/2: Verifica as posições antes e depois de Seq
verificaForaSeq(_, []) :- !.
verificaForaSeq(Tabuleiro, [(L, C) | T]) :-
  nth1(L, Tabuleiro, Linha),
  nth1(C, Linha, Element),
  Element == 'p',
  verificaForaSeq(Tabuleiro, T).

% encontraSequencia/4: Encontra uma sequência de variáveis 
% de tamanho N em ListaCoords
encontraSequencia(Tabuleiro, N, ListaCoords, Seq) :-
  length(ListaCoords, Size),
  Size >= N,
  length(Seq, N),
  append(PreSeq, T, ListaCoords),
  append(Seq, PosSeq, T),
  checkVar(Tabuleiro, Seq),
  verificaForaSeq(Tabuleiro, PreSeq),
  verificaForaSeq(Tabuleiro, PosSeq), !.

encontraSequencia(_, _, _, _) :- fail, !.


% verifica_I_horizontal/3: Verifica se as coordenadas formam uma linha
verifica_I_horizontal((L1, C1), (L2, C2), (L3, C3)) :-
  L1 == L2,
  L1 == L3,
  A is C1 + 1,
  B is C2 + 1,
  C2 == A,
  C3 == B.

% verifica_I_ve=ertical/3: Verifica se as coordenadas formam uma coluna
verifica_I_vertical((L1, C1), (L2, C2), (L3, C3)) :-
  A is L1 + 1,
  B is L2 + 1,
  L2 == A,
  L3 == B,
  C1 == C2,
  C1 == C3.

% aplicaPadraoI/2: Coloca estrelas nas coordendas (L1, C1) e 
% (L3, C3) e pontos em volta
aplicaPadraoI(Tabuleiro, [(L1, C1), (L2, C2), (L3, C3)]) :-
  verifica_I_horizontal((L1, C1), (L2, C2), (L3, C3)),
  insereObjecto((L1, C1), Tabuleiro, 'e'),
  insereObjecto((L3, C3), Tabuleiro, 'e'),
  inserePontosVolta(Tabuleiro, (L1, C1)),
  inserePontosVolta(Tabuleiro, (L3, C3)), !.

aplicaPadraoI(Tabuleiro, [(L1, C1), (L2, C2), (L3, C3)]) :-
  verifica_I_vertical((L1, C1), (L2, C2), (L3, C3)),
  insereObjecto((L1, C1), Tabuleiro, 'e'),
  insereObjecto((L3, C3), Tabuleiro, 'e'),
  inserePontosVolta(Tabuleiro, (L1, C1)),
  inserePontosVolta(Tabuleiro, (L3, C3)), !.


% aplicaPadroes/2: Aplica os Padrões I e T a cada lista de coordenadas
aplicaPadroes(_, []) :- !.
aplicaPadroes(Tabuleiro, [H | T]) :-
  encontraSequencia(Tabuleiro, 3, H, Seq),
  aplicaPadraoI(Tabuleiro, Seq),
  aplicaPadroes(Tabuleiro, T).

aplicaPadroes(Tabuleiro, [H | T]) :-
  encontraSequencia(Tabuleiro, 4, H, Seq),
  aplicaPadraoT(Tabuleiro, Seq),
  aplicaPadroes(Tabuleiro, T).

aplicaPadroes(Tabuleiro, [_ | T]) :-
  aplicaPadroes(Tabuleiro, T).