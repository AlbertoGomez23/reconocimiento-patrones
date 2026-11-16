function [centroides, covarianzas, asignacion] = kmedias(x, K, distancia, max_iter)
% KMEDIAS  Algoritmo k-medias con distancia euclídea o de Mahalanobis.
%
%   [centroides, covarianzas, asignacion] = kmedias(x, K, distancia, max_iter)
%
%   x          : patrones por columnas (d x n)
%   K          : número de grupos
%   distancia  : 'euclidea' o 'mahalanobis'
%   max_iter   : número máximo de iteraciones (por defecto 100)
%
%   centroides  : centro de cada grupo (d x K)
%   covarianzas : matriz de covarianza de cada grupo (cell 1 x K). Con
%                 distancia euclídea son la identidad.
%   asignacion  : grupo al que pertenece cada patrón (1 x n)
%
% Los centroides se inicializan con los K primeros patrones, así que
% conviene barajar los datos antes. Con Mahalanobis, las covarianzas
% empiezan siendo la identidad y se regularizan sumando 1e-4 a la diagonal
% para que no sean singulares.

if nargin < 4, max_iter = 100; end
usar_mahal = strcmpi(distancia, 'mahalanobis');

[d, n] = size(x);
centroides = x(:, 1:K);
covarianzas = repmat({eye(d)}, 1, K);
asignacion = zeros(1, n);

for iter = 1:max_iter
    % 1) Asignación: cada patrón va al centroide más cercano
    dist = distancias_a_centroides(x, centroides, covarianzas, usar_mahal);
    [~, nueva] = min(dist, [], 1);

    % Si ningún patrón cambia de grupo, el algoritmo ha convergido
    if isequal(nueva, asignacion)
        break;
    end
    asignacion = nueva;

    % 2) Actualización: cada centroide pasa a la media de su grupo
    for k = 1:K
        xk = x(:, asignacion == k);
        if usar_mahal
            % Hace falta más de un patrón para estimar una covarianza
            if size(xk, 2) > 1
                centroides(:, k) = mean(xk, 2);
                covarianzas{k} = cov(xk') + 1e-4 * eye(d);
            end
        elseif ~isempty(xk)
            centroides(:, k) = mean(xk, 2);
        end
    end
end
end

function dist = distancias_a_centroides(x, centroides, covarianzas, usar_mahal)
K = size(centroides, 2);
dist = zeros(K, size(x, 2));
for k = 1:K
    if usar_mahal
        dist(k, :) = dist_mahalanobis(x, centroides(:, k), covarianzas{k});
    else
        dist(k, :) = dist_euclidea(x, centroides(:, k));
    end
end
end
