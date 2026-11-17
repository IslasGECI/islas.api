%% v0.1.0
% Contructor sin argumentos
gpe = islas.Island();
assert(isa(gpe,'islas.Island'))

%% v0.1.1
% Contructor con argumento _char_
gpe = islas.Island('guadalupe');
assert(isa(gpe,'islas.Island'))

%% v0.1.2
% Contructor con clase de enumeración RegionID
gpe = islas.Island(RegionID.guadalupe);
assert(isa(gpe,'islas.Island'))

%% v0.1.3
% Contructor con _cell_ de _char_
RegionesID = {'coronado', 'todossantos'};
Islas = islas.Island(RegionesID);
assert(isa(Islas,'islas.Island'))
estamanoCorrecto = length(RegionesID) == length(Islas);
assert(estamanoCorrecto)

%% v0.1.4
% Contructor con arreglo de objetos clase RegionID
RegionesID = [RegionID.coronado RegionID.todossantos];
Islas = islas.Island(RegionesID);
assert(isa(Islas,'islas.Island'))
estamanoCorrecto = length(RegionesID) == length(Islas);
assert(estamanoCorrecto)
