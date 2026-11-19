# Pattern recognition in MATLAB

Classification and density estimation problems solved with pattern recognition
algorithms implemented from scratch in MATLAB, without using the equivalent
toolbox functions, and applied to real medical data.

| Project | Techniques | Data |
|---|---|---|
| [k-means for arrhythmia classification](kmedias-arritmias-ecg/) | k-means (Euclidean and Mahalanobis), nearest-centroid classification | ECG heartbeats (MIT-BIH) |
| [Parzen windows](parzen-diabetes/) | Fisher discriminant, Parzen density estimation, Bayes classifier, cross-validation | Diabetes (Pima Indians) |

## Structure

```
funciones/                shared functions (k-means, distances, Fisher, Parzen...)
kmedias-arritmias-ecg/    one folder per project, with its script, README and figures
parzen-diabetes/
```

The code (identifiers and comments) is written in Spanish.

## How to run

1. Open MATLAB (tested on R2025a).
2. Go to the project folder and run its script. Each script adds `funciones/`
   to the path by itself.

Some projects need the data to be downloaded separately; see their README.
