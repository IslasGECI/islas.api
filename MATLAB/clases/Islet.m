classdef Islet < geoambiental.Polygon
    %ISLET Clase para representar islotes elementos de archipiélagos
    %
    % Los objetos de la clase ISLET representan los elementos de los
    % conjuntos clase |insular|.
    
    properties
    end
    
    properties (Dependent) % TODO: Eliminar todas las propiedades dependientes y convertilas en métodos
        tamano
    end
    
    methods
        function Obj = Islet(varargin)
            Obj = Obj@geoambiental.Polygon(varargin{:});
        end
        function tamano = get.tamano(Islote)
            area_ha = Islote.area_ha;
            nIslotes = length(Islote);
            tamano = cell(1,nIslotes);
            for iIslote = 1:nIslotes
                caso = ceil(log10(area_ha(iIslote)));
                if caso < 0
                    caso = 0;
                end
                switch caso
                    case 0
                        tamano{iIslote} = 'roca';
                    case 1
                        tamano{iIslote} = 'islote';
                    case 2
                        tamano{iIslote} = 'isla chica';
                    case 3
                        tamano{iIslote} = 'isla mediana';
                    otherwise
                        tamano{iIslote} = 'isla grande';
                end
            end
            if nIslotes==1
                tamano = char(tamano);
            end
        end
        function esIgual = isequal(A,B)
            esAsubconjuntoDeB = all(ismember(A,B));
            esBsubconjuntoDeA = all(ismember(B,A));
            esIgual = esAsubconjuntoDeB && esBsubconjuntoDeA;
        end
        function esElemento = ismember(A,B)
            if strcmpi(class(A),'Islet') && strcmpi(class(B),'Island')
                if numel(B)>1
                    error('ERROR: El segundo argumento (clase Island) debe ser de tamaño 1x1');
                end
                B = B.Islote;
            end
            nA=length(A);
            nB=length(B);
            esElemento = false(size(A));
            for iA=1:nA
                esIgual = false(size(B));
                latA = A(iA).lat;
                lonA = A(iA).lon;
                latA = latA(isfinite(latA));
                lonA = lonA(isfinite(lonA));
                Ai = geoambiental.Polygon(struct('lat',latA,'lon',lonA));
                for iB=1:nB
                    latB = B(iB).lat;
                    lonB = B(iB).lon;
                    latB = latB(isfinite(latB));
                    lonB = lonB(isfinite(lonB));
                    Bi = geoambiental.Polygon(struct('lat',latB,'lon',lonB));
                    esIgual(iB) = eq(Ai,Bi);
                end
                esElemento(iA) = any(esIgual);
            end
        end
        function C = union(A,B)
            latA = islas.deleteDoubleNan(A.getPointLat);
            lonA = islas.deleteDoubleNan(A.getPointLon);
            latB = islas.deleteDoubleNan(B.getPointLat);
            lonB = islas.deleteDoubleNan(B.getPointLon);
            lat = [latA(:); NaN; latB(:)]';
            lon = [lonA(:); NaN; lonB(:)]';
            nIslotes = length(A)+length(B);
            nSeparadoresO = sum(isnan(lat) | isnan(lon));
            nSeparadoresY = sum(isnan(lat) & isnan(lon));
            esCantidadSeparadoresEsperada = nSeparadoresO == nSeparadoresY;
            assert(esCantidadSeparadoresEsperada,'La cantidad de separadores (NaNs) en latitud y longitud no coinciden');
            esCantidadSeparadoresEsperada = nSeparadoresO == nIslotes - 1;
            assert(esCantidadSeparadoresEsperada,'La cantidad de separadores (NaNs) no corresponde a la cantidad de islotes');
            AB = islas.Islet(struct('lat', lat, 'lon', lon));
            C = islas.unique(AB);
        end
    end
end