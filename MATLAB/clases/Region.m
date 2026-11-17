classdef Region < geoambiental.Polygon
    %REGION Clase para representar regiones geográficas
    %
    % Los objetos de la clase REGION representan polígonos que definen
    % dominios de análisis espaciales
    
    properties
        id
        nombre
    end
    
    properties (Dependent)
    end
    
    methods
        function Obj = Region(regionId)
            if nargin ~= 0
                assertIsClassRegionId(regionId)
                RegionesJSON = getJsonRegionsFromId(regionId);
                Geopoligono = [RegionesJSON.Geopoligono];
                id = RegionID({RegionesJSON.id});
                nombre = {RegionesJSON.nombre};
            else
                Geopoligono = struct('lat',[],'lon',[]);
                id = [];
                nombre = [];
            end
            Obj = Obj@geoambiental.Polygon(Geopoligono);
            if ~isempty(id)
                nObjs = length(Obj);
                for iObj = 1:nObjs
                    Obj(iObj).id = id(iObj);
                    Obj(iObj).nombre = nombre{iObj};
                end
            end
            function assertIsClassRegionId(regionId)
                esClaseRegionId = isa(regionId,'RegionID');
                assert(esClaseRegionId, 'El argumento de entrada del constructor debe ser clase <strong>RegionID</strong>')
            end
            function RegionesJSON = getJsonRegionsFromId(regionId)
                nombreArchivoPoligonosJSON = [toolboxes.getTextDataPath filesep 'json' filesep 'poligonos.json'];
                RegionesJSON = loadjson(nombreArchivoPoligonosJSON,'SimplifyCell',1);
                esRegionId = ismember({RegionesJSON.id},regionId);
                RegionesJSON = RegionesJSON(esRegionId);
            end
        end
    end
end