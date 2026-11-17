% Estas pruebas son de método `importCoast` de la clase `insular`
%
%% v0.1.0
% El método `importCoast` permite que le especifiques el alchivo shapefile
% desde donde se importará la línea de costa. En este ejemplo la línea de
% costa se importará desde el archivo `MEX_adm0.shp`
Isla = islas.Island('coronado');
nombreShapefileMexico = [toolboxes.getDataPath filesep 'MEX_adm0.shp'];
Isla = Isla.importCoast(nombreShapefileMexico,11);
nIslotesEsperados = 3;
assert(Isla.nIslotes == nIslotesEsperados)

%% v0.1.1
% Si no se usa `importCoast` el constructor importara la linea de costa
% desde un archivo shapefile que incluya en su nombre el ID de la isla. En
% este ejemplo, el ID de la isla es `coronado` y la línea de costa la
% leerá desde `coronado_LCosta.shp`
Isla = islas.Island('coronado');
nIslotesEsperados = 7;
assert(Isla.nIslotes == nIslotesEsperados)