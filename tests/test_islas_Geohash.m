nombreShapefileGpe = [toolboxes.getDataPath filesep 'guadalupe_LCosta.shp'];
Guadalupe = islas.Island(RegionID.guadalupezapato);
Guadalupe = Guadalupe.importCoast(nombreShapefileGpe,11);
isloteID = "9m5uh";
geohashIslotes = Guadalupe.Islote.getGeohash;
esIslote = geohashIslotes == isloteID;
Islote = Guadalupe.Islote(esIslote);
lat = Islote.PuntoMedio.lat;
lon = Islote.PuntoMedio.lon;
geohashPuntoMedio = islas.encodeGeohash(lat,lon);
%%
[latitud, longitud] = islas.decodeGeohash(geohashPuntoMedio);
latError = abs(latitud-lat);
lonError = abs(longitud-lon);
toleranciaError = 1/360000; % 1/360000 = Una cent�cima de segundo de arco son 30 cm aproximadamente
esErrorTolerable = latError < toleranciaError & lonError < toleranciaError;
assert(esErrorTolerable)
%%
figure, hold on
Islote.plot();
hGeoplot = Islote.PuntoMedio.geoplot();
hPlot = plot(lon,lat,'o');
esPuntoIgual = hGeoplot.XData == hPlot.XData & hGeoplot.YData == hPlot.YData;
assert(esPuntoIgual)
%%
nIslotes = Guadalupe.nIslotes;
for iIslote = nIslotes:-1:1
    esPuntoMedio(iIslote) = contains(geohashPuntoMedio,geohashIslotes(iIslote));
end
esGeohashIgualID = geohashIslotes(esPuntoMedio) == isloteID;
assert(esGeohashIgualID);
%%
clear esIslote
lon = -118.2832;
lat = 28.8484;
geohashIslote = islas.getIsletGeohashFromLonLat(Guadalupe,lon,lat);
esIslote = geohashIslotes == geohashIslote;
figure, hold on
Guadalupe.Islote(esIslote).plot()
plot(lon,lat,'*')
esGeohashIgualID = Guadalupe.Islote(esIslote).geohash == isloteID;
assert(esGeohashIgualID);

