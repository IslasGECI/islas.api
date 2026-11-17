function varargout = listIslands
%LISTISLAND Enlista todos los id de islas.json
%   Devuelve un lista con los id de todas las islas que se encuentran en el
%   archivo islas.json
%
%   LISTISLAND despliega la lista de id en la ventana de comandos
%
%   LISTA = LISTISLAND devuelve la lista en el arreglo cell LISTA
%
[varargout{1:nargout}] = enumeration('RegionID');
end

