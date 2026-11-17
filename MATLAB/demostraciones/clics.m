updateToolbox('\\EVARISTO-PC\islas'), refreshPath
clear, close all,  clc
archivoIslasMAT  = [getDemosPath filesep 'islas.mat'];
archivoIslasJSON = [getExtdataPath filesep 'islas.json'];
load(archivoIslasMAT,'Isla');
nIsla = length(Isla);
Isla_json = loadjson(archivoIslasJSON,'SimplifyCell',1);
nuevasIslas = Isla_json(~ismember({Isla_json.id},{Isla.id}));
nNuevas = length(nuevasIslas);
[Isla(nIsla+1:nIsla+nNuevas).id] = deal(nuevasIslas.id);
for iNuevas=1:nNuevas
    Isla(nIsla+iNuevas).Margen.Latitude  = deal(nuevasIslas(iNuevas).Margen.Latitude);
    Isla(nIsla+iNuevas).Margen.Longitude = deal(nuevasIslas(iNuevas).Margen.Longitude);
end
[~,ind]=ismember({Isla_json.id},{Isla.id});
[Isla(ind).nombre] = deal(Isla_json.nombre);
[Isla(ind).abrev]  = deal(Isla_json.abrev);
%%
esFaltanteEnJSON = ~ismember({Isla.id},{Isla_json.id});
if any(esFaltanteEnJSON)
    disp(['Las siguientes islas no se encuentran en ' archivoIslasJSON])
    disp(char({Isla(~ismember({Isla.id},{Isla_json.id})).id}))
    error('ERROR: Cada isla en islas.mat debe estar presente en islas.json')
end
disp(char({Isla(~ismember({Isla.id},{Isla_json.id})).id}))
%% Copia Isla e inicializa variables para ciclo
Isla2 = rmfield(Isla,'Margen');
margenMin = min(arrayfun(@(x) length(x.Margen),[Isla]));
sonTodasMayorIgual4 = true;
nIslas = length(Isla2);
%%
for i=1:nIslas
    id = makeId(Isla(i).id);
    titulo = Isla(i).nombre;
    ejes = [min(Isla(i).Margen(1).Longitude) max(Isla(i).Margen(1).Longitude) min(Isla(i).Margen(1).Latitude) max(Isla(i).Margen(1).Latitude)];
    lat = ejes(1:2);
    lon = ejes(3:4);
    dx=diff(lon)/2;
    dy=diff(lat)/2;
    ejes = [ejes(1)-dx ejes(2)+dx ejes(3)-dy ejes(4)+dy];
    figure, hold on
    plotMexicoConIslas
    title(titulo)
    axis equal
    axis(ejes)
    drawnow
    nMargen = length(Isla(i).Margen);
    if nMargen == margenMin
        [x,y] = ginput2;
        Isla(i).Margen=[Isla(i).Margen(:)' struct('Latitude',[y(:)' y(1)],'Longitude',[x(:)' x(1)])];
        h = plot(Isla(i).Margen(end).Longitude,Isla(i).Margen(end).Latitude,'k','linewidth',3);
        drawnow; pause(.75);
        h.Visible = 'off';
        nMargen = length(Isla(i).Margen);
    end
    if nMargen >=4
        for k=1:nMargen
            plot(Isla(i).Margen(k).Longitude,Isla(i).Margen(k).Latitude)
        end
        esMama = false;
        esPapa = false;
        while sum(esMama)<2 || sum(esPapa)<2 || (abs(sum(esMama)-sum(esPapa))>1)
            esMama = rand(1,nMargen)>.5;
            esPapa = ~esMama;
        end
        indMama = find(esMama);
        indPapa = find(esPapa);
        nMama = length(indMama);
        nPapa = length(indPapa);
        xMama = Isla(i).Margen(indMama(1)).Longitude;
        yMama = Isla(i).Margen(indMama(1)).Latitude;
        for iMama=2:nMama
            ind=indMama(iMama);
            [xMama,yMama] = polybool('intersection',xMama,yMama,Isla(i).Margen(ind).Longitude,Isla(i).Margen(ind).Latitude);
        end
        patch(xMama, yMama, 1, 'FaceColor', 'r','FaceAlpha', .3)
        xPapa = Isla(i).Margen(indPapa(1)).Longitude;
        yPapa = Isla(i).Margen(indPapa(1)).Latitude;
        for iPapa=2:nPapa
            ind=indPapa(iPapa);
            [xPapa,yPapa] = polybool('intersection',xPapa,yPapa,Isla(i).Margen(ind).Longitude,Isla(i).Margen(ind).Latitude);
        end
        patch(xPapa, yPapa, 1, 'FaceColor', 'b','FaceAlpha', .3)
        [x,y] = polybool('union',xMama,yMama,xPapa,yPapa);
        plot(x,y,'k','linewidth',3);
        Isla2(i).Margen.Latitude  = y;
        Isla2(i).Margen.Longitude = x;
    else
        sonTodasMayorIgual4 = false;
    end
    drawnow
    pause
    close all
end
close all
drawnow
save islas Isla;
ordenaMAT
if sonTodasMayorIgual4
    savejson('',Isla2,archivoIslasJSON);
    ordenaJSON
else
    disp('No son Todas Mayor Igual 4');
end