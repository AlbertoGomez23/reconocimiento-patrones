# Parzen windows: diabetes diagnosis

Non-parametric Bayes classifier for the *Pima Indians Diabetes* dataset (768
patients, 8 clinical variables; 500 without diabetes and 268 with diabetes).

## How it works

1. **Data split:** 15 % of the patients are held out for testing only.
   Everything else (Fisher and the choice of σ) is fitted on the remaining 85 %.
2. **Reduction to 2 features** with Fisher's linear discriminant
   ([`funciones/fisher_lda.m`](../funciones/fisher_lda.m)).
3. **Density estimation** for each class with Parzen windows
   ([`funciones/densidad_parzen.m`](../funciones/densidad_parzen.m)): the density
   at a point is the mean of Gaussians of width σ centred on each patient.
4. **Bayes classification:** each patient is assigned to the class with the
   highest P(class) · p(x | class).
5. **Choice of σ** by 10-fold cross-validation, trying values from 0.1 to 20.

## Results

| | Error |
|---|---|
| Cross-validation (σ = 0.7) | 21.4 % |
| **Test (115 unseen patients)** | **25.2 %** |

For reference, the best methods in the StatLog benchmark reach around 22–25 %
error on this data.

![Error as a function of sigma](figuras/error_vs_sigma.png)

With a small σ the density becomes a set of spikes on each patient and the model
overfits; with a large σ it is smoothed so much that from σ ≈ 4 on the classifier
always picks the majority class (no diabetes) and the error stalls at about
33.5 %.

![Densities estimated with Parzen windows](figuras/densidades_parzen.png)

The two densities overlap considerably: with only 2 features the classes cannot
be fully separated. Moreover, with 2 classes Fisher has only one useful
direction (a single non-zero eigenvalue), so the second feature adds little.

## How to run

Run `parzen_diabetes.m` in MATLAB. The data is included in `datos/diabetes.mat`
(from the StatLog benchmark). It takes a few seconds.
