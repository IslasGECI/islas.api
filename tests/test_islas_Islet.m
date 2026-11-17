nombreShapefileMexico = [toolboxes.getDataPath filesep 'MEX_adm0.shp'];
nombreShapefileCoronado = [toolboxes.getDataPath filesep 'coronado_LCosta.shp'];
%% v0.1.0
% |eq| de clase *Islet*. Esta implementado en la superclase *geopolígono*
Isla = islas.Island('todossantos');
Isla = Isla.importCoast(nombreShapefileMexico, 11);
esIgualQueSiMismo = all(Isla.Islote == Isla.Islote);
assert(esIgualQueSiMismo)

%% v0.1.1
% |ne| de clase *Islet*. Esta implementado en la superclase *geopolígono*
Isla = islas.Island('coronado');
Isla = Isla.importCoast(nombreShapefileMexico, 11);
esDiferenteQueSiMismo = any(Isla.Islote ~= Isla.Islote);
assert(~esDiferenteQueSiMismo)
% 
esCadaIsloteDiferenteQuePrimerIslote = Isla.Islote ~= Isla.Islote(1);
expectativa = true(size(esCadaIsloteDiferenteQuePrimerIslote));
expectativa(1) = false;
assert(isequal(esCadaIsloteDiferenteQuePrimerIslote,expectativa));

%% v0.1.2
% Union de conjuntos disjuntos
CoronadoNorte = islas.Island('coronadonorte');
CoronadoSur = islas.Island('coronadosur');
IsloteCoronadoNorte = CoronadoNorte.Islote;
IsloteCoronadoSur = CoronadoSur.Islote;
IsloteCoronadoNorteSur = union(IsloteCoronadoNorte,IsloteCoronadoSur);
nIslotes = length(IsloteCoronadoNorteSur);
nIslotesEsperados = length(IsloteCoronadoNorte)+length(IsloteCoronadoSur);
esCantidadIslotesEsperados = nIslotes == nIslotesEsperados;
assert(esCantidadIslotesEsperados)
% Quiero verificar que se puede acceder al último islote
ultimoGeohash = IsloteCoronadoNorteSur(nIslotes).geohash;
esUltimoVacio = isempty(ultimoGeohash);
assert(~esUltimoVacio)

%% v0.1.3
% Union de conjuntos no disjuntos
Coronado = islas.Island('coronado');
IsloteCoronado = Coronado.Islote;
CoronadoSur = islas.Island('coronadosur');
CoronadoSur = CoronadoSur.importCoast(nombreShapefileCoronado,11);
IsloteCoronadoSur = CoronadoSur.Islote;
IslotesUnionCoronado = union(IsloteCoronado,IsloteCoronadoSur);
nIslotesEsperados = length(IsloteCoronado);
nIslotes = length(IslotesUnionCoronado);
esCantidadIslotesEsperados = nIslotes == nIslotesEsperados;
assert(esCantidadIslotesEsperados)
% Quiero verificar que se puede acceder al último islote
ultimoGeohash = IslotesUnionCoronado(nIslotes).geohash;
esUltimoVacio = isempty(ultimoGeohash);
assert(~esUltimoVacio)

%% v0.1.4
% |union| y |isequal|
CoronadoNorte = islas.Island(RegionID.coronadonorte);
CoronadoMedio = islas.Island(RegionID.coronadomedio);
CoronadoSur = islas.Island(RegionID.coronadosur);
Coronado = islas.Island(RegionID.coronado);
Coronado = Coronado.importCoast(nombreShapefileMexico, 11);
Islote = Coronado.Islote;
IsloteNorte = CoronadoNorte.Islote;
IsloteMedio = CoronadoMedio.Islote;
IsloteSur = CoronadoSur.Islote;
norteUnionMedio = union(IsloteNorte,IsloteMedio);
medioUnionSur = union(IsloteMedio,IsloteSur);
unionIslotes = union(norteUnionMedio,medioUnionSur);
esUnionIgual = isequal(unionIslotes,Islote);
assert(esUnionIgual)