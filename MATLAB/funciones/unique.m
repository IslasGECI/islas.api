function unico = unique(repetido)
[~,indUnico,~] = unique(repetido.getGeohash);
unico = repetido(indUnico);
end