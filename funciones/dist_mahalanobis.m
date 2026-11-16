function d = dist_mahalanobis(x, c, C)
% DIST_MAHALANOBIS  Distancia de Mahalanobis (al cuadrado) de cada patrón
% de x a un punto c con matriz de covarianza C.
%
%   d = dist_mahalanobis(x, c, C)
%
%   x : patrones por columnas (d x n)
%   c : punto de referencia (d x 1)
%   C : matriz de covarianza (d x d), simétrica y definida positiva
%   d : (x - c)' * inv(C) * (x - c) para cada patrón (1 x n)
%
% Se usa la factorización de Cholesky C = L*L' en vez de invertir C:
% z = L \ (x - c) cumple que ||z||^2 es la distancia buscada.

L = chol(C, 'lower');
z = L \ (x - c);
d = sum(z.^2, 1);
end
