nombreArchivoPoligonosJSON = [toolboxes.getTextDataPath filesep 'json' filesep 'poligonos.json'];
%%
% Crea objeto de clase RegionID
RegionNorteId = RegionID.ipbcnorte;
esClaseRegionId = isa(RegionNorteId,'RegionID');
assert(esClaseRegionId)

%%
% Verifica que todos los polígonos enumerados se encuentren en el archivo
% `poligonos.json` y viceversa
poligonosJSON = loadjson(nombreArchivoPoligonosJSON, 'SimplifyCell',1);
IdJSON = {poligonosJSON.id}';
[~, IdEnumerados] = enumeration('RegionID');
esIgual = all(ismember(IdJSON,IdEnumerados)) & all(ismember(IdEnumerados,IdJSON));
assert(esIgual)

%%
% Verifica que se preserve el orden
assert(isequal([RegionID.coronado RegionID.guadalupe RegionID.todossantos], RegionID({'coronado' 'guadalupe' 'todossantos'})))
assert(isequal([RegionID.coronado RegionID.todossantos RegionID.guadalupe], RegionID({'coronado' 'todossantos' 'guadalupe'})))
assert(isequal([RegionID.guadalupe RegionID.coronado RegionID.todossantos], RegionID({'guadalupe' 'coronado' 'todossantos'})))
assert(isequal([RegionID.guadalupe RegionID.todossantos RegionID.coronado], RegionID({'guadalupe' 'todossantos' 'coronado'})))
assert(isequal([RegionID.todossantos RegionID.coronado RegionID.guadalupe], RegionID({'todossantos' 'coronado' 'guadalupe'})))
assert(isequal([RegionID.todossantos RegionID.guadalupe RegionID.coronado], RegionID({'todossantos' 'guadalupe' 'coronado'})))