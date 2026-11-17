function geohash = encodeGeohash(lat, lon, precision)
%ENCODEGEOHASH  Encodes latitude/longitude to geohash, either to specified
%precision or to automatically evaluated precision.
% Chris Veness 2014 / MIT Licence
% http://www.movable-type.co.uk/scripts/geohash.html
% Evaristo.Rojas@islas.org.mx
base32 = '0123456789bcdefghjkmnpqrstuvwxyz';
idx = 0; % index into base32 map
bit = 0; % each char holds 5 bits
evenBit = true;
geohash = '';
latMin =  -90; latMax =  90;
lonMin = -180; lonMax = 180;

% infer precision?
if nargin == 2
    % refine geohash until it matches precision of supplied lat/lon
    posn.lat = NaN;
    posn.lon = NaN;
    p = 0;
    while p<12 && (posn.lat~=lat || posn.lon~=lon)
        p=p+1;
        geohash = islas.encodeGeohash(lat, lon, p);
        [posn.lat posn.lon] = islas.decodeGeohash(geohash);
    end
elseif nargin == 3
    while (length(geohash) < precision)
        if (evenBit)
            % bisect E-W longitude
            lonMid = (lonMin + lonMax) / 2;
            if (lon > lonMid)
                idx = idx*2 + 1;
                lonMin = lonMid;
            else
                idx = idx*2;
                lonMax = lonMid;
            end
        else
            % bisect N-S latitude
            latMid = (latMin + latMax) / 2;
            if (lat > latMid)
                idx = idx*2 + 1;
                latMin = latMid;
            else
                idx = idx*2;
                latMax = latMid;
            end
        end
        evenBit = ~evenBit;
        bit=bit+1;
        if (bit == 5)
            % 5 bits gives us a character: append it and start over
            geohash = [geohash base32(idx+1)];
            bit = 0;
            idx = 0;
        end
    end
end

