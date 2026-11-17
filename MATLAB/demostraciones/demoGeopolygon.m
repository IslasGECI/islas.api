Coronado = insular(RegionID.coronado);
Geopoligono = Geopolygon(struct(Coronado.Islote));
%% Propiedades:
properties(Geopoligono)
%% Geopoligono.Zone
disp(Geopoligono.Zone)
%% Geopoligono.area_ha
disp(Geopoligono.area_ha)
%% Geopoligono.area_km2
disp(Geopoligono.area_km2)
%% Geopoligono.area_m2
disp(Geopoligono.area_m2)
%% Geopoligono.ejes
disp(Geopoligono.ejes)
%% Geopoligono.geohash
disp(Geopoligono.geohash)
%% Geopoligono.latMax
disp(Geopoligono.latMax)
%% Geopoligono.latMin
disp(Geopoligono.latMin)
%% Geopoligono.lonMax
disp(Geopoligono.lonMax)
%% Geopoligono.lonMin
disp(Geopoligono.lonMin)
%% Geopoligono.perimetro_m
disp(Geopoligono.perimetro_m)
%% Geopoligono.perimetro_km
disp(Geopoligono.perimetro_km)
%% Geopoligono.perimetroEnvolvente_m
disp(Geopoligono.perimetroEnvolvente_m)
%% Geopoligono.perimetroEnvolvente_km
disp(Geopoligono.perimetroEnvolvente_km)
%% Geopoligono.PuntoMedio
disp(Geopoligono.PuntoMedio)
%% Geopoligono
disp(Geopoligono)

%% Métodos:

methods(Geopoligono)

%% axis(Geopoligono)
axis(Geopoligono)
CoronadoNorte = insular(RegionID.coronadonorte);
B = Geopolygon(struct(CoronadoNorte.Islote));
esB = strcmpi(Geopoligono.geohash,B.geohash);
A = Geopoligono(esB);
%% A == B
disp(A == B)

C = Geopolygon(struct(Coronado.Margen));
D = Geopolygon(struct(Coronado.Margen));
%% C == D
disp(C == D)
%% B == C
disp(B == C)
%% B ~= C
disp(B ~= C)
%% plot(Geopoligono)
plot(Geopoligono)
%% Geopoligono2=sort(Geopoligono)
Geopoligono2=sort(Geopoligono);
disp(Geopoligono2)
%% text(Geopoligono,'geohash')
text(Geopoligono,'geohash')


