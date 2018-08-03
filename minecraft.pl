%MINECRAFT

jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).

item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).


%PUNTO1
tieneItem(Jugador,Item):-
	jugador(Jugador,ListaItems,_),
	member(Item,ListaItems).

sePreocupaPorSuSalud(Jugador):-
	jugador(Jugador,_,_),
	tieneItem(Jugador,Item1),
	tieneItem(Jugador,Item2),
	comestibles(Item1,Item2),
	Item1\=Item2.

comestibles(Item1,Item2):-
	comestible(Item1),
	comestible(Item2).

cantidadDeItem(Jugador,Item,Cantidad):-
	jugador(Jugador,_,_),
	existeItem(Item),
	findall(Item,tieneItem(Jugador,Item),ListaItem),
	length(ListaItem,Cantidad).

existeItem(Item):-
	tieneItem(_,Item).

tieneMasDe(Jugador,Item):-
	jugador(Jugador,_,_),
	cantidadDeItem(Jugador,Item,Cantidad),
	forall((cantidadDeItem(Jugador2,Item,Cantidad2),Jugador2\=Jugador),Cantidad>Cantidad2).

%PUNTO2
%A
hayMonstruos(Lugar):-
	lugar(Lugar,_,Oscuridad),
	Oscuridad>6.

%B
correPeligro(Jugador):-
	jugador(Jugador,_,_),
	lugar(Lugar,ListaJugadores,_),
	member(Jugador,ListaJugadores),
	hayMonstruos(Lugar).
correPeligro(Jugador):-
	estaHambriento(Jugador),
	noItemsComestibles(Jugador).

estaHambriento(Jugador):-
	jugador(Jugador,_,Hambre),
	Hambre<4.
	
noItemsComestibles(Jugador):-
	forall(tieneItem(Jugador,Item),not(comestible(Item))).

%C
nivelPeligrosidad(Lugar,Peligrosidad):-
	lugar(Lugar,ListaPersonas,_),
	not(hayMonstruos(Lugar)),
	findall(Hambriento,(member(Hambriento,ListaPersonas),estaHambriento(Hambriento)),ListaHambrientos),
	length(ListaHambrientos,CantidadHambrientos),
	length(ListaPersonas,PoblacionTotal),
	PoblacionTotal\=0,
	Peligrosidad is CantidadHambrientos/PoblacionTotal*100.
nivelPeligrosidad(Lugar,100):-
	hayMonstruos(Lugar).
nivelPeligrosidad(Lugar,Peligrosidad):-
	lugar(Lugar,_,Oscuridad),
	not(estaPoblado(Lugar)),
	Peligrosidad is Oscuridad*10.

estaPoblado(Lugar):-
	lugar(Lugar,ListaPersonas,_),
	member(_,ListaPersonas).

%PUNTO3
puedeConstruir(Jugador,Item):-
	jugador(Jugador,_,_),
	item(Item,ListaTipoItem),
	forall(member(Objeto,ListaTipoItem),loTiene(Jugador,Objeto)).

loTiene(Jugador,itemSimple(Instrumento,Cantidad)):-  
	cantidadDeItem(Jugador,Instrumento,CantidadMismoInstrumento),
	Cantidad=<CantidadMismoInstrumento.
loTiene(Jugador,itemCompuesto(Item)):-
	puedeConstruir(Jugador,Item).