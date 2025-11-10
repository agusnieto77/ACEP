# Gráfico de barras de la serie temporal de indices de conflictividad.

Función que devuelve un gráfico de barras con la serie temporal de
indices de conflictividad por dia, mes o anio.

## Usage

``` r
acep_plot_st(
  x,
  y,
  t = "",
  ejex = "",
  ejey = "",
  etiquetax = "horizontal",
  color = "mint"
)
```

## Arguments

- x:

  vector de valores del eje x (por ejemplo, fechas).

- y:

  vector de valores numéricos del eje y (por ejemplo, menciones).

- t:

  titulo del gráfico.

- ejex:

  nombre del eje x.

- ejey:

  nombre del eje y.

- etiquetax:

  orientación de las etiquetas del eje x ('horizontal' \| 'vertical').

- color:

  color de las barras.

## Value

Si todas las entradas son correctas, la salida sera una imagen de un
panel.

## Examples

``` r
datos <- acep_bases$rp_procesada
dpa <- acep_sst(datos, st = 'anio')
acep_plot_st(
dpa$st, dpa$frecm,
t = 'Evoluci\u00f3n de la conflictividad en el sector pesquero argentino',
ejex = 'A\u00f1os analizados',
ejey = 'Menciones de t\u00e9rminos del diccionario de conflictos',
etiquetax = 'horizontal')
```
