%% Clasificación de arritmias cardiacas con k-medias
% Se agrupan latidos de ECG con k-medias (implementado a mano) usando la
% distancia euclídea y la de Mahalanobis, se etiqueta cada grupo con la
% arritmia mayoritaria y se mide el acierto sobre el conjunto de test.
%
% Datos: ECG Heartbeat Categorization Dataset (MIT-BIH). Hay que descargar
% mitbih_train.csv y mitbih_test.csv y dejarlos en esta carpeta (ver README).

clear; close all; clc;
carpeta = fileparts(mfilename('fullpath'));
addpath(fullfile(carpeta, '..', 'funciones'));
rng(1);   % semilla fija para que los resultados sean reproducibles

%% Carga de datos
% Cada fila es un latido: 187 muestras de la señal y, en la última
% columna, el tipo de latido (0 = normal, 1-4 = tipos de arritmia).
f_train = fullfile(carpeta, 'mitbih_train.csv');
f_test  = fullfile(carpeta, 'mitbih_test.csv');
if ~isfile(f_train) || ~isfile(f_test)
    error(['Faltan mitbih_train.csv y mitbih_test.csv en %s.\n' ...
           'Descárgalos de https://www.kaggle.com/datasets/shayanfazeli/heartbeat'], carpeta);
end
datos_tr = readmatrix(f_train);
datos_ts = readmatrix(f_test);

x_tr = datos_tr(:, 1:end-1)';  y_tr = datos_tr(:, end)';
x_ts = datos_ts(:, 1:end-1)';  y_ts = datos_ts(:, end)';

%% Reducción del problema
% Para reducir el tiempo de cálculo se baraja y se usa el 50 % de los
% latidos y la primera mitad de las muestras de cada uno.
[x_tr, y_tr] = barajar(x_tr, y_tr);
[x_ts, y_ts] = barajar(x_ts, y_ts);

n_caract = floor(size(x_tr, 1) / 2);          % 93 características
n_tr = floor(size(x_tr, 2) / 2);
n_ts = floor(size(x_ts, 2) / 2);
x_tr = x_tr(1:n_caract, 1:n_tr);  y_tr = y_tr(1:n_tr);
x_ts = x_ts(1:n_caract, 1:n_ts);  y_ts = y_ts(1:n_ts);
fprintf('Entrenamiento: %d latidos, test: %d latidos, %d características\n', n_tr, n_ts, n_caract);

% Distribución de clases: el problema está muy desbalanceado
clases = 0:4;
conteo = arrayfun(@(c) sum(y_tr == c), clases);
fig1 = figure('Color', 'w');
bar(clases, conteo, 'FaceColor', [0.85 0.33 0.10]);
title('Latidos de entrenamiento por clase');
xlabel('Clase (0 = normal, 1-4 = arritmias)'); ylabel('Número de latidos');
grid on;
fprintf('Porcentaje de latidos normales (clase 0): %.1f %%\n', 100 * conteo(1) / n_tr);

%% k-medias con distancia euclídea y de Mahalanobis, para K = 1..10
valores_K = 1:10;
distancias = {'euclidea', 'mahalanobis'};
aciertos = zeros(numel(distancias), numel(valores_K));

for t = 1:numel(distancias)
    for K = valores_K
        % Entrenamiento: grupos con los datos de entrenamiento
        [centroides, covarianzas, asignacion] = kmedias(x_tr, K, distancias{t}, 100);

        % Cada centroide representa la clase más frecuente de su grupo
        etiquetas = zeros(1, K);
        for k = 1:K
            if any(asignacion == k)
                etiquetas(k) = mode(y_tr(asignacion == k));
            end
        end

        % Test: cada latido toma la etiqueta de su centroide más cercano
        d_ts = zeros(K, n_ts);
        for k = 1:K
            if strcmp(distancias{t}, 'mahalanobis')
                d_ts(k, :) = dist_mahalanobis(x_ts, centroides(:, k), covarianzas{k});
            else
                d_ts(k, :) = dist_euclidea(x_ts, centroides(:, k));
            end
        end
        [~, mas_cercano] = min(d_ts, [], 1);
        prediccion = etiquetas(mas_cercano);

        aciertos(t, K) = 100 * mean(prediccion == y_ts);
        fprintf('%-11s K = %2d  ->  acierto %.2f %%\n', distancias{t}, K, aciertos(t, K));
    end
end

%% Resultados
for t = 1:numel(distancias)
    [mejor, K_mejor] = max(aciertos(t, :));
    fprintf('Mejor resultado con %s: %.2f %% (K = %d)\n', distancias{t}, mejor, K_mejor);
end

fig2 = figure('Color', 'w');
plot(valores_K, aciertos(1, :), '-o', 'LineWidth', 1.5); hold on;
plot(valores_K, aciertos(2, :), '-s', 'LineWidth', 1.5);
yline(100 * mean(y_ts == 0), '--', 'Predecir siempre "normal"');
hold off; grid on;
xlabel('Número de grupos K'); ylabel('Acierto en test (%)');
title('k-medias sobre latidos de ECG');
legend('Euclídea', 'Mahalanobis', 'Location', 'southeast');
ylim([70 100]);

% Tema claro para las imágenes exportadas (la función theme existe desde R2025a)
if exist('theme', 'file'), theme(fig1, 'light'); theme(fig2, 'light'); end
carpeta_fig = fullfile(carpeta, 'figuras');
exportgraphics(fig1, fullfile(carpeta_fig, 'distribucion_clases.png'), 'Resolution', 150);
exportgraphics(fig2, fullfile(carpeta_fig, 'acierto_vs_K.png'), 'Resolution', 150);

%% Análisis
% - Euclídea: el acierto se queda en torno al porcentaje de latidos
%   normales. Más del 80 % de los datos son de la clase 0 y las arritmias
%   se solapan con ellos, así que casi todos los grupos acaban etiquetados
%   como "normal" y el clasificador predice esa clase para casi todo.
% - Los resultados cambian ligeramente entre ejecuciones porque cada vez se
%   baraja y se recorta un subconjunto distinto de latidos, y los
%   centroides iniciales (los K primeros datos) son distintos.
% - Mahalanobis: cada grupo tiene su propia matriz de covarianza, de modo
%   que puede adoptar formas elípticas en lugar de esféricas. Con K
%   suficientemente grande, varios grupos cubren la nube de latidos
%   normales y otros se especializan en las arritmias, y el acierto supera
%   claramente al de predecir siempre "normal".
