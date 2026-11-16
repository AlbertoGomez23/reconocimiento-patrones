function [x, y] = barajar(x, y)
% BARAJAR  Desordena aleatoriamente un conjunto de patrones.
%
%   [x, y] = barajar(x, y)
%
%   x : patrones por columnas (d x n)
%   y : etiquetas (1 x n), opcional. Se reordenan igual que x.

orden = randperm(size(x, 2));
x = x(:, orden);
if nargin == 2
    y = y(:, orden);
end
end
