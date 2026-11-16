function W = fisher_lda(x, y, n)
% FISHER_LDA  Discriminante lineal de Fisher multiclase.
% Calcula las n direcciones que maximizan la separación entre clases
% respecto a la dispersión dentro de cada clase.
%
%   W = fisher_lda(x, y, n)
%
%   x : patrones por columnas (d x N)
%   y : etiquetas (1 x N)
%   n : número de características que se quieren obtener
%   W : matriz de proyección (n x d). Se aplica como  x_nuevo = W * x
%
% Nota: con C clases solo hay C-1 direcciones con autovalor no nulo; el
% resto de direcciones no aportan separación entre clases.

d = size(x, 1);
clases = unique(y);
media_global = mean(x, 2);

Sb = zeros(d);   % dispersión entre clases
Sw = zeros(d);   % dispersión dentro de las clases
for k = 1:numel(clases)
    xk = x(:, y == clases(k));
    nk = size(xk, 2);
    mk = mean(xk, 2);
    Sb = Sb + nk * (mk - media_global) * (mk - media_global)';
    Sw = Sw + (nk - 1) * cov(xk');
end

% Autovectores de inv(Sw)*Sb ordenados de mayor a menor autovalor
[V, D] = eig(inv(Sw) * Sb);
[~, orden] = sort(diag(D), 'descend');
W = real(V(:, orden(1:n)))';
end
