%% Ejemplos de graficado de la clase *insular*
%
%% *ARCHIPIÉLAGOS ESCALARES*
% Una instancia escalar de la clase insular contiene un archipiélago, es
% decir, un conjunto de islotes.
%
tic
%% Ejemplo con Isla Guadalupe
Gpe = insular(RegionID.guadalupe);
fprintf('Guadalupe está constituido por %d archipiélagos\n', length(Gpe))
fprintf('Guadalupe tiene %d elementos insulares\n', Gpe.nIslotes)
%%
% Graficamos su mapa de elevación y línea de costa. Aquí usaré la sintaxis
% vieja pa' que la cuñis se sienta cómoda.
figure, hold on
pcolor(Gpe);
plot(Gpe,'color','w');
text(Gpe,'nombre');
axis(Gpe)
%%
% Tambien podemos usar los métodos |geoshow| y |mapshow|. El método
% |geoshow| usa cooredenadas geográficas.
figure
geoshow(Gpe);
%%
% El método |maphow| usa cooredenadas UTM. A partir de aquí usaré la
% sintaxis nueva porque el Efrén se confunde.
figure
Gpe.mapshow();
%%
% Tambien podemos usar el método |dem| basado en la función de François
% Beauducel
figure
Gpe.dem();

%% *PROPIEDAD |ISLOTE|*
% Un archipiélago es un conjunto de elementos insulares. En este ejemplo
% Guadalupe representa un archipiélago con 14 elementos insulares. La
% propiedad |Islote| contiene los elementos insulares.
%% *Graficado de punto medio de un archipiélago y punto medio de sus islotes*
% Graficaré un asterisco en el punto medio del archipiélago y unas bolitas
% en el punto medio de cada elemento insular.
%% Ejemplo con Islas Coronado
Coronado = insular(RegionID.coronado);
%%
% Primero graficamos el archipiélago y su punto medio
figure, hold on
Coronado.plot();
Coronado.axis();
Coronado.PuntoMedio.plot('*','markersize',10);

%%
% y luego graficamos el punto medio de cada islote
PuntoMedioIslotes = Coronado.Islote.PuntoMedio;
PuntoMedioIslotes.plot('.','markersize',15);
%%
% Por último, le ponemos un título a la figura
title(Coronado.nombre);

%% Ejemplo con Islas Todos Santos
TodosSantos = insular(RegionID.todossantos);
%%
% De regreso a la sintaxis de la cuñis. Primero graficamos el archipiélago
% y su punto medio
figure, hold on
plot(TodosSantos);
plot(TodosSantos.PuntoMedio,'*','markersize',10);
axis(TodosSantos);
title(TodosSantos.nombre);

%%
% y luego graficamos el punto medio de cada islote
plot(TodosSantos.Islote.PuntoMedio,'.','markersize',15);

%% *Tamaño de los elementos*
% Una de las propiedades de |Islote| (clase *Islet*) es el tamaño. Segun su
% área, un elemento insular puede ser clasificado como: _isla grande_,
% _isla mediana_, _isla chica_, _islote_ o _roca_.
%% Ejemplo con Islas Coronado
Coronado = insular(RegionID.coronado);
figure, hold on
Coronado.plot();
Coronado.Islote.text('tamano')
Coronado.axis();
%% Ejemplo con Islas Todos Santos
TodosSantos = insular(RegionID.todossantos);
figure, hold on
TodosSantos.plot();
TodosSantos.Islote.text('tamano')
TodosSantos.axis();
%% Ejemplo con Isla Guadalupe
Guadalupe = insular(RegionID.guadalupe);
figure, hold on
plot(Guadalupe);
text(Guadalupe.Islote,'tamano')
axis(Guadalupe)

%% *ARCHIPIELAGOS VECTORIALES*
% Esposible guardar en un arreglo un conjunto de archipiélagos, donde cada
% archipiélago representa un conjunto de islotes.
%
%% Ejemplo con Islas del Pacífico
mlId = [RegionID.coronado, RegionID.todossantos, RegionID.sanmartin, RegionID.sanjeronimo, RegionID.natividad, RegionID.sanroque, RegionID.asuncion];
ML = insular(mlId);
%%
%
figure, hold on
islas.plotMexicoSinIslas
ML.pcolor();
ML.plot('color','w');
ML.text('nombre');
ML.axis();
%%
% Hacemos un acercamiento a Islas Todos Santos
esTS = ML.id == "todossantos";
ML(esTS).axis();

%% Ejemplo con Aves Marinas Endémicas
alianzaId = RegionID({'guadalupe','sanbenito','natividad','partida','sanpedromartir','farallondesanignacio','revillagigedo'});
Alianza = insular(alianzaId);
%%
%
figure, hold on
islas.plotMexicoSinIslas
Alianza.pcolor();
Alianza.plot('color','w');
Alianza.text('nombre');
Alianza.axis();

%% Ejemplo con todas las islas
% Guardamos en la variable |todasId| la lista de los IDs de las islas y
% luego cargamos todas las islas en la variable |TodasIslas|
todasId = islas.listIslands;
TodasIslas = insular(todasId)
%%
% Graficamos la línea de costa de México con la función |plotMexicoSinIslas|
% y graficamos las islas con la fucnión |plot| (la cual ha sido
% sobrecargada para objetos clase _insular_)
figure, hold on
islas.plotMexicoSinIslas
TodasIslas.plot();
TodasIslas.text('nombre');
TodasIslas.axis();
%%
%
drawnow;
pause(1);
toc