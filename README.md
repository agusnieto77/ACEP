## ACEP: Análisis Computacional de Eventos de Protesta<img src="man/figures/logo.png" align="right" height="139"/>

### Visión general

ACEP es un paquete de funciones en lenguaje R útiles para la detección y el análisis de eventos de protesta en corpus de textos periodísticos.

### Instalación de la versión en desarrollo

``` r
# install.packages("devtools")
devtools::install_github("agusnieto77/ACEP")
```

### Funciones

| Nombre | Descripción |
|:---|:------|
|`acep_db()`	|Frecuencia, menciones e intensidad.|
|`acep_frec()`|Frecuencia de palabras totales.|
|`acep_int()`|Índice de intensidad.|
|`acep_men()`|Frecuencia de menciones de palabras.|
|`acep_post_rst()`|Resumen visual de la serie temporal de los índices de conflictividad.|
|`acep_post_st()`|Gráfico de barras de la serie temporal de índices de conflictividad.|
|`acep_rst()`|Serie temporal de índices de conflictividad.|

### Colecciones

| Nombre | Descripción |
|:---|:------|
|`acep_bases`|Colección de notas.|
|`acep_diccionarios`|Colección de diccionarios.|

### Uso de las funciones


``` r
# Cargamos la librería
require(ACEP)

# Cargamos la base de notas de la Revista Puerto
rev_puerto <- acep_bases$rev_puerto

# Con la función acep_frec() contamos la frecuencia de palabras de cada nota y creamos una
# nueva columna llamada  n_palabras
rev_puerto$n_palabras <- acep_frec(rev_puerto$nota)

# Imprimimos en pantalla la base
rev_puerto

# A tibble: 7,816 × 7
   fecha      titulo                           bajada nota  imagen link  n_palabras
   <date>     <chr>                            <chr>  <chr> <chr>  <chr>      <int>
 1 2020-12-29 ¡Feliz Año 2021 para todos nues… Con m… "Con… https… http…         31
 2 2020-12-28 Mapa del trabajo esclavo en agu… Un re… "El … https… http…       1128
 3 2020-12-24 Plantas piden tener garantizada… En Ch… "El … https… http…        530
 4 2020-12-24 Los obreros navales despiden el… En Ma… "El … https… http…        483
 5 2020-12-23 El incumplimiento del régimen d… Se ll… "Las… https… http…        525
 6 2020-12-23 Otro fallo ratifica cautelar co… La Cá… "La … https… http…        462
 7 2020-12-22 Recomendaciones de SENASA para … Desde… "En … https… http…        650
 8 2020-12-22 Trelew consolida su inserción e… En 20… "Ins… https… http…        830
 9 2020-12-21 El CFP presentó el estado y la … En la… "Ant… https… http…       1434
10 2020-12-21 La flota amarilla cierra el año… Puert… "El … https… http…       1056
# … with 7,806 more rows

# Ahora con la función acep_men() contamos la frecuencia de menciones de términos del
# diccionario de conflictividad de SISMOS de cada nota y creamos una nueva columna llamada  conflictos
rev_puerto$conflictos <- acep_men(rev_puerto$nota, acep_diccionarios$dicc_confl_sismos)

# Imprimimos en pantalla la base con la nueva columna de menciones del diccionario de conflictividad
rev_puerto

# A tibble: 7,816 × 8
   fecha      titulo                bajada nota  imagen link  n_palabras conflictos
   <date>     <chr>                 <chr>  <chr> <chr>  <chr>      <int>      <int>
 1 2020-12-29 ¡Feliz Año 2021 para… Con m… "Con… https… http…         31          0
 2 2020-12-28 Mapa del trabajo esc… Un re… "El … https… http…       1128          4
 3 2020-12-24 Plantas piden tener … En Ch… "El … https… http…        530          3
 4 2020-12-24 Los obreros navales … En Ma… "El … https… http…        483          8
 5 2020-12-23 El incumplimiento de… Se ll… "Las… https… http…        525          4
 6 2020-12-23 Otro fallo ratifica … La Cá… "La … https… http…        462          6
 7 2020-12-22 Recomendaciones de S… Desde… "En … https… http…        650          0
 8 2020-12-22 Trelew consolida su … En 20… "Ins… https… http…        830          4
 9 2020-12-21 El CFP presentó el e… En la… "Ant… https… http…       1434          3
10 2020-12-21 La flota amarilla ci… Puert… "El … https… http…       1056          4
# … with 7,806 more rows

# Ahora con la función acep_int() calculamos un índice de intensidad de la conflictividad y creamos una
# nueva columna llamada  intensidad
rev_puerto$intensidad <- acep_int(rev_puerto$conflictos, rev_puerto$n_palabras, 3)

# Imprimimos en pantalla la base con la nueva columna de intensidad
rev_puerto

# A tibble: 7,816 × 9
   fecha      titulo     bajada nota  imagen link  n_palabras conflictos intensidad
   <date>     <chr>      <chr>  <chr> <chr>  <chr>      <int>      <int>      <dbl>
 1 2020-12-29 ¡Feliz Añ… Con m… "Con… https… http…         31          0      0    
 2 2020-12-28 Mapa del … Un re… "El … https… http…       1128          4      0.004
 3 2020-12-24 Plantas p… En Ch… "El … https… http…        530          3      0.006
 4 2020-12-24 Los obrer… En Ma… "El … https… http…        483          8      0.017
 5 2020-12-23 El incump… Se ll… "Las… https… http…        525          4      0.008
 6 2020-12-23 Otro fall… La Cá… "La … https… http…        462          6      0.013
 7 2020-12-22 Recomenda… Desde… "En … https… http…        650          0      0    
 8 2020-12-22 Trelew co… En 20… "Ins… https… http…        830          4      0.005
 9 2020-12-21 El CFP pr… En la… "Ant… https… http…       1434          3      0.002
10 2020-12-21 La flota … Puert… "El … https… http…       1056          4      0.004
# … with 7,806 more rows

# Ahora con la función acep_db() las tres funciones en un solo paso
rp_procesada <- acep_db(rev_puerto, rev_puerto$nota, dicc_confl_sismos, 3)

# Imprimimos en pantalla la base con las tres columna creadas
rev_puerto

# A tibble: 7,816 × 9
   fecha      titulo     bajada nota  imagen link  n_palabras conflictos intensidad
   <date>     <chr>      <chr>  <chr> <chr>  <chr>      <int>      <int>      <dbl>
 1 2020-12-29 ¡Feliz Añ… Con m… "Con… https… http…         31          0      0    
 2 2020-12-28 Mapa del … Un re… "El … https… http…       1128          4      0.004
 3 2020-12-24 Plantas p… En Ch… "El … https… http…        530          3      0.006
 4 2020-12-24 Los obrer… En Ma… "El … https… http…        483          8      0.017
 5 2020-12-23 El incump… Se ll… "Las… https… http…        525          4      0.008
 6 2020-12-23 Otro fall… La Cá… "La … https… http…        462          6      0.013
 7 2020-12-22 Recomenda… Desde… "En … https… http…        650          0      0    
 8 2020-12-22 Trelew co… En 20… "Ins… https… http…        830          4      0.005
 9 2020-12-21 El CFP pr… En la… "Ant… https… http…       1434          3      0.002
10 2020-12-21 La flota … Puert… "El … https… http…       1056          4      0.004
# … with 7,806 more rows
```


