function [xtrn, xval, ytrn, yval] = particion_cv(x, y, K, i)
% PARTICION_CV  Devuelve el pliegue i-ésimo de una validación cruzada de K
% pliegues: el pliegue i es el conjunto de validación y el resto el de
% entrenamiento. Los pliegues son bloques consecutivos, así que conviene
% barajar los datos antes.
%
%   [xtrn, xval, ytrn, yval] = particion_cv(x, y, K, i)
%
%   x : patrones por columnas (d x n)
%   y : etiquetas (1 x n)

n = size(x, 2);
limites = round(linspace(1, n + 1, K + 1));
en_val = false(1, n);
en_val(limites(i):limites(i + 1) - 1) = true;

xtrn = x(:, ~en_val);  ytrn = y(:, ~en_val);
xval = x(:, en_val);   yval = y(:, en_val);
end
