# Extracción de palabas clave

## Introducción

En este artículo presentamos las utilidades de la función
[`acep_extract()`](https://agusnieto77.github.io/ACEP/reference/acep_extract.md)
para la extracción de palabras clave en un corpus de notas sobre la
conflictividad laboral en la industria pesquera argentina con un enfoque
de diccionario.

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

Una vez descargada la base de notas vamos a crear variables numéricas y
una de carácter que contenga las frecuencias de palabras totales, la
frecuencia de palabras de cada diccionario usado para cada una de las
notas y las palabras clave mencionadas en cada nota. En esta parte del
código haremos uso de tres funciones y un diccionario del paquete ACEP:
[`acep_count()`](https://agusnieto77.github.io/ACEP/reference/acep_count.md),
[`acep_extract()`](https://agusnieto77.github.io/ACEP/reference/acep_extract.md),
[`acep_load_base()`](https://agusnieto77.github.io/ACEP/reference/acep_load_base.md)
y `acep_diccionarios`. También crearemos dos diccionarios breves para
usarlos en las funciones
[`acep_count()`](https://agusnieto77.github.io/ACEP/reference/acep_count.md)
y
[`acep_extract()`](https://agusnieto77.github.io/ACEP/reference/acep_extract.md),
con un doble objetivo: 1) identificar las notas que refieran a huelgas;
2) identificar las notas que refieran a lxs trabajadorxs del
procesamiento de pescado en tierra en la ciudad de Mar del Plata.

``` r
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

    #> # A tibble: 7,816 × 9
    #>    fecha      titulo      bajada nota  imagen link  frec_conflictos frec_huelgas
    #>    <date>     <chr>       <chr>  <chr> <chr>  <chr>           <int>        <int>
    #>  1 2020-12-29 ¡Feliz Año… Con m… "Con… https… http…               0            0
    #>  2 2020-12-28 Mapa del t… Un re… "El … https… http…               3            0
    #>  3 2020-12-24 Plantas pi… En Ch… "El … https… http…               3            0
    #>  4 2020-12-24 Los obrero… En Ma… "El … https… http…               7            0
    #>  5 2020-12-23 El incumpl… Se ll… "Las… https… http…               4            1
    #>  6 2020-12-23 Otro fallo… La Cá… "La … https… http…               6            0
    #>  7 2020-12-22 Recomendac… Desde… "En … https… http…               0            0
    #>  8 2020-12-22 Trelew con… En 20… "Ins… https… http…               4            0
    #>  9 2020-12-21 El CFP pre… En la… "Ant… https… http…               4            0
    #> 10 2020-12-21 La flota a… Puert… "El … https… http…               5            0
    #> # ℹ 7,806 more rows
    #> # ℹ 1 more variable: frec_soip <int>

Ahora vamos a usar las función
[`acep_extract()`](https://agusnieto77.github.io/ACEP/reference/acep_extract.md)
para extraer las palabras clave de los diccionarios de conflictividad,
huelgas y SOIP que aparecen en cada una de las notas de la *Revista
Puerto*.

``` r
# Creamos la variable con las palabras que refieren a conflictividad
rev_puerto$extract_conflictos <- acep_extract(rev_puerto$nota, dicc_conflictos, izq = "")

# Creamos la variable con las palabras que refieren a huelgas
rev_puerto$extract_huelgas <- acep_extract(rev_puerto$nota, dicc_huelgas)

# Creamos la variable con las palabras que 
# refieren a lxs obrerxs del pescado
rev_puerto$extract_soip <- acep_extract(rev_puerto$nota, dicc_soip)

# Imprimimos la base en consola
rev_puerto
```

    #> # A tibble: 7,816 × 12
    #>    fecha      titulo      bajada nota  imagen link  frec_conflictos frec_huelgas
    #>    <date>     <chr>       <chr>  <chr> <chr>  <chr>           <int>        <int>
    #>  1 2020-12-29 ¡Feliz Año… Con m… "Con… https… http…               0            0
    #>  2 2020-12-28 Mapa del t… Un re… "El … https… http…               3            0
    #>  3 2020-12-24 Plantas pi… En Ch… "El … https… http…               3            0
    #>  4 2020-12-24 Los obrero… En Ma… "El … https… http…               7            0
    #>  5 2020-12-23 El incumpl… Se ll… "Las… https… http…               4            1
    #>  6 2020-12-23 Otro fallo… La Cá… "La … https… http…               6            0
    #>  7 2020-12-22 Recomendac… Desde… "En … https… http…               0            0
    #>  8 2020-12-22 Trelew con… En 20… "Ins… https… http…               4            0
    #>  9 2020-12-21 El CFP pre… En la… "Ant… https… http…               4            0
    #> 10 2020-12-21 La flota a… Puert… "El … https… http…               5            0
    #> # ℹ 7,806 more rows
    #> # ℹ 4 more variables: frec_soip <int>, extract_conflictos <chr>,
    #> #   extract_huelgas <chr>, extract_soip <chr>

## Las palabras clave extraídas

Ya construidas las variables nos ocuparemos de poner el foco en el
rendimiento de la función
[`acep_extract()`](https://agusnieto77.github.io/ACEP/reference/acep_extract.md).
Seleccionaremos las columnas referidas a las extracciones de conflictos
y huelgas. Veamos.

``` r
# Seleccionamos las variables de extracción de palabras clave
rev_puerto_huelgas <- rev_puerto[rev_puerto$extract_huelgas != "",]
rev_puerto_soip <- rev_puerto_huelgas[rev_puerto_huelgas$extract_soip != "",]
rev_puerto_seleccion <- rev_puerto_soip[ , c('extract_conflictos', 'extract_huelgas', 'extract_soip')]

# Imprimimos la base en consola
rev_puerto_seleccion
```

    #> # A tibble: 76 × 3
    #>    extract_conflictos                               extract_huelgas extract_soip
    #>    <chr>                                            <chr>           <chr>       
    #>  1 amenazaba; conflicto; conciliación obligatoria;… conciliación o… obreros del…
    #>  2 piquete; conciliación obligatoria; conflictos; … conciliación o… obreros del…
    #>  3 reclama; reclamo; reclamando; retención de tare… conciliación o… fileteros; …
    #>  4 concentración; quema; paro; exigiera; concentra… un paro         fileteros   
    #>  5 se manifestaron; reclamaron; denunciaron; manif… conciliación o… fileteros   
    #>  6 paro                                             un paro         obreros del…
    #>  7 paro; rechazo; acatamiento; medida de fuerza; p… al paro; al pa… fileteros   
    #>  8 reclaman; reclamo; se manifestaron; exigir; con… conciliación o… fileteros   
    #>  9 paro; paró; paró; lucha; paró; lucha; reclamo    del paro        fileteros   
    #> 10 reclamaban; paro                                 el paro         fileteros   
    #> # ℹ 66 more rows

## Nota final

A lo largo de este breve tutorial sobre la función
[`acep_extract()`](https://agusnieto77.github.io/ACEP/reference/acep_extract.md)
del paquete ACEP buscamos ejemplificar de qué modo puede ser usada esta
función para individualizar cada una de las palabras clave que fueron
contabilizadas en las notas con la función
[`acep_count()`](https://agusnieto77.github.io/ACEP/reference/acep_count.md).
