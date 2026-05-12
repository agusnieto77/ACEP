# Extracción de palabas clave

## Introducción

En este artículo presentamos las utilidades de la función
[`acep_extract()`](https://agusnieto77.github.io/ACEP/reference/acep_extract.md)
para la extracción de palabras clave en un corpus de notas sobre la
conflictividad laboral en la industria pesquera argentina con un enfoque
de diccionario.

## El corpus de notas

Para que este artículo pueda reconstruirse en CRAN sin depender de
descargas externas, los ejemplos ejecutables usan
`ACEP::acep_bases$lc_720`, una muestra incluida en el paquete. Se
compone de 720 notas y 9 variables: id, fecha, seccion, titulo, bajada,
nota, nota_norm, link, clas_hum. En una sesión interactiva con conexión
también se puede cargar el corpus completo de Revista Puerto con
`acep_load_base(acep_bases$rp_mdp)`.

``` r

# Cargamos la librería ACEP
library(ACEP)

# Cargamos una muestra incluida en el paquete
rev_puerto <- acep_bases$lc_720

# Imprimimos la base en consola
rev_puerto
```

    #> # A tibble: 720 × 9
    #>       id fecha      seccion   titulo       bajada nota  nota_norm link  clas_hum
    #>    <dbl> <date>     <fct>     <chr>        <chr>  <chr> <chr>     <chr> <lgl>   
    #>  1     1 2016-03-01 La Ciudad Emotivo: po… "Hace… "Los… "los dos… http… FALSE   
    #>  2     2 2016-03-01 La Ciudad El oficiali… "En l… "La … "la decl… http… TRUE    
    #>  3     3 2016-03-02 La Ciudad Rech tambié… "El r… "El … "el conc… http… TRUE    
    #>  4     4 2016-03-02 La Ciudad Anuncian in… "El i… "El … "el inte… http… FALSE   
    #>  5     5 2016-03-02 La Ciudad Video: la p… "El C… "De … "de mane… http… FALSE   
    #>  6     6 2016-03-03 La Ciudad Nuevas inve… "Una … "Rep… "represe… http… FALSE   
    #>  7     7 2016-03-03 La Ciudad Exigimos un… "Para… "En … "en el m… http… TRUE    
    #>  8     8 2016-03-03 La Ciudad Hoy en Mar … "Clas… "Yog… "yoga y … http… TRUE    
    #>  9     9 2016-03-06 La Ciudad El Colegio … "Será… "El … "el cons… http… FALSE   
    #> 10    10 2016-03-06 La Ciudad La inseguri… "A pe… "Un … "un grup… http… TRUE    
    #> # ℹ 710 more rows

## Los diccionarios

Una vez cargada la base de notas vamos a crear variables numéricas y una
de carácter que contengan las frecuencias de palabras totales, la
frecuencia de palabras de cada diccionario usado para cada una de las
notas y las palabras clave mencionadas en cada nota. En esta parte del
código haremos uso de las funciones
[`acep_count()`](https://agusnieto77.github.io/ACEP/reference/acep_count.md)
y
[`acep_extract()`](https://agusnieto77.github.io/ACEP/reference/acep_extract.md).
También crearemos diccionarios breves para identificar menciones a
conflictos, huelgas y actores colectivos.

``` r

# Creamos el diccionario de palabras que refieren a huelgas
dicc_huelgas <- c("en paro", "al paro", "huelga", "huelguistas", "paro y movil",
                  "paro de actividades", "conciliación obligatoria", "un paro", 
                  "paro total", "paro parcial", "trabajo a reglamento", 
                  "el paro", "de brazos caídos")

# Cargamos el diccionario de palabras que refieren a conflictividad
dicc_conflictos_base <- c("conflicto", "conflictos", "protesta", "protestas",
                          "reclamo", "reclamos", "paro", "huelga",
                          "movilización", "manifestación")
dicc_conflictos <- unique(c(dicc_conflictos_base, dicc_huelgas))

# Creamos la variable con la frecuencia de palabras que refieren a conflictividad
rev_puerto$frec_conflictos <- acep_count(rev_puerto$nota, dicc_conflictos)

# Creamos la variable con la frecuencia de palabras que refieren a huelgas
rev_puerto$frec_huelgas <- acep_count(rev_puerto$nota, dicc_huelgas)

# Creamos el diccionario de palabras que refieren a actores colectivos
dicc_actores <- c("trabajadores", "docentes", "sindicato", "vecinos",
                  "municipal", "gobierno")

# Creamos la variable con la frecuencia de palabras que 
# refieren a actores colectivos
rev_puerto$frec_actores <- acep_count(rev_puerto$nota, dicc_actores)

# Imprimimos la base en consola
rev_puerto
```

    #> # A tibble: 720 × 12
    #>       id fecha      seccion   titulo       bajada nota  nota_norm link  clas_hum
    #>    <dbl> <date>     <fct>     <chr>        <chr>  <chr> <chr>     <chr> <lgl>   
    #>  1     1 2016-03-01 La Ciudad Emotivo: po… "Hace… "Los… "los dos… http… FALSE   
    #>  2     2 2016-03-01 La Ciudad El oficiali… "En l… "La … "la decl… http… TRUE    
    #>  3     3 2016-03-02 La Ciudad Rech tambié… "El r… "El … "el conc… http… TRUE    
    #>  4     4 2016-03-02 La Ciudad Anuncian in… "El i… "El … "el inte… http… FALSE   
    #>  5     5 2016-03-02 La Ciudad Video: la p… "El C… "De … "de mane… http… FALSE   
    #>  6     6 2016-03-03 La Ciudad Nuevas inve… "Una … "Rep… "represe… http… FALSE   
    #>  7     7 2016-03-03 La Ciudad Exigimos un… "Para… "En … "en el m… http… TRUE    
    #>  8     8 2016-03-03 La Ciudad Hoy en Mar … "Clas… "Yog… "yoga y … http… TRUE    
    #>  9     9 2016-03-06 La Ciudad El Colegio … "Será… "El … "el cons… http… FALSE   
    #> 10    10 2016-03-06 La Ciudad La inseguri… "A pe… "Un … "un grup… http… TRUE    
    #> # ℹ 710 more rows
    #> # ℹ 3 more variables: frec_conflictos <int>, frec_huelgas <int>,
    #> #   frec_actores <int>

Ahora vamos a usar la función
[`acep_extract()`](https://agusnieto77.github.io/ACEP/reference/acep_extract.md)
para extraer las palabras clave de los diccionarios de conflictividad,
huelgas y actores colectivos que aparecen en cada una de las notas de la
muestra.

``` r

# Creamos la variable con las palabras que refieren a conflictividad
rev_puerto$extract_conflictos <- acep_extract(rev_puerto$nota, dicc_conflictos, izq = "")

# Creamos la variable con las palabras que refieren a huelgas
rev_puerto$extract_huelgas <- acep_extract(rev_puerto$nota, dicc_huelgas)

# Creamos la variable con las palabras que 
# refieren a actores colectivos
rev_puerto$extract_actores <- acep_extract(rev_puerto$nota, dicc_actores)

# Imprimimos la base en consola
rev_puerto
```

    #> # A tibble: 720 × 15
    #>       id fecha      seccion   titulo       bajada nota  nota_norm link  clas_hum
    #>    <dbl> <date>     <fct>     <chr>        <chr>  <chr> <chr>     <chr> <lgl>   
    #>  1     1 2016-03-01 La Ciudad Emotivo: po… "Hace… "Los… "los dos… http… FALSE   
    #>  2     2 2016-03-01 La Ciudad El oficiali… "En l… "La … "la decl… http… TRUE    
    #>  3     3 2016-03-02 La Ciudad Rech tambié… "El r… "El … "el conc… http… TRUE    
    #>  4     4 2016-03-02 La Ciudad Anuncian in… "El i… "El … "el inte… http… FALSE   
    #>  5     5 2016-03-02 La Ciudad Video: la p… "El C… "De … "de mane… http… FALSE   
    #>  6     6 2016-03-03 La Ciudad Nuevas inve… "Una … "Rep… "represe… http… FALSE   
    #>  7     7 2016-03-03 La Ciudad Exigimos un… "Para… "En … "en el m… http… TRUE    
    #>  8     8 2016-03-03 La Ciudad Hoy en Mar … "Clas… "Yog… "yoga y … http… TRUE    
    #>  9     9 2016-03-06 La Ciudad El Colegio … "Será… "El … "el cons… http… FALSE   
    #> 10    10 2016-03-06 La Ciudad La inseguri… "A pe… "Un … "un grup… http… TRUE    
    #> # ℹ 710 more rows
    #> # ℹ 6 more variables: frec_conflictos <int>, frec_huelgas <int>,
    #> #   frec_actores <int>, extract_conflictos <chr>, extract_huelgas <chr>,
    #> #   extract_actores <chr>

## Las palabras clave extraídas

Ya construidas las variables nos ocuparemos de poner el foco en el
rendimiento de la función
[`acep_extract()`](https://agusnieto77.github.io/ACEP/reference/acep_extract.md).
Seleccionaremos las columnas referidas a las extracciones de conflictos
y huelgas. Veamos.

``` r

# Seleccionamos las variables de extracción de palabras clave
rev_puerto_huelgas <- rev_puerto[rev_puerto$extract_huelgas != "",]
rev_puerto_actores <- rev_puerto_huelgas[rev_puerto_huelgas$extract_actores != "",]
rev_puerto_seleccion <- rev_puerto_actores[ , c('extract_conflictos', 'extract_huelgas', 'extract_actores')]

# Imprimimos la base en consola
rev_puerto_seleccion
```

    #> # A tibble: 84 × 3
    #>    extract_conflictos                            extract_huelgas extract_actores
    #>    <chr>                                         <chr>           <chr>          
    #>  1 un paro; reclamo; protesta; reclamos          un paro         docentes; trab…
    #>  2 conflicto; un paro                            un paro         gobierno; gobi…
    #>  3 protestas; un paro; paro                      un paro         municipal; vec…
    #>  4 al paro; reclamos; conflictos; conflicto; co… al paro         sindicato; vec…
    #>  5 un paro                                       un paro         sindicato; gob…
    #>  6 el paro; movilización                         el paro         gobierno; gobi…
    #>  7 un paro; conciliación obligatoria; el paro; … un paro; conci… trabajadores; …
    #>  8 huelga; un paro; paro; paro; huelga; un paro… huelga; un par… docentes; sind…
    #>  9 un paro; un paro; paro                        un paro; un pa… municipales    
    #> 10 un paro; reclamo; movilización; huelga; movi… un paro; huelg… sindicatos; go…
    #> # ℹ 74 more rows

## Nota final

A lo largo de este breve tutorial sobre la función
[`acep_extract()`](https://agusnieto77.github.io/ACEP/reference/acep_extract.md)
del paquete ACEP buscamos ejemplificar de qué modo puede ser usada esta
función para individualizar cada una de las palabras clave que fueron
contabilizadas en las notas con la función
[`acep_count()`](https://agusnieto77.github.io/ACEP/reference/acep_count.md).
