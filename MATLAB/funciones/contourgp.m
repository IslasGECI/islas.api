function geoPoligono = contourgp(lon,lat,Z,niveles)
ContourStructure = contourcs(lon,lat,Z,niveles); % Reemplacé la línea 20 de contourcs por: figure; [C, ~] = contour(varargin{:}); close;
nContornos = length(ContourStructure);
esCW = false(1,nContornos);
for iContorno = 1:nContornos
    esCW(iContorno) = ispolycw(ContourStructure(iContorno).X,ContourStructure(iContorno).Y);
end
GeoEstructura = contour2geostruct(ContourStructure(~esCW));
geoPoligono = Geopolygon(GeoEstructura);