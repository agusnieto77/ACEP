# Serie temporal de índices de conflictividad.

Función que devuelve los indices de conflictividad agrupados por
segmento de tiempo: 'dia', 'mes', 'anio'. Esta función viene a
reemplazar a acep_rst. Simplifica los parámetros.

## Usage

``` r
acep_sst(datos, st = "mes", u = 2, d = 4)
```

## Arguments

- datos:

  data frame con las variables 'fecha' (en formato Date), 'n_palabras'
  (numérica), conflictos' (numérica), 'intensidad' (numérica). Las
  ultimas tres se pueden construir en un solo paso con la función
  'acep_db' o en tres pasos con las funciones 'acep_frec', 'acep_men',
  'acep_int'.

- st:

  parámetro para establecer el segmento temporal a ser agrupado: 'anio',
  'mes', 'dia'.

- u:

  umbral de menciones para contabilizar una nota como nota que refiere a
  un conflicto, por defecto tiene 2 pero se puede modificar.

- d:

  cantidad de decimales, por defecto tiene 4 pero se puede modificar.

## Value

Si todas las entradas son correctas, la salida sera una base de datos en
formato tabular con nuevas variables.

## Examples

``` r
datos <- acep_bases$rp_procesada
head(datos)
#> # A tibble: 6 × 4
#>   fecha      n_palabras conflictos intensidad
#>   <date>          <int>      <int>      <dbl>
#> 1 2020-12-29         31          0     0     
#> 2 2020-12-28       1128          4     0.0035
#> 3 2020-12-24        530          0     0     
#> 4 2020-12-24        483          3     0.0062
#> 5 2020-12-23        525          1     0.0019
#> 6 2020-12-23        462          0     0     
datos_procesados_anio <- acep_sst(datos, st='anio', u=4)
datos_procesados_mes <- acep_sst(datos)
datos_procesados_dia <- acep_sst(datos, st ='dia', d=3)
head(datos_procesados_anio)
#>     st frecn csn  frecp frecm  intac intensidad int_notas_confl
#> 1 2009   632  58 496110  1025 1.2735     0.0021          0.0918
#> 2 2010   680  67 492231  1129 1.6273     0.0023          0.0985
#> 3 2011   601  40 425747   882 1.2204     0.0021          0.0666
#> 4 2012   739  67 564270  1242 1.6841     0.0022          0.0907
#> 5 2013   689  24 525718   758 1.0559     0.0014          0.0348
#> 6 2014   631  30 444823   802 1.2112     0.0018          0.0475
head(datos_procesados_mes)
#>        st frecn csn frecp frecm  intac intensidad int_notas_confl
#> 1 2009-03    75  19 61252   146 0.1682     0.0024          0.2533
#> 2 2009-04    58   7 44076    75 0.0925     0.0017          0.1207
#> 3 2009-05    58   7 49037    55 0.0633     0.0011          0.1207
#> 4 2009-06    71   8 55727    82 0.1059     0.0015          0.1127
#> 5 2009-07    65  14 53299   110 0.1307     0.0021          0.2154
#> 6 2009-08    60  13 45458    94 0.1124     0.0021          0.2167
head(datos_procesados_dia)
#>           st frecn csn frecp frecm  intac intensidad int_notas_confl
#> 1 2009-03-02    10   4 10941    24 0.0201      0.002           0.400
#> 2 2009-03-03     3   0  2313     2 0.0019      0.001           0.000
#> 3 2009-03-04     5   1  4168    11 0.0092      0.003           0.200
#> 4 2009-03-05     3   1  2189     7 0.0090      0.003           0.333
#> 5 2009-03-06     5   1  3895     8 0.0098      0.002           0.200
#> 6 2009-03-09     3   0  2031     2 0.0034      0.001           0.000
```
