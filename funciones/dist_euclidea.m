function d = dist_euclidea(x, c)
% DIST_EUCLIDEA  Distancia euclídea de cada patrón de x a un punto c.
%
%   d = dist_euclidea(x, c)
%
%   x : patrones por columnas (d x n)
%   c : punto de referencia (d x 1), por ejemplo un centroide
%   d : distancias (1 x n)

d = sqrt(sum((x - c).^2, 1));
end
