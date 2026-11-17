%% Demostración de clase *Region*
%
%% Diferencia entre |Region| y |Geopolygon|
% *Region* es subclase de *Geopolygon*. Revisaremos las propiedades y
% métodos en los que difieren.
%
%% Diferencia entre las propiedades de |Region| y |Geopolygon|
%
propiedadesRegion = properties('Region');
propiedadesGeopoligono = properties('Geopolygon');
disp(propiedadesRegion(~ismember(propiedadesRegion,propiedadesGeopoligono)))
%% 
% Actualmente, todas las propiedades de |Region| las hereda de |Geopolygon|
%
%% Diferencia entre métodos de |Region| y |Geopolygon|
%
metodosRegion = methods('Region');
metodosGeopoligono = methods('Geopolygon');
disp(metodosRegion(~ismember(metodosRegion,metodosGeopoligono)))
%%
% Exceptuando al constuctor, todos los métodos de |Region| los hereda de
% |Geopolygon|
%
