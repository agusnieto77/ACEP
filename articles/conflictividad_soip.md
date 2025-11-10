# Conflictividad laboral en la pesca

## Introducción

En este artículo desarrollaremos una introducción al análisis de la
conflictividad laboral en la industria pesquera argentina con un enfoque
de diccionario en base a las funciones del paquete ACEP. En esta
oportunidad pondremos el foco en la conflictividad laboral protagonizada
por el Sindicato Obrero de la Industria del Pescado (SOIP) en la ciudad
de Mar del Plata entre los años 2009 y 2020.

## El corpus de notas

Las notas que componen el corpus utilizado en este ejercicio fueron
raspadas del sitio [revistapuerto.com.ar](https://revistapuerto.com.ar)
con las funciones del paquete `rvest`. Se compone de 7816 notas y 6
variables: fecha, titulo, bajada, nota, imagen, link. El corpus de notas
cubre desde el 2 de marzo de 2009 hasta el 29 de diciembre de 2020. Para
cargar todas las notas haremos uso de la función
[`acep_load_base()`](https://agusnieto77.github.io/ACEP/reference/acep_load_base.md).

``` r
# Cargamos la librería ACEP
library(ACEP)

# Definimos la url
url <- acep_bases$rp_mdp

# Descargamos el corpus de notas de la Revista Puerto
rev_puerto <- acep_load_base(url)

# Imprimimos la base en consola
rev_puerto
```

    #> # A tibble: 7,816 × 6
    #>    fecha      titulo                                   bajada nota  imagen link 
    #>  * <date>     <chr>                                    <chr>  <chr> <chr>  <chr>
    #>  1 2020-12-29 ¡Feliz Año 2021 para todos nuestros ami… Con m… "Con… https… http…
    #>  2 2020-12-28 Mapa del trabajo esclavo en aguas inter… Un re… "El … https… http…
    #>  3 2020-12-24 Plantas piden tener garantizada la prov… En Ch… "El … https… http…
    #>  4 2020-12-24 Los obreros navales despiden el año ana… En Ma… "El … https… http…
    #>  5 2020-12-23 El incumplimiento del régimen de cuotif… Se ll… "Las… https… http…
    #>  6 2020-12-23 Otro fallo ratifica cautelar contra el … La Cá… "La … https… http…
    #>  7 2020-12-22 Recomendaciones de SENASA para las expo… Desde… "En … https… http…
    #>  8 2020-12-22 Trelew consolida su inserción en la ind… En 20… "Ins… https… http…
    #>  9 2020-12-21 El CFP presentó el estado y la captura … En la… "Ant… https… http…
    #> 10 2020-12-21 La flota amarilla cierra el año con sos… Puert… "El … https… http…
    #> # ℹ 7,806 more rows

## Los diccionarios

Una vez descargada la base de notas vamos a crear variables numéricas
que contenga las frecuencias de palabras totales y de cada diccionario
usado para cada una de las notas. En esta parte del código haremos uso
de tres funciones y un diccionario del paquete ACEP:
[`acep_frec()`](https://agusnieto77.github.io/ACEP/reference/acep_frec.md),
[`acep_count()`](https://agusnieto77.github.io/ACEP/reference/acep_count.md),
[`acep_load_base()`](https://agusnieto77.github.io/ACEP/reference/acep_load_base.md)
y `acep_diccionarios`. También crearemos dos diccionarios breves para
usarlos en la función
[`acep_count()`](https://agusnieto77.github.io/ACEP/reference/acep_count.md)
con un doble objetivo: 1) identificar las notas que refieran a huelgas;
2) identificar las notas que refieran a lxs trabajadorxs del
procesamiento de pescado en tierra en la ciudad de Mar del Plata.

``` r
# Creamos la variable con la frecuencia de palabras por nota
rev_puerto$frec_palabras <- acep_frec(rev_puerto$nota)

# Cargamos el diccionario de palabras que refieren a conflictividad
dicc_conflictos <- acep_load_base(acep_diccionarios$dicc_confl_sismos)

# Creamos la variable con la frecuencia de palabras que refieren a conflictividad
rev_puerto$frec_conflictos <- acep_count(rev_puerto$nota, dicc_conflictos)

# Creamos el diccionario de palabras que refieren a huelgas
dicc_huelgas <- c("en paro", "al paro", "huelga", "huelguistas", "paro y movil",
                  "paro de actividades", "conciliación obligatoria", "un paro", 
                  "paro total", "paro parcial", "trabajo a reglamento", 
                  "el paro", "de brazos caídos")

# Creamos la variable con la frecuencia de palabras que refieren a huelgas
rev_puerto$frec_huelgas <- acep_count(rev_puerto$nota, dicc_huelgas)

# Creamos el diccionario de palabras que refieren a lxs obrerxs del pescado
dicc_soip <- c("soip", "sindicato obrero de la industria del pescado", 
               "sindicato de la industria del pescado", "huelguistas", 
               "obreras de la industria del pescado", "obreras del pescado",
               "obreros de la industria del pescado", "obreros del pescado",
               "fileteros", "fileteras", "obreros del filet", "obreras del filet")

# Creamos la variable con la frecuencia de palabras que 
# refieren a lxs obrerxs del pescado
rev_puerto$frec_soip <- acep_count(rev_puerto$nota, dicc_soip)

# Imprimimos la base en consola
rev_puerto
```

    #> # A tibble: 7,816 × 10
    #>    fecha      titulo     bajada nota  imagen link  frec_palabras frec_conflictos
    #>    <date>     <chr>      <chr>  <chr> <chr>  <chr>         <int>           <int>
    #>  1 2020-12-29 ¡Feliz Añ… Con m… "Con… https… http…            28               0
    #>  2 2020-12-28 Mapa del … Un re… "El … https… http…          1142               3
    #>  3 2020-12-24 Plantas p… En Ch… "El … https… http…           536               3
    #>  4 2020-12-24 Los obrer… En Ma… "El … https… http…           489               7
    #>  5 2020-12-23 El incump… Se ll… "Las… https… http…           529               4
    #>  6 2020-12-23 Otro fall… La Cá… "La … https… http…           467               6
    #>  7 2020-12-22 Recomenda… Desde… "En … https… http…           661               0
    #>  8 2020-12-22 Trelew co… En 20… "Ins… https… http…           844               4
    #>  9 2020-12-21 El CFP pr… En la… "Ant… https… http…          1454               4
    #> 10 2020-12-21 La flota … Puert… "El … https… http…          1073               5
    #> # ℹ 7,806 more rows
    #> # ℹ 2 more variables: frec_huelgas <int>, frec_soip <int>

## Los índices

Ya construidas las variables de frecuencia de palabras y menciones nos
ocuparemos de elaborar nuevas variables con índices de intensidad en
base al ratio entre las frecuencias de palabras totales y las menciones
de los diccionarios sobre trabajadorxs del pescado, conflictos y
huelgas. Para la elaboración de estos índices haremos uso de la función
[`acep_int()`](https://agusnieto77.github.io/ACEP/reference/acep_int.md)
del paquete ACEP.

``` r
# Creamos la variable con el índice de conflictividad general
rev_puerto$i_conf_gral <- acep_int(rev_puerto$frec_conflictos, 
                                   rev_puerto$frec_palabras)

# Creamos la variable con el índice de incidencia 
# de lxs trabajadorxs del pescado
rev_puerto$i_soip <- acep_int(rev_puerto$frec_soip, 
                              rev_puerto$frec_palabras)

# Creamos la variable con el índice de huelgas
rev_puerto$i_huelgas <- acep_int(rev_puerto$frec_huelgas, 
                                 rev_puerto$frec_conflictos)

# Filtramos para quedarnos con los índices mayores a 0 
# en la variable del índice de conflictividad general
rev_puerto <- rev_puerto[rev_puerto$i_conf_gral > 0, ]

# Filtramos para quedarnos con los índices mayores a 0
# en el índice de incidencia de lxs trabajadorxs del pescado
rev_puerto <- rev_puerto[rev_puerto$i_soip > 0, ]

# Imprimimos la base en consola
rev_puerto
```

    #> # A tibble: 387 × 13
    #>    fecha      titulo     bajada nota  imagen link  frec_palabras frec_conflictos
    #>    <date>     <chr>      <chr>  <chr> <chr>  <chr>         <int>           <int>
    #>  1 2020-11-24 Mardi, la… "Con … "Tra… https… http…          1140               1
    #>  2 2020-11-16 Cierran l… "El v… "Des… https… http…           384               3
    #>  3 2020-11-13 CaIPA-SOI… "Las … "Lo … https… http…           380               3
    #>  4 2020-10-30 Conflicto… "El S… "La … https… http…           689               4
    #>  5 2020-10-12 Obreros r… "Pert… "Un … https… http…           425               6
    #>  6 2020-10-07 Langostin… "El m… "El … https… http…          1120               4
    #>  7 2020-09-15 Corvina: … "Áfri… "La … https… http…           669               4
    #>  8 2020-08-31 Peón de u… "Es u… "Víc… https… http…           759               5
    #>  9 2020-08-26 “La salid… "Lo d… "Due… https… http…          1624               4
    #> 10 2020-08-11 Los comed… "Aume… "Es … https… http…          1272               3
    #> # ℹ 377 more rows
    #> # ℹ 5 more variables: frec_huelgas <int>, frec_soip <int>, i_conf_gral <dbl>,
    #> #   i_soip <dbl>, i_huelgas <dbl>

Al realizar los filtros la base se redujo a 387 notas que presentan al
menos una mención de una palabra que refiere a conflicto y al menos un
término que refiere a lxs trabajadorxs del pescado.

## Serie temporal de índices

En esta parte del código usaremos la función
[`acep_sst()`](https://agusnieto77.github.io/ACEP/reference/acep_sst.md)
para calcular los índices agrupados por año y mes. Primero construimos
la serie de tiempo para la conflictividad general.

``` r
# Calculamos el índice anual de conflictividad general en el
# ámbito de la industrial del procesado de pescado en tierra
# Pero primero preparamos el marcos de datos para ser procesado 
# por la función acep_sst()
# Estos pasos previos se deben realizar porque en este ejemplo no hicimos uso 
# de la función acep_db() que calcula frecuencia, menciones e intensidad y
# deja el marco de datos resultante en un formato adecuado para ser usado
# con la función acep_sst()
datos <- data.frame(
  fecha = rev_puerto$fecha,
  n_palabras = rev_puerto$frec_palabras,
  conflictos = rev_puerto$frec_conflictos,
  intensidad = rev_puerto$i_conf_gral
)

# Luego construimos los vectores
fecha <- datos$fecha
n_palabras <- datos$n_palabras
conflictos <- datos$conflictos

# Ahora agrupamos por mes la conflictividad general del sector
conf_gral_anio <- acep_sst(datos, st = "anio")

# Imprimimos la base en consola
conf_gral_anio |> head()
```

    #>     st frecn csn frecp frecm  intac intensidad int_notas_confl
    #> 1 2009    33  24 26169   161 0.2256     0.0062          0.7273
    #> 2 2010    30  21 27950   219 0.2873     0.0078          0.7000
    #> 3 2011    44  32 31273   277 0.4344     0.0089          0.7273
    #> 4 2012    77  70 67922   713 0.8519     0.0105          0.9091
    #> 5 2013    27  16 19783   168 0.2273     0.0085          0.5926
    #> 6 2014    17  11 12944    88 0.1173     0.0068          0.6471

``` r
# Calculamos el índice mensual de conflictividad general en el
# ámbito de la industrial del procesado de pescado en tierra
# Pero primero preparamos el marcos de datos para ser procesado 
# por la función acep_sst()
datos <- data.frame(
  fecha = rev_puerto$fecha,
  n_palabras = rev_puerto$frec_palabras,
  conflictos = rev_puerto$frec_conflictos,
  intensidad = rev_puerto$i_conf_gral
)

# Nos quedamos con los datos del año 2012 
datos <-  datos[datos$fecha < "2013-01-01", ]
datos <-  datos[datos$fecha > "2011-12-31", ]

# Luego construimos los vectores
fecha <- datos$fecha
n_palabras <- datos$n_palabras
conflictos <- datos$conflictos

# Ahora agrupamos por mes la conflictividad general del sector
conf_gral <- acep_sst(datos)

# Imprimimos la base en consola
conf_gral |> head()
```

    #>        st frecn csn frecp frecm  intac intensidad int_notas_confl
    #> 1 2012-01     4   2  3407    17 0.0233     0.0050          0.5000
    #> 2 2012-02     3   2  1991    11 0.0175     0.0055          0.6667
    #> 3 2012-03     5   4  4994    16 0.0183     0.0032          0.8000
    #> 4 2012-04     6   6  5426    52 0.0661     0.0096          1.0000
    #> 5 2012-05     7   7  5982    83 0.0991     0.0139          1.0000
    #> 6 2012-06    12  12 11100   158 0.1692     0.0142          1.0000

En la siguiente parte del código construimos la serie de tiempo para la
conflictividad huelguística.

``` r
# Calculamos el índice mensual de conflictividad huelguística en el
# ámbito de la industrial del procesado de pescado en tierra
# Pero primero preparamos el marcos de datos para ser procesado 
# por la función acep_sst()
datosh <- data.frame(
  fecha = rev_puerto$fecha,
  n_palabras = rev_puerto$frec_palabras,
  conflictos = rev_puerto$frec_huelgas,
  intensidad = rev_puerto$i_huelgas
)

# Nos quedamos con los datos del año 2012  
datosh <-  datosh[datosh$fecha < "2013-01-01", ]
datosh <-  datosh[datosh$fecha > "2011-12-31", ]

# Luego construimos los vectores
fechah <- datosh$fecha
n_palabrash <- datosh$n_palabras
conflictosh <- datosh$conflictos

# Ahora agrupamos por mes la conflictividad huelguística del sector
huelgas <- acep_sst(datosh)

# Imprimimos la base en consola
huelgas |> head()
```

    #>        st frecn csn frecp frecm  intac intensidad int_notas_confl
    #> 1 2012-01     4   0  3407     0 0.0000     0.0000          0.0000
    #> 2 2012-02     3   0  1991     0 0.0000     0.0000          0.0000
    #> 3 2012-03     5   0  4994     0 0.0000     0.0000          0.0000
    #> 4 2012-04     6   0  5426     5 0.5219     0.0009          0.0000
    #> 5 2012-05     7   1  5982     9 0.5396     0.0015          0.1429
    #> 6 2012-06    12   2 11100    17 0.9302     0.0015          0.1667

## Las visualizaciones

En este último apartado haremos uso de las funciones
[`acep_plot_st()`](https://agusnieto77.github.io/ACEP/reference/acep_plot_st.md)
y
[`acep_plot_rst()`](https://agusnieto77.github.io/ACEP/reference/acep_plot_rst.md)
para visualizar la variación anual de la conflictividad general
protagonizada por lxs trabajadorxs del pescado entre marzo de 2009 y
diciembre de 2020. También visualizaremos la variación mensual durante
el año 2012, el más conflictivo de período bajo análisis.

``` r
# Visualizaremos el índice de conflictividad general 
# agrupado por año para el período 2009-2020
acep_plot_st(
 conf_gral_anio$st,
 conf_gral_anio$frecm,
 t = "Indice anual de conflictividad en la industria pesquera (MdP)",
 ejey = "Menciones del diccionario",
 etiquetax = "vertical"
             )
```

![](conflictividad_soip_files/figure-html/plot00-1.png)

    # Visualizaremos el índice de conflictividad general 
    # agrupado por año para el período 2009-2020
    acep_plot_rst(conf_gral_anio, tagx = "vertical")

![](plot_vignette.png)

``` r
# Visualizaremos el índice de conflictividad general 
# agrupado por mes para el 2012
acep_plot_st(
 conf_gral$st,
 conf_gral$frecm,
 t = "Indice mensual de conflictos en la industria pesquera (MdP)",
 ejey = "Menciones del diccionario",
 etiquetax = "vertical"
             )
```

![](conflictividad_soip_files/figure-html/plot01-1.png)

``` r
# Visualizaremos el índice de conflictividad huelguística 
# agrupado por mes para el 2012
acep_plot_st(
 huelgas$st,
 huelgas$frecm,
 t = "Indice mensual de huelgas en la industria pesquera (MdP)",
 ejey = "Menciones del diccionario",
 etiquetax = "vertical"
             )
```

![](conflictividad_soip_files/figure-html/plot02-1.png)

Las distintas métricas nos ayudan a identificar al año 2012 como el más
conflictivo del período en el ámbito de la industria pesquera de
procesado en tierra en la ciudad de Mar del Plata, con epicentro en los
meses de junio, julio y agosto para la conflictividad general y con
epicentro en los meses de mayo, junio y julio para los movimientos
huelguísticos.

## Comentarios finales

A lo largo de este breve tutorial sobre algunas de las funciones del
paquete ACEP buscamos ejemplificar de qué modo se puede adoptar un
enfoque de diccionario para realizar un primer análisis exploratorio de
un corpus de notas periodísticas. Los resultados son alentadores. Con la
combinación de distintos diccionarios se pudo identificar la
temporalidad de la conflictividad protagonizada por lxs obrerxs del
pescado en la ciudad de Mar del Plata. En próximos artículos avanzaremos
con otras funciones del paquete ACEP para el análisis computacional de
la conflictividad en la industria pesquera argentina.
