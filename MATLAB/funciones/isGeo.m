function esGeo = isGeo(zonal,meridional)
%ISGEO Determina su las coordenadas son geográficas
%   Regresa true si las coordenadas son geográficas o false si las
%   coordenadas están proyectadas.
esGeo = nanmax(abs(zonal(:))) <= 360 && nanmax(abs(meridional(:))) <= 90;
end