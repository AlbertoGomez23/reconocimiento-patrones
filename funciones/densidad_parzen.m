function p = densidad_parzen(xtrn, xeval, sigma)
% DENSIDAD_PARZEN  Estimación de densidad por ventanas de Parzen con núcleo
% gaussiano esférico de anchura sigma.
% La densidad en un punto es la media de las gaussianas centradas en cada
% patrón de entrenamiento.
%
%   p = densidad_parzen(xtrn, xeval, sigma)
%
%   xtrn  : patrones de entrenamiento por columnas (d x n)
%   xeval : puntos donde se evalúa la densidad (d x m)
%   sigma : anchura de la ventana
%   p     : densidad estimada en cada punto (1 x m)

d = size(xtrn, 1);

% Distancias al cuadrado entre cada patrón de entrenamiento y cada punto
% (n x m), usando ||a - b||^2 = ||a||^2 + ||b||^2 - 2 a'b
dist2 = sum(xtrn.^2, 1)' + sum(xeval.^2, 1) - 2 * (xtrn' * xeval);
dist2 = max(dist2, 0);   % evita negativos minúsculos por redondeo

norma = (2 * pi * sigma^2)^(d / 2);
p = mean(exp(-dist2 / (2 * sigma^2)), 1) / norma;
end
