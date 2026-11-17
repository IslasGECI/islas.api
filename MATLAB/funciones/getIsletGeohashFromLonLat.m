function geohashIslote = getIsletGeohashFromLonLat(Isla,lon,lat)
    if islas.isMap(lon,lat)
        zonaUTM = 11;
        [lat,lon] = utm2ll(lon,lat,zonaUTM);
    end
    esIslote = isInIslet(Isla, lon, lat); % TODO: Este debería ser un método (¿de Island o Islet?)
    geohashIslote = Isla.Islote(esIslote).geohash;  % TODO: Debería regresar un string?
    if ischar(geohashIslote)
        geohashIslote = string(geohashIslote);
    end
end
function esIslote = isInIslet(Isla, lon, lat)  % TODO: Este debería ser un método (¿de Island o Islet?)
    nIslotes = Isla.nIslotes;
    for iIslote = nIslotes:-1:1
        esIslote(iIslote) = inpolygon(lon, lat, Isla.Islote(iIslote).lon,Isla.Islote(iIslote).lat);
    end
end