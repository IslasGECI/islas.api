%% Constructor acepta enumeraciones RegionID
idTodosSantos = RegionID.todossantos;
TodosSantos = islas.Island(idTodosSantos);
esIslaClaseInsular = isa(TodosSantos,'islas.Island');
assert(esIslaClaseInsular)

%% Propiedad Margen es clase Region
idTodosSantos = RegionID.todossantos;
TodosSantos = islas.Island(idTodosSantos);
Margen = TodosSantos.Margen;
esMargenClaseRegion = isa(Margen,'islas.Region');
assert(esMargenClaseRegion)

%% El Margen es una región
idTodosSantos = RegionID.todossantos;
TodosSantos = islas.Island(idTodosSantos);
Margen = TodosSantos.Margen;
esMargenIgualQueRegion = Margen == islas.Region(idTodosSantos);
assert(esMargenIgualQueRegion)

%% ID de entrada es igual a la propiedad `id` de la región
idTodosSantos = RegionID.todossantos;
TodosSantos = islas.Island(idTodosSantos);
Margen = TodosSantos.Margen;
idMargen = Margen.id;
esIdClaseRegionID = isa(idMargen,'RegionID');
assert(esIdClaseRegionID)
assert(idMargen == idTodosSantos)

%% ID de entrada es igual a la propiedad `id` de la isla
idTodosSantos = RegionID.todossantos;
TodosSantos = islas.Island(idTodosSantos);
idRegion = TodosSantos.id;
esIdClaseRegionID = isa(idRegion,'RegionID');
assert(esIdClaseRegionID)
assert(idRegion == idTodosSantos)

%% Geohash
idAsuncion = RegionID.asuncion;
Asuncion = islas.Island(idAsuncion);
geohashTodos = Asuncion.Islote.getGeohash;
esGeohashString = isstring(geohashTodos);
assert(esGeohashString);
esGeohashTodosTamanoCorrecto = length(geohashTodos) == Asuncion.nIslotes;
assert(esGeohashTodosTamanoCorrecto);
geohashUno = Asuncion.Islote(1).geohash;
esGeohashUnoString = isstring(geohashUno);
assert(esGeohashUnoString);
esGeohashUnoTamanoCorrecto = length(geohashUno.char()) == 7;
assert(esGeohashUnoTamanoCorrecto);

%% Separadores NaNs
idAsuncion = RegionID.asuncion;
Asuncion = islas.Island(idAsuncion);
x = Asuncion.Islote.getPointX;
y = Asuncion.Islote.getPointY;
esNanX = isnan(x);
esNanEsperadoX = sum(esNanX) == Asuncion.nIslotes-1;
assert(esNanEsperadoX)
esNanY = isnan(y);
esNanEsperadoY = sum(esNanY) == Asuncion.nIslotes-1;
assert(esNanEsperadoY)
esNanIgualXY = isequal(esNanX,esNanY);
assert(esNanIgualXY)

%% Mínimo de isla es igual que el mínimo de los mínimos de los islotes
idAsuncion = RegionID.asuncion;
Asuncion = islas.Island(idAsuncion);
nIslotes = Asuncion.nIslotes;
xMinCadaIslote(nIslotes) = 0;
for iIslote = 1:nIslotes
    xMinCadaIslote(iIslote) = Asuncion.Islote(iIslote).xMin;
end
xMin = Asuncion.Islote.getMinX();
assert(xMin == min(xMinCadaIslote))
assert(min(xMinCadaIslote) ~= max(xMinCadaIslote))

%% Máximo de isla es igual que el máximo de los máximos de los islotes
idAsuncion = RegionID.asuncion;
Asuncion = islas.Island(idAsuncion);
nIslotes = Asuncion.nIslotes;
latMaxCadaIslote(nIslotes) = 0;
for iIslote = 1:nIslotes
    latMaxCadaIslote(iIslote) = Asuncion.Islote(iIslote).latMax;
end
latMax = Asuncion.Islote.getMaxLat();
assert(latMax == max(latMaxCadaIslote))
assert(min(latMaxCadaIslote) ~= max(latMaxCadaIslote))

%% Mínimo de isla es igual que mínimo de islotes
idAsuncion = RegionID.asuncion;
Asuncion = islas.Island(idAsuncion);
xMinIsla = Asuncion.xMin;
xMinIslote = Asuncion.Islote.getMinX;
esXMinIslaIgualXMinIslote = xMinIsla == xMinIslote;
assert(esXMinIslaIgualXMinIslote)

%% Máximo de isla es igual que máximo de islotes
idAsuncion = RegionID.asuncion;
Asuncion = islas.Island(idAsuncion);
latMaxIsla = Asuncion.latMax;
latMaxIslote = Asuncion.Islote.getMaxLat();
esLatMaxIslaIgualLatMaxIslote = latMaxIsla == latMaxIslote;
assert(esLatMaxIslaIgualLatMaxIslote)

%% Salida del método getArea_m2 es del tamaño esperado
idAsuncion = RegionID.asuncion;
Asuncion = islas.Island(idAsuncion);
area = Asuncion.Islote.getArea_m2;
tamanoArea = length(area);
nIslotes = Asuncion.nIslotes;
esAreaTamanoEsperado = tamanoArea == nIslotes;
assert(esAreaTamanoEsperado)
esAreaNumerica = isnumeric(area);
assert(esAreaNumerica)

%% Recuadros
idAsuncion = RegionID.asuncion;
Asuncion = islas.Island(idAsuncion);

ejesAsuncion = Asuncion.axis();
cajaMargen = Asuncion.Margen.boundingbox();
cajaMargen = cajaMargen(:)';
esCajaAsuncionIgualCajaMargen = isequal(ejesAsuncion , cajaMargen);
assert(esCajaAsuncionIgualCajaMargen)

cajaRecuadro = Asuncion.Recuadro.boundingbox();
cajaRecuadro = cajaRecuadro(:)';
esCajaAsuncionIgualCajaRecuadro = isequal(ejesAsuncion , cajaRecuadro);
assert(esCajaAsuncionIgualCajaRecuadro)

esCajaMargenIgualCajaRecuadro = isequal(cajaMargen , cajaRecuadro);
assert(esCajaMargenIgualCajaRecuadro)

cajaIsloteAsuncion = Asuncion.Islote.boundingbox();
cajaIsloteRecuadro = Asuncion.Islote.getFrame().boundingbox();
esCajaIsloteAsuncionIgualCajaIsloteRecuadro = isequal(cajaIsloteAsuncion , cajaIsloteRecuadro);
assert(esCajaIsloteAsuncionIgualCajaIsloteRecuadro)


%% Area de isla igual a suma de area de islotes
idAsuncion = RegionID.asuncion;
Asuncion = islas.Island(idAsuncion);
areaIslotesAsuncion = Asuncion.Islote.getArea_m2;
assert(Asuncion.area_m2 == sum(areaIslotesAsuncion));
tamanoAreaIslotes = length(areaIslotesAsuncion);
assert(tamanoAreaIslotes == Asuncion.nIslotes)
