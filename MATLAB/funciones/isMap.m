function esMap = isMap(zonal,meridional)
import islas.isGeo
%ISMAP Determina si las coordenadas están proyectadas
%   Regresa true si las coordenadas están proyectadas o false si las
%   coordenadas son geográficas.
esMap = ~isGeo(zonal,meridional);
end