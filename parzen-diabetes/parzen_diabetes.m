%% Clasificación con ventanas de Parzen: diabetes (Pima Indians)
% - Se reducen las 8 características a 2 con el discriminante de Fisher.
% - Se elige la anchura de ventana sigma por validación cruzada de 10
%   pliegues y se mide el error en un conjunto de test separado.
% - Se estima la densidad de cada clase con ventanas de Parzen y se
%   dibuja como una malla.
%
% El clasificador es bayesiano: cada punto se asigna a la clase con mayor
% P(clase) * p(x | clase), donde p(x | clase) se estima con Parzen.

clear; close all; clc;
carpeta = fileparts(mfilename('fullpath'));
addpath(fullfile(carpeta, '..', 'funciones'));
rng(0);   % semilla fija para que los resultados sean reproducibles

%% Carga de datos
% x: 8 x 768 (características de cada paciente)
% y: 1 x 768 (1 = sin diabetes: 500 pacientes, 2 = con diabetes: 268)
% Ojo: la ficha original del dataset dice lo contrario, pero los datos lo
% confirman (la glucosa media es 110 en la clase 1 y 141 en la clase 2).
load(fullfile(carpeta, 'datos', 'diabetes.mat'), 'x', 'y');
num_clases = numel(unique(y));

% Se reserva un 15 % de los datos solo para test. Fisher y sigma se
% ajustan únicamente con el 85 % restante, para no contaminar la
% estimación final del error.
[x, y] = barajar(x, y);
n_tr = round(0.85 * numel(y));
x_tr = x(:, 1:n_tr);      y_tr = y(1:n_tr);
x_ts = x(:, n_tr+1:end);  y_ts = y(n_tr+1:end);

%% Reducción de 8 a 2 características con Fisher
d = 2;
W = fisher_lda(x_tr, y_tr, d);
x_tr = W * x_tr;
x_ts = W * x_ts;

%% Elección de sigma por validación cruzada de 10 pliegues
K_CV = 10;
valores_sigma = 0.1:0.2:20;
errores = zeros(size(valores_sigma));

for i = 1:numel(valores_sigma)
    sigma = valores_sigma(i);
    num_errores = 0;
    for k = 1:K_CV
        [xtrn, xval, ytrn, yval] = particion_cv(x_tr, y_tr, K_CV, k);
        P = zeros(num_clases, numel(yval));
        for c = 1:num_clases
            prior = mean(ytrn == c);
            P(c, :) = prior * densidad_parzen(xtrn(:, ytrn == c), xval, sigma);
        end
        [~, prediccion] = max(P, [], 1);
        num_errores = num_errores + sum(prediccion ~= yval);
    end
    errores(i) = 100 * num_errores / n_tr;
end

[error_cv, i_opt] = min(errores);
sigma_opt = valores_sigma(i_opt);
fprintf('Sigma óptimo: %.1f (error de validación cruzada: %.2f %%)\n', sigma_opt, error_cv);

fig1 = figure('Color', 'w');
plot(valores_sigma, errores, 'LineWidth', 1.5); hold on;
plot(sigma_opt, error_cv, 'o', 'MarkerSize', 8, 'LineWidth', 1.5); hold off;
grid on; xlabel('\sigma (anchura de la ventana)'); ylabel('Error de validación cruzada (%)');
title('Elección de \sigma por validación cruzada (10 pliegues)');

%% Error en el conjunto de test con el sigma óptimo
P = zeros(num_clases, numel(y_ts));
for c = 1:num_clases
    prior = mean(y_tr == c);
    P(c, :) = prior * densidad_parzen(x_tr(:, y_tr == c), x_ts, sigma_opt);
end
[~, prediccion] = max(P, [], 1);
error_test = 100 * mean(prediccion ~= y_ts);
fprintf('Error en test (%d pacientes no vistos): %.2f %%\n', numel(y_ts), error_test);

%% Densidad de cada clase estimada con Parzen, dibujada como malla
puntos = 60;
eje1 = linspace(min(x_tr(1, :)), max(x_tr(1, :)), puntos);
eje2 = linspace(min(x_tr(2, :)), max(x_tr(2, :)), puntos);
[X1, X2] = meshgrid(eje1, eje2);
malla = [X1(:)'; X2(:)'];

Z1 = reshape(densidad_parzen(x_tr(:, y_tr == 1), malla, sigma_opt), puntos, puntos);
Z2 = reshape(densidad_parzen(x_tr(:, y_tr == 2), malla, sigma_opt), puntos, puntos);

fig2 = figure('Color', 'w');
h1 = mesh(X1, X2, Z1); h1.EdgeColor = [0.00 0.45 0.74]; hold on;
h2 = mesh(X1, X2, Z2); h2.EdgeColor = [0.85 0.33 0.10]; hold off;
xlabel('Característica de Fisher 1'); ylabel('Característica de Fisher 2'); zlabel('Densidad');
title(sprintf('Densidad de cada clase estimada con Parzen (\\sigma = %.1f)', sigma_opt));
legend('Sin diabetes', 'Con diabetes'); view(-35, 30);

% Tema claro para las imágenes exportadas (la función theme existe desde R2025a)
if exist('theme', 'file'), theme(fig1, 'light'); theme(fig2, 'light'); end
carpeta_fig = fullfile(carpeta, 'figuras');
exportgraphics(fig1, fullfile(carpeta_fig, 'error_vs_sigma.png'), 'Resolution', 150);
exportgraphics(fig2, fullfile(carpeta_fig, 'densidades_parzen.png'), 'Resolution', 150);

%% Análisis
% - Las dos densidades se solapan mucho: con solo 2 características las
%   clases no se separan bien. Además, con 2 clases Fisher solo tiene una
%   dirección útil (autovalor no nulo); la segunda característica apenas
%   aporta información para separar las clases.
% - Un sigma pequeño hace que la densidad sea una suma de picos sobre cada
%   paciente (sobreajuste) y un sigma grande la suaviza tanto que pierde la
%   forma de las clases. La validación cruzada busca el punto intermedio.
% - El error final ronda el 22-25 %, en la línea de los mejores métodos
%   del benchmark StatLog para este conjunto de datos.
