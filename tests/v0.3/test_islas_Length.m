clear, close all
Isla = islas.Island(RegionID.coronado);
Isla = Isla.importCoast([toolboxes.getDataPath filesep 'coronado_LCosta.shp'],11);
hashEsperado = 505925;
nPuntosEsperados = 3386;
nIslotesEsperados = 7;
nSeparadoresEsperados = nIslotesEsperados-1;
getHash = @(Islote) round(nansum([abs(Islote.lat) abs(Islote.lon)]));

%% insular. Verifica que se lee la línea de costa que se desea
Islote = struct;
Islote.lat = Isla.Islote.getPointLat();
Islote.lon = Isla.Islote.getPointLon();
hash = getHash(Islote);
esHashEsperado = hash == hashEsperado;
assert(esHashEsperado);

%% insular. Cantidad de puntos en la línea de costa concatenada
lat = Isla.Islote.getPointLat();
lon = Isla.Islote.getPointLon();
nLatitud = length(lat);
nLongitud = length(lon);
esTamanoEsperado = nLatitud == nPuntosEsperados & nLongitud == nPuntosEsperados;
assert(esTamanoEsperado);

%% insular. Cantidad de separadores en la línea de costa concatenada
lat = Isla.Islote.getPointLat();
lon = Isla.Islote.getPointLon();
nSeparadoresLatitud = sum(isnan(lat));
nSeparadoresLongitud = sum(isnan(lon));
esSeparadoresEsperados = nSeparadoresLatitud == nSeparadoresEsperados & ...
                         nSeparadoresLongitud == nSeparadoresEsperados;
assert(esSeparadoresEsperados)

%% insular. Cantidad de islotes
nIslotesEnArchipielago = Isla.nIslotes;
assert(nIslotesEnArchipielago == nIslotesEsperados);
nIslotes = length(Isla.Islote);
assert(nIslotes == nIslotesEsperados)

%% Islet. Verifica que se lee la línea de costa que se desea
lat = Isla.Islote.getPointLat();
lon = Isla.Islote.getPointLon();
Estructura = struct('lat', lat, 'lon', lon);
Islote = islas.Islet(Estructura);
esClaseIslet = isa(Islote,'islas.Islet');
assert(esClaseIslet)
hash = getHash(struct('lat', Islote.getPointLat(), 'lon', Islote.getPointLon()));
esHashEsperado = hash == hashEsperado;
assert(esHashEsperado);

%% Islet. Cantidad de puntos en la línea de costa concatenada
Estructura = struct('lat', Isla.Islote.getPointLat(), 'lon', Isla.Islote.getPointLon());
Islote = islas.Islet(Estructura);
lat = Islote.getPointLat();
lon = Islote.getPointLon();
nLatitud = length(lat);
nLongitud = length(lon);
esTamanoEsperado = nLatitud == nPuntosEsperados & nLongitud == nPuntosEsperados;
assert(esTamanoEsperado);

%% Islet. Cantidad de separadores en la línea de costa concatenada
Estructura = struct('lat', Isla.Islote.getPointLat(), 'lon', Isla.Islote.getPointLon());
Islote = islas.Islet(Estructura);
lat = Islote.getPointLat();
lon = Islote.getPointLon();
nSeparadoresLatitud = sum(isnan(lat));
nSeparadoresLongitud = sum(isnan(lon));
esSeparadoresEsperados = nSeparadoresLatitud == nSeparadoresEsperados & ...
                         nSeparadoresLongitud == nSeparadoresEsperados;
assert(esSeparadoresEsperados)

%% Islet. Cantidad de islotes
Estructura = struct('lat', Isla.Islote.getPointLat(), 'lon', Isla.Islote.getPointLon());
Islote = islas.Islet(Estructura);
nIslotes = length(Islote);
assert(nIslotes == nIslotesEsperados)

