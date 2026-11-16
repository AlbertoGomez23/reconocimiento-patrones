# Funciones comunes

Funciones que comparten los proyectos. Cada script las añade al *path* con
`addpath(fullfile(carpeta, '..', 'funciones'))`, así que basta con ejecutar el
script desde su carpeta.

| Función | Qué hace |
|---|---|
| `barajar` | Desordena los patrones (y sus etiquetas) aleatoriamente |
| `dist_euclidea` | Distancia euclídea de un conjunto de patrones a un punto |
| `dist_mahalanobis` | Distancia de Mahalanobis (al cuadrado) usando Cholesky |
| `kmedias` | k-medias con distancia euclídea o de Mahalanobis |
| `particion_cv` | Pliegue *i* de una validación cruzada de *K* pliegues |
| `fisher_lda` | Discriminante lineal de Fisher multiclase |
| `densidad_parzen` | Estimación de densidad con ventanas de Parzen (núcleo gaussiano) |

Convención: los patrones van **por columnas** (`d x n`) y las etiquetas en un
vector fila (`1 x n`).
