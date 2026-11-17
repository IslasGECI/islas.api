Isla = insular(listIslands);
Isla = sort(Isla);
nIslas = numel(Isla);
S(1,nIslas)=struct;
[S.id] = deal(Isla.id);
[S.nombre] = deal(Isla.nombre);
[S.abrev] = deal(Isla.abrev);
for iIsla = 1:nIslas
    S(iIsla).Margen.Latitude  = Isla(iIsla).Margen.Latitude;
    S(iIsla).Margen.Longitude = Isla(iIsla).Margen.Longitude;
end
archivoIslasJSON = [toolboxes.getExtdataPath filesep 'islas.json'];
savejson('',S,archivoIslasJSON);
disp('Archivo modificado en copia local del desarrollador')
disp(archivoIslasJSON)
disp('Recuerda usar updateToolbox para actualizar la toolbox instalada');