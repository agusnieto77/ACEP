# Resumen visual de la serie temporal de los indices de conflictividad.

Función que devuelve un panel visual de cuatro gráficos de barras con
variables proxy de los indices de conflictividad agrupados por segmento
de tiempo.

## Usage

``` r
acep_plot_rst(datos, tagx = "horizontal")
```

## Arguments

- datos:

  data frame con datos procesados.

- tagx:

  orientación de las etiquetas del eje x ('horizontal' \| 'vertical').

## Value

Si todas las entradas son correctas, la salida sera una imagen de cuatro
paneles.

## Examples

``` r
datos <- acep_bases$rp_procesada
datos_procesados_anio <- acep_sst(datos, st = 'anio')
acep_plot_rst(datos_procesados_anio, tagx = 'vertical')
```
