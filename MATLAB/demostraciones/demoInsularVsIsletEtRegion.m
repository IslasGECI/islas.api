%% Demostración de clase *Insular*
%
%% Diferencia entre |Insular| e |Islet| + |Region|
% *Insular* es una composición de las clases |Islet| y |Region|.
% Revisaremos las propiedades y métodos en los que difieren.
%
%% Diferencia entre las propiedades de |Insular| e |Islet| + |Region|
%
propiedadesInsular = properties('insular');
propiedadesIsletEtRegion = union(properties('Islet'),properties('Region'));
disp(propiedadesInsular(~ismember(propiedadesInsular,propiedadesIsletEtRegion)))
%% 
%
%% Diferencia entre los metodos de |Insular| e |Islet| + |Region|
%
metodosInsular = methods('insular');
metodosIsletEtRegion = union(methods('Islet'),methods('Region'));
disp(metodosInsular(~ismember(metodosInsular,metodosIsletEtRegion)))
%% 
%