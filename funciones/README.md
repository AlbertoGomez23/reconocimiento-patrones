# Shared functions

Functions shared by the projects. Each script adds them to the path with
`addpath(fullfile(carpeta, '..', 'funciones'))`, so it is enough to run the
script from its own folder.

| Function | What it does |
|---|---|
| `barajar` | Randomly shuffles the patterns (and their labels) |
| `dist_euclidea` | Euclidean distance from a set of patterns to a point |
| `dist_mahalanobis` | (Squared) Mahalanobis distance using a Cholesky factorization |
| `kmedias` | k-means with Euclidean or Mahalanobis distance |
| `particion_cv` | Fold *i* of a *K*-fold cross-validation |
| `fisher_lda` | Multiclass Fisher linear discriminant |
| `densidad_parzen` | Parzen window density estimation (Gaussian kernel) |

Convention: patterns are stored **as columns** (`d x n`) and labels as a row
vector (`1 x n`).
