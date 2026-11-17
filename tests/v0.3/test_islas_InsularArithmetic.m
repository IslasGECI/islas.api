% *ARITMÉTICA DE ISLAS (TEORÍA DE CONJUNTOS)*
%
% Un objeto de la clase |insular| representa un archipiélago. Utilizando el
% lenguaje de _teoría de conjuntos_ aquí definimos un *archipiélago* como
% un _conjunto_ de islotes, e *islote* como un _elemento_ de un
% archipiélago. (La palabra _isla_ no está definida en el contexto de esta
% clase.)
nombreShapefileMexico = [toolboxes.getDataPath filesep 'MEX_adm0.shp'];
%% Arreglos
% Es posible crear un arreglo de islas a partir de un arreglo de IDs. En
% este ejemplo IslasCoronado es de tamaño 1x3 al igual que el argumento del
% constructor.
IdIslasCoronado = [RegionID.coronadonorte,RegionID.coronadomedio,RegionID.coronadosur];
IslasCoronado = islas.Island(IdIslasCoronado);
nIslas = length(IslasCoronado);
esArregloDeIslas = nIslas > 1 & nIslas == length(IdIslasCoronado);
assert(esArregloDeIslas)
figure
IslasCoronado.plot()
IslasCoronado.text('nombre')
IslasCoronado.axis()
title(['Islas Coronado: ' num2str(nIslas) ' islas'])

%% Concatenación

% Es igual crear un arreglo a partir de IDs concatenados que concatenar
% objetos escalares. Ejemplo con Coronado
IdCoronado = [RegionID.coronadonorte,RegionID.coronadomedio,RegionID.coronadosur];
Coronado = islas.Island(IdCoronado);
CoronadoNorte = islas.Island(RegionID.coronadonorte);
CoronadoCentro = islas.Island(RegionID.coronadomedio);
CoronadoSur = islas.Island(RegionID.coronadosur);
CoronadoConcatenado = [CoronadoNorte, CoronadoCentro, CoronadoSur];
Coronado = Coronado.importCoast(nombreShapefileMexico,11);
CoronadoConcatenado = CoronadoConcatenado.importCoast(nombreShapefileMexico,11);
sonEquivalentes = islas.isEquivalent(CoronadoConcatenado, Coronado);
assert(sonEquivalentes);

% Es igual crear un arreglo a partir de IDs concatenados que concatenar
% objetos escalares. Ejemplo con Marietas
IdRedonda = RegionID.marietasredonda;
IdLarga = RegionID.marietaslarga;
IdMarietas = [IdRedonda,IdLarga];
Redonda = islas.Island(IdRedonda);
Larga = islas.Island(IdLarga);
Marietas = islas.Island(IdMarietas);
MarietasConcatenadas = [Redonda, Larga];
sonEquivalentes = islas.isEquivalent(Marietas, MarietasConcatenadas);
assert(sonEquivalentes);

%% Suma

% Suma de arreglo es igual que suma de escalares. Ejemplo con Coronado.
CoronadoArreglo = islas.Island([RegionID.coronadonorte,RegionID.coronadomedio,RegionID.coronadosur]);
CoronadoArreglo = CoronadoArreglo.importCoast(nombreShapefileMexico,11);

CoronadoNorte = islas.Island(RegionID.coronadonorte);
CoronadoCentro = islas.Island(RegionID.coronadomedio);
CoronadoSur = islas.Island(RegionID.coronadosur);
sumaCoronado = CoronadoNorte + CoronadoCentro + CoronadoSur;
sumaCoronado = sumaCoronado.importCoast(nombreShapefileMexico,11);

