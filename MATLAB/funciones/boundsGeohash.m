function bounds = boundsGeohash(geohash)
%BOUNDSGEOHASH Returns SW/NE latitude/longitude bounds of specified geohash
%
% Chris Veness 2014 / MIT Licence
% http://www.movable-type.co.uk/scripts/geohash.html
% Evaristo.Rojas@islas.org.mx
base32 = '0123456789bcdefghjkmnpqrstuvwxyz';
if (isempty(geohash))
    error('Invalid geohash');
end
geohash = lower(geohash);
evenBit = true;
latMin =  -90;
latMax =   90;
lonMin = -180;
lonMax =  180;
for i=1:length(geohash)
    chr = geohash(i);    
    idx = find(chr==base32, 1);
    if isempty(idx)
        error('Invalid geohash');
    end
    bit = dec2base(idx-1,2);
    nBits = length(bit);
    bit = [repmat('0',1,5-nBits) bit];
    for n=4:-1:0
        bitN = bit(end-n);
        if (evenBit) 
            % longitude
            lonMid = (lonMin+lonMax) / 2;
            if (bitN == '1')
                lonMin = lonMid;
            else
                lonMax = lonMid;
            end
        else
            % latitude
            latMid = (latMin+latMax) / 2;
            if (bitN == '1') 
                latMin = latMid;
            else
                latMax = latMid;
            end
        end
        evenBit = ~evenBit;
    end
end

bounds = struct('sw', struct('lat',latMin,'lon',lonMin), ...
                'ne', struct('lat',latMax,'lon',lonMax));
