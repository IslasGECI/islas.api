classdef Island < geoambiental.PolygonInterface & geoambiental.MapInterface
    %ISLAND Clase para manipular información geográfica de las islas
    properties
        Elevacion = geoambiental.Map()
        Islote = islas.Islet()
        Margen = islas.Region()
    end
    properties (Dependent)
        area_ha
        area_km2
        area_m2
        ejes
        Envolvente
        geohash
        lat
        Lat
        LAT
        latMax
        latMin
        lon
        Lon
        LON
        lonMax
        lonMin
        nIslotes
        nombre
        perimetro_km
        perimetro_m
        PuntoMedio
        Recuadro
        valor
        x
        X
        xEje
        xMax
        xMin
        y
        Y
        yEje
        yMax
        yMin
        zonaUTM
    end
    methods
        function Obj = Island(id)
            if nargin ~= 0
                esClaseRegionID = isa(id,'RegionID');
                if ~esClaseRegionID
                    warning('Usa en el constructor un objeto de la clase RegionID');
                    id = RegionID(toolboxes.makeId(id));
                end
                nIds = length(id);
                Obj(1,nIds) = islas.Island();
                shapefileNombres = getShapefileNames();
                shapefilesIds = getShapefilesIds();
                for iId = 1:nIds
                    islaId = id(iId);
                    Obj(iId).Margen = islas.Region(islaId);
                    esCosta = contains(shapefilesIds,"costa");
                    esIsla = contains(shapefilesIds,islaId.char());
                    esShapefile = esCosta & esIsla;
                    if sum(esShapefile) == 1
                        nombreShapefile = shapefileNombres{esShapefile};
                        indUtm = strfind(nombreShapefile,'UTM-');
                        if ~isempty(indUtm)
                            zonaUTM = str2double(nombreShapefile(indUtm+4:indUtm+5));
                        else
                            zonaUTM = 11;
                        end
                    else
                        nombreShapefile = getDefaultShapefileName();
                        zonaUTM = 11;
                    end
                    Obj(iId) = importCoast(Obj(iId),nombreShapefile,zonaUTM);
                    islaNombre = Obj(iId).nombre;
                    esVacio = isempty(Obj(iId).Islote);
                    if esVacio
                        warning(['No encontré la línea de costa de ' islaNombre ' en el archivo ' nombreShapefile]);
                    else
                        disp([islaNombre ': ' nombreShapefile]);
                    end
                end
            end
            function shapefilesIds = getShapefilesIds()
                shapefileNombres = getShapefileNames();
                shapefilesIds = toolboxes.makeId(shapefileNombres);
            end
            function shapefileNombres = getShapefileNames()
                dirDatos = toolboxes.getDataPath;
                shapefile = dir([dirDatos filesep '*.shp']);
                if isempty(shapefile) % Si el directorio compartido de datos no contiene los Shapefiles
                    dirDatos = toolboxes.getDirPath('datos');
                    shapefile = dir([dirDatos filesep '*.shp']);
                    if isempty(shapefile)
                        error('No encontre las líneas de costa. Ejecuta `> make datos` (CMD) en el repositorio `islas` y luego `>> upadateToolbox(RUTA-A-ISLAS)` (MATLAB)')
                    end
                end
                shapefileNombres = cellfun(@(x) [dirDatos filesep x],{shapefile.name},'UniformOutput',false);
            end
            function shapefileNombreDefecto = getDefaultShapefileName()
                dirDatos = toolboxes.getDataPath;
                shapefileNombreDefecto = [dirDatos filesep 'MEX_adm0.shp'];
                if ~exist(shapefileNombreDefecto,'file') % Si el directorio compartido de datos no contiene el Shapefile
                    dirDatos = toolboxes.getDirPath('datos');
                    shapefileNombreDefecto = [dirDatos filesep 'MEX_adm0.shp'];
                    if ~exist(shapefileNombreDefecto,'file')
                        error('No encontre las líneas de costa. Ejecuta `> make datos` (CMD) en el repositorio `islas` y luego `>> upadateToolbox(RUTA-A-ISLAS)` (MATLAB)')
                    end
                end
            end
        end
        function varargout = axis(Isla)
            ejes = Isla.geoaxis();
            if nargout == 1
                varargout{1} = ejes;
            end
        end
        function cuadroDelimitador = boundingbox(Obj)
            cuadroDelimitador = Obj.geoboundingbox();
        end
        function dem(Isla)
            if numel(Isla) > 1
                IslaSuma = sum(Isla);
            else
                IslaSuma = Isla;
            end
            if isempty(IslaSuma.Elevacion)
                IslaSuma = IslaSuma.importHeight();
            end
            mapeo.dem(IslaSuma.Elevacion);
        end
        function disp(Isla)
            nIslas=numel(Isla);
            if nIslas>1
                disp('  Archipiélagos:')
                disp(' ');
                disp([repmat('    ',nIslas,1) char(Isla.id.string.cellstr)])
            end
            disp(' ');
            builtin('disp',Isla) %call builtin
        end
        function esIgual = eq(A,B)
            if numel(A)==1 && numel(B)==1
                A=A.Islote;
                B=B.Islote;
                esIgual = isequal(A,B);
            elseif all(size(A)==size(B))
                esIgual = false(size(A));
                n=numel(A);
                for i=1:n
                    esIgual(i) = eq(A(i),B(i));
                end
            elseif (length(A)==1 || length(B)==1)
                if length(A)==1
                    C=A;
                    A=B;
                    B=C;
                end
                esIgual = false(size(A));
                n=numel(A);
                for i=1:n
                    esIgual(i) = eq(A(i),B);
                end
            else
                error('ERROR: Ambos argumentos de entrada deben ser del mismo tamaño o uno de ellos debe ser de tamaño 1x1');
            end
        end
        function varargout = geoaxis(Obj)
            nObjs = length(Obj);
            if nObjs > 1
                Suma = sum(Obj);
            else
                Suma = Obj;
            end
            ejes = Suma.Margen.geoaxis();
            if nargout==1
                varargout{1} = ejes;
            end
        end
        function cuadroDelimitador = geoboundingbox(Obj)
            cuadroDelimitador = Obj.Margen.geoboundingBox();
        end
        function varargout = geoplot(Isla,varargin)
            nIslotes = sum([Isla.nIslotes]);
            hPlot=gobjects(1,nIslotes);
            nIslas = length(Isla);
            isloteFinal = 0;
            for iIsla=1:nIslas
                isloteInicial = isloteFinal+1;
                isloteFinal = isloteInicial + Isla(iIsla).nIslotes - 1;
                hPlot(isloteInicial:isloteFinal) = Isla(iIsla).Islote.plot(varargin{:});
            end
            if nargout==1
                varargout{1} = hPlot;
            end
        end
        function varargout = geoshow(Obj,varargin)
            hGeoshow = Obj.Islote.geoshow(varargin{:});
            if nargout==1
                varargout{1} = hGeoshow;
            end
        end
        function GeoEstructura = geostruct(Isla)
            GeoEstructura = geostruct(Isla.Islote);
        end
        function varargout = geotext(Isla,propiedad,varargin)
            esHold = ishold;
            nIslas = numel(Isla);
            hText = gobjects(1,nIslas);
            for iIsla=1:nIslas
                texto = Isla(iIsla).(propiedad);
                esTextoVacio = isempty(texto);
                if ~esTextoVacio
                    lat = Isla(iIsla).PuntoMedio.lat;
                    lon = Isla(iIsla).PuntoMedio.lon;
                    hText(iIsla) = text(lon,lat,texto,varargin{:});
                end
                if ((iIsla==1) && (~esHold))
                    hold on
                end
            end
            ejes = axis;
            if all(ejes == [0 1 0 1])
                axis(Isla);
            end
            if ~esHold
                hold off
            end
            if nargout==1
                varargout{1} = hText;
            end
        end
        function area = get.area_ha(Isla)
            if isempty(Isla.Islote)
                area = 0;
            else
                area = sum([Isla.Islote.area_ha]);
            end
        end
        function area = get.area_km2(Isla)
            if isempty(Isla.Islote)
                area = 0;
            else
                area = sum([Isla.Islote.area_km2]);
            end
        end
        function area = get.area_m2(Isla)
            if isempty(Isla.Islote)
                area = 0;
            else
                area = sum([Isla.Islote.area_m2]);
            end
        end
        function Envolvente = get.Envolvente(Isla)
            if isempty(Isla.Islote)
                Envolvente = [];
            else
                Envolvente = Isla.Islote.Envolvente;
            end
        end
        function ejes = get.ejes(Obj)
            ejes = Obj.getGeoaxis();
        end
        function geohash = get.geohash(Isla)
            if isempty(Isla.Islote)
                geohash = [];
            else
                esAdentro = false;
                p = 0;
                while ~esAdentro
                    p = p+1;
                    geohash = islas.encodeGeohash(Isla.PuntoMedio.lat,Isla.PuntoMedio.lon, p);
                    [lat, lon] = islas.decodeGeohash(geohash);
                    esAdentro = inpolygon(lon,lat,Isla.Envolvente.lon,Isla.Envolvente.lat);
                end
            end
        end
        function lat = get.lat(Obj)
            lat = Obj.getPointLat();
        end
        function Lat = get.Lat(Obj)
            Lat = Obj.getAxisLat();
        end
        function LAT = get.LAT(Obj)
            LAT = Obj.getGridLAT();
        end
        function lon = get.lon(Obj)
            lon = Obj.getPointLon();
        end
        function Lon = get.Lon(Obj)
            Lon = Obj.getAxisLon();
        end
        function LON = get.LON(Obj)
            LON = Obj.getGridLON();
        end
        function perimetro_km = get.perimetro_km(Isla)
            if isempty(Isla.Islote)
                perimetro_km = 0;
            else
                perimetro_km = sum([Isla.Islote.perimetro_km]);
            end
        end
        function perimetro_m = get.perimetro_m(Isla)
            if isempty(Isla.Islote)
                perimetro_m = 0;
            else
                perimetro_m = sum([Isla.Islote.perimetro_m]);
            end
        end
        function valor = get.valor(Obj)
            valor = Obj.Elevacion.getValue();
        end
        function x = get.x(Obj)
            x = Obj.getPointX();
        end
        function xEje = get.xEje(Obj)
            xEje = Obj.getAxisX();
        end
        function X = get.X(Obj)
            X = Obj.getGridX();
        end
        function y = get.y(Obj)
            y = Obj.getPointY();
        end
        function yEje = get.yEje(Obj)
            yEje = Obj.getAxisY();
        end
        function Y = get.Y(Obj)
            Y = Obj.getGridY();
        end
        function zonaUTM = get.zonaUTM(Obj)
            zonaUTM = Obj.getUtmZone();
        end
        function latMax = get.latMax(Isla)
            if isempty(Isla.Islote)
                latMax = [];
            else
                latMax = Isla.Islote.getMaxLat();
            end
        end
        function latMin = get.latMin(Isla)
            if isempty(Isla.Islote)
                latMin = [];
            else
                latMin = Isla.Islote.getMinLat();
            end
        end
        function lonMax = get.lonMax(Isla)
            if isempty(Isla.Islote)
                lonMax = [];
            else
                lonMax = Isla.Islote.getMaxLon();
            end
        end
        function lonMin = get.lonMin(Isla)
            if isempty(Isla.Islote)
                lonMin = [];
            else
                lonMin = Isla.Islote.getMinLon();
            end
        end
        function nIslotes = get.nIslotes(Isla)
            nIslotes = length(Isla.Islote);
        end
        function nombre = get.nombre(Isla)
            nIslas = length(Isla);
            nombre = cell(1,nIslas);
            for iIsla = 1:nIslas
                nombre{iIsla} = Isla(iIsla).Margen.nombre;
            end
            if nIslas == 1
                nombre = char(nombre);
            end
        end
        function PuntoMedio = get.PuntoMedio(Isla)
            if isempty(Isla.Islote)
                PuntoMedio = [];
            else
                PuntoMedioIslote = Isla.Islote.PuntoMedio;
                latPuntoMedioIslote = PuntoMedioIslote.lat;
                lonPuntoMedioIslote = PuntoMedioIslote.lon;
                PuntoMedioEnvolvente = Isla.Envolvente.PuntoMedio;
                latPuntoMedioEnvolvente = PuntoMedioEnvolvente.lat;
                lonPuntoMedioEnvolvente = PuntoMedioEnvolvente.lon;
                distancia=sqrt((lonPuntoMedioIslote-lonPuntoMedioEnvolvente).^2+(latPuntoMedioIslote-latPuntoMedioEnvolvente).^2);
                esMinDist = min(distancia) == distancia;
                lat = latPuntoMedioIslote(esMinDist);
                lon = lonPuntoMedioIslote(esMinDist);
                PuntoMedio = geoambiental.Point(lat(1),lon(1));
            end
        end
        function Recuadro = get.Recuadro(Isla)
            if isempty(Isla.Islote)
                Recuadro = [];
            else
                Recuadro = Isla.Margen.Recuadro;
            end
        end
        function xMax = get.xMax(Isla)
            if isempty(Isla.Islote)
                xMax = [];
            else
                xMax = Isla.Islote.getMaxX();
            end
        end
        function xMin = get.xMin(Isla)
            if isempty(Isla.Islote)
                xMin = [];
            else
                xMin = Isla.Islote.getMinX();
            end
        end
        function yMax = get.yMax(Isla)
            if isempty(Isla.Islote)
                yMax = [];
            else
                yMax = Isla.Islote.getMaxY();
            end
        end
        function yMin = get.yMin(Isla)
            if isempty(Isla.Islote)
                yMin = [];
            else
                yMin = Isla.Islote.getMinY();
            end
        end
        function ejes = getAxis(Obj)
            ejes = Obj.getGeoaxis();
        end
        function Lat = getAxisLat(Obj)
            Lat = Obj.Elevacion.getAxisLat();
        end
        function Lon = getAxisLon(Obj)
            Lon = Obj.Elevacion.getAxisLon();
        end
        function xEje = getAxisX(Obj)
            xEje = Obj.Elevacion.getAxisX();
        end
        function yEje = getAxisY(Obj)
            yEje = Obj.Elevacion.getAxisY();
        end
        function recuadro = getFrame(Obj)
            recuadro = Obj.Margen.getFrame();
        end
        function ejes = getGeoaxis(Obj)
            ejes = Obj.Margen.getGeoaxis();
        end
        function LAT = getGridLAT(Obj)
            LAT = Obj.Elevacion.getGridLAT();
        end
        function LON = getGridLON(Obj)
            LON = Obj.Elevacion.getGridLON();
        end
        function X = getGridX(Obj)
            X = Obj.Elevacion.getGridX();
        end
        function Y = getGridY(Obj)
            Y = Obj.Elevacion.getGridY();
        end
        function ejes = getMapaxis(Obj)
            ejes = Obj.Margen.getMapaxis();
        end
        function lat = getPointLat(Obj)
            lat = Obj.Islote.getPointLat();
        end
        function lon = getPointLon(Obj)
            lon = Obj.Islote.getPointLon();
        end
        function x = getPointX(Obj)
            x = Obj.Islote.getPointX();
        end
        function y = getPointY(Obj)
            y = Obj.Islote.getPointY();
        end
        function zonaUTM = getUtmZone(Obj)
            zonaUTM = Obj.Islote.getUtmZone();
        end
        function idIsla = id(Isla)
            nIslas = length(Isla);
            for iIsla = nIslas:-1:1
                idIsla(iIsla) = Isla(iIsla).Margen.id;
            end
        end
        function Isla = importCoast(Isla,archivo,zonaUTM)
            warning('off','map:shapefile:missingDBF')
            warning('off','map:shapefile:buildingIndexFromSHP')
            Costa = shaperead(archivo);
            lat = [Costa.Y];
            lon = [Costa.X];
            if islas.isMap(lon,lat)
                [lat,lon] = utm2ll(lon,lat,zonaUTM);
            end
            nIslas = length(Isla); % número total de archipiélagos
            for iIsla=1:nIslas
                esCosta = inpolygon(lon,lat,Isla(iIsla).Margen.getPointLon,Isla(iIsla).Margen.getPointLat);
                esCosta = esCosta | [esCosta(2:end) false] | [false esCosta(1:end-1)];
                esCosta([find(esCosta,1,'first'), find(esCosta,1,'last')]) = false;
                latCosta = lat(esCosta);
                lonCosta = lon(esCosta);
                latCosta = islas.deleteDoubleNan(latCosta);
                lonCosta = islas.deleteDoubleNan(lonCosta);
                esNan = isnan(latCosta) | isnan(lonCosta);
                indNan = [0 find(esNan) length(esNan)+1];
                nIslotes = length(indNan)-1;
                Islote = [];
                for iIslote=1:nIslotes
                    Islote(iIslote).lat  = [latCosta(indNan(iIslote)+1:indNan(iIslote+1)-1)];
                    Islote(iIslote).lon = [lonCosta(indNan(iIslote)+1:indNan(iIslote+1)-1)];
                end
                Isla(iIsla).Islote = Islote;
            end
        end
        function Obj = importHeight(Obj,outDir)
            if nargin == 1
                outDir = toolboxes.getDataPath;
            end
            nObj = length(Obj);
            for iObj = 1:nObj
                ejes = Obj(iObj).geoaxis;
                Elevacion = geoambiental.importHeight([ejes(3:4) ejes(1:2)], 'outdir', outDir,'srtm1');
                Obj(iObj).Elevacion = Elevacion;
            end
        end
        function varargout = mapaxis(Isla)
            xMin = min([Isla.Margen.xMin]);
            xMax = max([Isla.Margen.xMax]);
            yMin = min([Isla.Margen.yMin]);
            yMax = max([Isla.Margen.yMax]);
            ejes = [xMin xMax yMin yMax];
            axis equal
            axis(ejes);
            if nargout==1
                varargout{1} = ejes;
            end
        end
        function cuadroDelimitador = mapboundingbox(Obj)
            cuadroDelimitador = Obj.Margen.mapboundingBox();
        end
        function varargout = mapplot(Obj,varargin)
            hPlot = Obj.Islote.mapplot(varargin{:});
            if nargout == 1
                varargout{1} = hPlot;
            end
        end
        function varargout = mapshow(Obj,varargin)
            hMapshow = Obj.Islote.mapshow(varargin{:});
            if nargout == 1
                varargout{1} = hMapshow;
            end
        end
        function MapEstructura = mapstruct(Isla)
            MapEstructura = mapstruct(Isla.Islote);
        end
        function varargout = maptext(Isla,propiedad,varargin)
            esHold = ishold;
            nIslas = numel(Isla);
            hText = gobjects(1,nIslas);
            for iIsla=1:nIslas
                texto = Isla(iIsla).(propiedad);
                esTextoVacio = isempty(texto);
                if ~esTextoVacio
                    x = Isla(iIsla).PuntoMedio.X;
                    y = Isla(iIsla).PuntoMedio.Y;
                    hText(iIsla) = text(x,y,texto,varargin{:});
                end
                if ((iIsla==1) && (~esHold))
                    hold on
                end
            end
            ejes = axis;
            if all(ejes == [0 1 0 1])
                axis(Isla);
            end
            if ~esHold
                hold off
            end
            if nargout==1
                varargout{1} = hText;
            end
        end
        function Isla = minus(A,B)
            if numel(A)>1 || numel(B)>1
                error('ERROR: Ambos sumandos (clase islas.Island) deben ser escalares')
            end
            Islote = islas.setdiff(A.Islote,B.Islote);
            Isla = islas.Island();
            Isla.Islote = Islote;
            [lon,lat] = polybool('subtraction',A.Margen.lon,A.Margen.lat,B.Margen.lon,B.Margen.lat);
            Isla.Margen = geoambiental.Polygon(struct('lat',lat,'lon',lon));
        end
        function esDiferente = ne(A,B)
            esDiferente = ~eq(A,B);
        end
        function varargout = pcolor(Obj)
            esHold = ishold;
            if ~esHold
                hold on
            end
            nObjs = length(Obj);
            hPcolor = gobjects(1, nObjs);
            for iObj = 1:nObjs
                hPcolor(iObj) = mapeo.pcolor(Obj(iObj).Elevacion);
            end
            if ~esHold
                hold off
            end
            if nargout == 1
                varargout{1} = hPcolor;
            end
        end
        function varargout = plot(Isla,varargin)
            hPlot = Isla.geoplot(varargin{:});
            if nargout == 1
                varargout{1} = hPlot;
            end
        end
        function Obj = plus(A,B)
            esEscalar = numel(A) == 1 && numel(B) == 1;
            assert(esEscalar, 'ERROR: Ambos sumandos (clase islas.Island) deben ser escalares')
            Islote = union(A.Islote,B.Islote);
            Obj = islas.Island();
            Obj.Islote = Islote;
            lonMargenA = A.Margen.getPointLon;
            latMargenA = A.Margen.getPointLat;
            lonMargenB = B.Margen.getPointLon;
            latMargenB = B.Margen.getPointLat;
            [lon,lat] = polybool('union',lonMargenA,latMargenA,lonMargenB,latMargenB);
            Obj.Margen = geoambiental.Polygon(struct('lat' ,lat,'lon',lon));
        end
        function Isla = set.Islote(Isla,Islote)
            if isempty(Islote)
                Isla.Islote = [];
            else
                esIslote = isa(Islote,'islas.Islet');
                if ~esIslote
                    Islote = islas.Islet(Islote);
                end
                Isla.Islote = Islote;
            end
        end
        function [Isla,varargout] = sort(Isla)
            nIslas = length(Isla);
            if nIslas>1
                geohash = {Isla.geohash};
                [~,ind] = sort(geohash);
                Isla = Isla(ind);
                if nargout==2
                    varargout{1} = ind;
                end
            else
                if nargout==2
                    varargout{1} = nIslas;
                end
            end
        end
        function Obj = sum(A)
            A = A(:)';
            Obj = A(1);
            n = numel(A);
            for i = 2:n
                Obj = plus(Obj,A(i));
            end
        end
        function varargout = text(Isla,propiedad,varargin)
            hText = Isla.geotext(propiedad,varargin{:});
            if nargout == 1
                varargout{1} = hText;
            end
        end
    end
end
