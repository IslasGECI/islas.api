%% v0.1.0
% Crea objeto de clase Region
RegionNorteId = RegionID.ipbcnorte;
RegionNorte = islas.Region(RegionNorteId);
esClaseRegion = isa(RegionNorte,'islas.Region');
assert(esClaseRegion)

%% v0.1.1
% Crea arreglos de objeto de clase Region
RegionesId = [RegionID.ipbcnorte RegionID.ipbcsur];
Regiones = islas.Region(RegionesId);
esTamanoIgual = length(RegionesId) == length(Regiones);
assert(esTamanoIgual)
