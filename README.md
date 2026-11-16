# Reconocimiento de patrones en MATLAB

Problemas de clasificación y estimación de densidad resueltos con algoritmos de
reconocimiento de patrones implementados desde cero en MATLAB, sin usar las
funciones equivalentes de las toolboxes, y aplicados a datos médicos reales.

| Proyecto | Técnicas | Datos |
|---|---|---|
| [k-medias para clasificar arritmias](kmedias-arritmias-ecg/) | k-medias (euclídea y Mahalanobis), clasificación por centroides | Latidos de ECG (MIT-BIH) |
| [Ventanas de Parzen](parzen-diabetes/) | Discriminante de Fisher, estimación de densidad de Parzen, clasificador bayesiano, validación cruzada | Diabetes (Pima Indians) |

## Estructura

```
funciones/                funciones comunes (k-medias, distancias, Fisher, Parzen...)
kmedias-arritmias-ecg/    una carpeta por proyecto, con su script, README y figuras
parzen-diabetes/
```

## Cómo ejecutar

1. Abrir MATLAB (probado en R2025a).
2. Entrar en la carpeta del proyecto y ejecutar su script. Cada script
   añade `funciones/` al *path* por su cuenta.

Algunos proyectos necesitan descargar los datos aparte; se indica en su README.
