function [lat, lon] = decodeGeohash(geohash)
%DECODEGEOHASH Decode geohash to latitude/longitude (location is approximate
%centre of geohash cell, to reasonable precision)
%
% Chris Veness 2014 / MIT Licence
% http://www.movable-type.co.uk/scripts/geohash.html
% Evaristo.Rojas@islas.org.mx
bounds = islas.boundsGeohash(geohash); % <-- the hard work
% now just determine the centre of the cell...
latMin = bounds.sw.lat;
latMax = bounds.ne.lat;
lonMin = bounds.sw.lon;
lonMax = bounds.ne.lon;
% cell centre
lat = (latMin + latMax)/2;
lon = (lonMin + lonMax)/2;
% round to close to centre without excessive precision: floor(2-log10(?°)) decimal places
lat = round(lat,floor(2-log(latMax-latMin)/log(10)));
lon = round(lon,floor(2-log(lonMax-lonMin)/log(10)));