assert(CoronadoArreglo.sum() == sumaCoronado);
% Archipiélago es igual que suma de escalares. Ejemplo con Coronado.
Coronado = islas.Island(RegionID.coronado);
CoronadoNorte = islas.Island(RegionID.coronadonorte);
CoronadoCentro = islas.Island(RegionID.coronadomedio);
CoronadoSur = islas.Island(RegionID.coronadosur);
sumaCoronado = CoronadoNorte + CoronadoCentro + CoronadoSur;
Coronado = Coronado.importCoast(nombreShapefileMexico,11);
sumaCoronado = sumaCoronado.importCoast(nombreShapefileMexico,11);
assert(Coronado == sumaCoronado);
% Suma de arreglo es igual que archipiélago. Ejemplo con Coronado.
CoronadoArreglo = islas.Island([RegionID.coronadonorte,RegionID.coronadomedio,RegionID.coronadosur]);
Coronado = islas.Island(RegionID.coronado);
CoronadoArreglo = CoronadoArreglo.importCoast(nombreShapefileMexico,11);
Coronado = Coronado.importCoast(nombreShapefileMexico,11);
assert(CoronadoArreglo.sum() == Coronado);
% Suma de un arreglo es igual que suma de escalares. Ejemplo con Marietas.
IdRedonda = RegionID.marietasredonda;
IdLarga = RegionID.marietaslarga;
IdMarietas = [IdRedonda,IdLarga];
MarietasArreglo = islas.Island(IdMarietas);
Redonda = islas.Island(IdRedonda);
Larga = islas.Island(IdLarga);
MarietasSumadas = Redonda + Larga;
sonIguales = MarietasArreglo.sum() == MarietasSumadas;
assert(sonIguales);
% Archipiélago es igual que suma de escalares. Ejemplo con Marietas.
IdMarietas = RegionID.marietas;
IdRedonda = RegionID.marietasredonda;
IdLarga = RegionID.marietaslarga;
Marietas = islas.Island(IdMarietas);
Redonda = islas.Island(IdRedonda);
Larga = islas.Island(IdLarga);
MarietasSumadas = Redonda + Larga;
sonIguales = Marietas == MarietasSumadas;
assert(sonIguales);
% Suma de arreglo es igual que archipiélago. Ejemplo con Marietas.
IdRedonda = RegionID.marietasredonda;
IdLarga = RegionID.marietaslarga;
IdMarietas = [IdRedonda,IdLarga];
MarietasArreglo = islas.Island(IdMarietas);
IdMarietas = RegionID.marietas;
Marietas = islas.Island(IdMarietas);
sonIguales = MarietasArreglo.sum() ==  Marietas;
assert(sonIguales);

%% Resta
% Se pueden restar islas. En este ejemplo, a las islas Coronado se les
% resta Coronado Centro y resulta lo mismo que sumar Coronado Norte más
% Coronado Sur
IslasCoronado = islas.Island(RegionID.coronado);
CoronadoNorte = islas.Island(RegionID.coronadonorte);
CoronadoCentro = islas.Island(RegionID.coronadomedio);
CoronadoSur = islas.Island(RegionID.coronadosur);
CoronadoMenosCentro = IslasCoronado - CoronadoCentro;
CoronadoNorteMasSur = CoronadoNorte + CoronadoSur;
CoronadoMenosCentro = CoronadoMenosCentro.importCoast(nombreShapefileMexico,11);
CoronadoNorteMasSur = CoronadoNorteMasSur.importCoast(nombreShapefileMexico,11);
assert(CoronadoMenosCentro == CoronadoNorteMasSur)

% Restar *Coronado* menos *Coronado Centro* es _casi_ lo mismo que sumar
% *Coronado Norte* más *Coronado Sur*

[fCoronadoMenosCentro,vCoronadoMenosCentro] = poly2fv(CoronadoMenosCentro.Margen.getPointLon,CoronadoMenosCentro.Margen.getPointLat);
[fCoronadoNorteMasSur,vCoronadoNorteMasSur] = poly2fv(CoronadoNorteMasSur.Margen.getPointLon,CoronadoNorteMasSur.Margen.getPointLat);
figure
subplot(1,2,1), hold on
patch('Faces',fCoronadoMenosCentro,'Vertices',vCoronadoMenosCentro,'FaceColor',[.6 .6 .8],'EdgeColor', 'none')
plot(CoronadoMenosCentro,'color',[.4 .4 .6])
axis(CoronadoMenosCentro.Margen)
title('Islas Coronado - Coronado Medio')
subplot(1,2,2), hold on
patch('Faces',fCoronadoNorteMasSur,'Vertices',vCoronadoNorteMasSur,'FaceColor',[.6 .6 .8],'EdgeColor', 'none') 
plot(CoronadoNorteMasSur,'color',[.4 .4 .6])
axis(CoronadoNorteMasSur.Margen)
title('Coronado Norte + Coronado Sur')