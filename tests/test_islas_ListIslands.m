nombreArchivoPoligonosJSON = [toolboxes.getTextDataPath filesep 'json' filesep 'poligonos.json'];
poligonosJSON = loadjson(nombreArchivoPoligonosJSON, 'SimplifyCell',1);
%%
todas = islas.listIslands;
Isla = islas.Island(todas);
nIslasObtenidas = length(Isla);
nIslasEsperadas = length(poligonosJSON);
assert(nIslasObtenidas == nIslasEsperadas)

%%
% Verifica que todos los polígonos enumerados se encuentren en el archivo
% `poligonos.json` y viceversa
IdJSON = {poligonosJSON.id}';
[~, IdEnumerados] = islas.listIslands;
esIgual = all(ismember(IdJSON,IdEnumerados)) & all(ismember(IdEnumerados,IdJSON));
assert(esIgual)