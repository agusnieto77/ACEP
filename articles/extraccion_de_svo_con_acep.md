# Extraer S-V-O con ACEP

## Función a presentar:

En este artículo se explicarán los procesos que realizan las funciones:

- [`acep_postag()`](https://agusnieto77.github.io/ACEP/reference/acep_postag.md)

- [`acep_upos()`](https://agusnieto77.github.io/ACEP/reference/acep_upos.md)

- [`acep_svo()`](https://agusnieto77.github.io/ACEP/reference/acep_svo.md)

## Función `acep_postag()`

Esta función realiza etiquetado POS, lematización, tokenización,
extracción de entidades y georreferenciación. Para llevar a cabo estas
tareas `acep_postag` envuelve y articula funciones de tres librerías:
*spacyr*, *rsyntax* y *tidygeocoder*.

En primer lugar, cargamos la librería *ACEP*. Luego, cargamos un vector
de titulares de portales noticiosos sobre notas referidas a conflictos.
Con esta selección de titulares haremos la prueba. También agregamos una
última oración unimembre como ejemplo extremo de oración no procesable
con la función
[`acep_svo()`](https://agusnieto77.github.io/ACEP/reference/acep_svo.md).

``` r
library(ACEP)

titulares <- c(acep_bases$titulares, "Hola mundo.")

titulares
```

    #> [1] "Sindicatos y estudiantes marchan por las principales ciudades de México para exigir un cambio en la política económica del Gobierno.\n          Los gremios convocan a un paro docente contra 'la presencialidad de Larreta' en Ciudad de Buenos Aires."
    #> [2] "Los gremios docentes rechazan volver a las aulas sin garantías sanitarias."                                                                                                                                                                             
    #> [3] "Los estatales rechazaron la oferta salarial que les hizo el gobierno en Chubut."                                                                                                                                                                        
    #> [4] "La CGT presiona para que los 1700 empleados cobren la doble indemnización."                                                                                                                                                                             
    #> [5] "Las dos CTA y la Izquierda rechazaron el acuerdo de la CGT para rebajar salarios."                                                                                                                                                                      
    #> [6] "Un gremio aéreo levantó el paro en Tucumán. Los judiciales ratificaron un paro.\n          La CGT marchó con críticas por la economía y evalúa si llama a un paro."                                                                                     
    #> [7] "Ctera convocó a un paro de 72 horas en todo el país."                                                                                                                                                                                                   
    #> [8] "Conciliación obligatoria en el conflicto del neumático."                                                                                                                                                                                                
    #> [9] "Hola mundo."

Ejecutamos la función
[`acep_postag()`](https://agusnieto77.github.io/ACEP/reference/acep_postag.md)
para los titulares contenidos en el vector.

¿Cuál es el resultado?

La función `acep_postag` toma el vector de textos y realiza diferentes
acciones:

- Verifica que el objeto entregado sea un vector de tipo caracter (de lo
  contrario imprime un mensaje de advertencia)

- Verifica que el parámetro ‘core’ sean un modelo válido (de lo
  contrario devuelve un mensaje de advertencia)

- Verifica que los parámetros ‘bajar_core’, ‘inst_spacy’,
  ‘inst_miniconda’, ‘inst_reticulate’ ingresados sean valores booleanos
  (de lo contrario envía un mensaje de advertencia)

- Crea una lista de seis objetos de tipo data frame:

  - **texto_tag**: es un objeto de clases ‘tokenIndex’ que sirve como
    input para la función
    [`acep_svo()`](https://agusnieto77.github.io/ACEP/reference/acep_svo.md).
    Contiene 20 variables que reúnen información de los procesos de
    tokenización, lematización, etiquetado pos, etiquetado de relaciones
    de dependencia, etiquetado NER y morfológico.

  - **texto_tag_entity**: es un objeto de clase ‘spacyr_parsed’ con una
    columna que identifica los distintos tipos de entidades.

  - **texto_only_entity**: es un ‘data.frame’ con 4 variables que
    contiene solo las entidades identificadas.

  - **texto_only_entity_loc**: es un ‘data.frame’ de 7 variables que
    permite la georreferenciación de las entidades identificadas como
    tipo ‘LOC’.

  - **texto_nounphrase**: es un objeto de clase ‘spacyr_parsed’ con una
    columna que identifica las distintas frases compuestas por
    sustantivos (nounphrase).

  - **texto_only_nounphrase**: es un ‘data.frame’ con tres variables que
    identifica y filtra los sustantivos que forman frases:
    ‘las_principales_ciudades’.

Cabe mencionar que los textos ingresados son tokenizados, es decir, cada
palabra es un token.

``` r
titulares_tags <- acep_postag(
  texto = titulares,
  core = "es_core_news_lg", # valor por defecto
  bajar_core = FALSE,       # el valor por defecto es TRUE
  inst_spacy = FALSE,       # valor por defecto
  inst_miniconda = FALSE,   # valor por defecto
  inst_reticulate = FALSE   # valor por defecto
)

str(titulares_tags)
```

    #> List of 6
    #>  $ texto_tag            :Classes 'tokenIndex', 'data.table' and 'data.frame':    153 obs. of  20 variables:
    #>   ..$ doc_id        : int [1:153] 1 1 1 1 1 1 1 1 1 1 ...
    #>   ..$ sentence      : int [1:153] 1 1 1 1 1 1 1 1 1 1 ...
    #>   ..$ token_id      : num [1:153] 1 2 3 4 5 6 7 8 9 10 ...
    #>   ..$ token         : chr [1:153] "Sindicatos" "y" "estudiantes" "marchan" ...
    #>   ..$ lemma         : chr [1:153] "Sindicatos" "y" "estudiante" "marchar" ...
    #>   ..$ pos           : chr [1:153] "PROPN" "CCONJ" "NOUN" "VERB" ...
    #>   ..$ parent        : num [1:153] 4 3 1 NA 8 8 8 4 10 8 ...
    #>   ..$ relation      : chr [1:153] "nsubj" "cc" "conj" "ROOT" ...
    #>   .. ..- attr(*, "levels")= chr "ROOT"
    #>   ..$ entity        : chr [1:153] "" "" "" "" ...
    #>   ..$ nounphrase    : chr [1:153] "beg_root" "" "beg_root" "" ...
    #>   ..$ whitespace    : logi [1:153] TRUE TRUE TRUE TRUE TRUE TRUE ...
    #>   ..$ is_upper      : logi [1:153] FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ is_title      : logi [1:153] TRUE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ is_quote      : logi [1:153] FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ ent_iob_      : chr [1:153] "O" "O" "O" "O" ...
    #>   ..$ ent_iob       : int [1:153] 2 2 2 2 2 2 2 2 2 3 ...
    #>   ..$ is_left_punct : logi [1:153] FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ is_right_punct: logi [1:153] FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ morph         : chr [1:153] "" "" "Number=Plur" "Mood=Ind|Number=Plur|Person=3|Tense=Pres|VerbForm=Fin" ...
    #>   ..$ sent          : chr [1:153] "Sindicatos y estudiantes marchan por las principales ciudades de México para exigir un cambio en la política ec"| __truncated__ "Sindicatos y estudiantes marchan por las principales ciudades de México para exigir un cambio en la política ec"| __truncated__ "Sindicatos y estudiantes marchan por las principales ciudades de México para exigir un cambio en la política ec"| __truncated__ "Sindicatos y estudiantes marchan por las principales ciudades de México para exigir un cambio en la política ec"| __truncated__ ...
    #>   ..- attr(*, ".internal.selfref")=<externalptr> 
    #>   ..- attr(*, "sorted")= chr [1:3] "doc_id" "sentence" "token_id"
    #>   ..- attr(*, "index")= int(0) 
    #>   .. ..- attr(*, "__doc_id__sentence__parent")= int [1:153] 4 3 2 1 8 12 21 5 6 7 ...
    #>   .. ..- attr(*, "__relation")= int [1:153] 4 25 46 57 71 88 101 109 116 131 ...
    #>  $ texto_tag_entity     :Classes 'spacyr_parsed' and 'data.frame':   149 obs. of  7 variables:
    #>   ..$ doc_id     : int [1:149] 1 1 1 1 1 1 1 1 1 1 ...
    #>   ..$ sentence_id: int [1:149] 1 1 1 1 1 1 1 1 1 1 ...
    #>   ..$ token_id   : num [1:149] 1 2 3 4 5 6 7 8 9 10 ...
    #>   ..$ token      : chr [1:149] "Sindicatos" "y" "estudiantes" "marchan" ...
    #>   ..$ lemma      : chr [1:149] "Sindicatos" "y" "estudiante" "marchar" ...
    #>   ..$ pos        : chr [1:149] "PROPN" "CCONJ" "NOUN" "VERB" ...
    #>   ..$ entity_type: chr [1:149] "" "" "" "" ...
    #>  $ texto_only_entity    :'data.frame':   13 obs. of  4 variables:
    #>   ..$ doc_id     : int [1:13] 1 1 1 1 3 4 5 5 5 6 ...
    #>   ..$ sentence_id: int [1:13] 1 1 2 2 1 1 1 1 1 1 ...
    #>   ..$ entity     : chr [1:13] "México" "Gobierno" "Larreta" "Ciudad_de_Buenos_Aires" ...
    #>   ..$ entity_type: chr [1:13] "LOC" "ORG" "PER" "LOC" ...
    #>  $ texto_only_entity_loc:'data.frame':   4 obs. of  7 variables:
    #>   ..$ doc_id     : int [1:4] 1 1 3 6
    #>   ..$ sentence   : int [1:4] 1 2 1 1
    #>   ..$ entity_    : chr [1:4] "México" "Ciudad de Buenos Aires" "Chubut" "Tucumán"
    #>   ..$ entity     : chr [1:4] "México" "Ciudad_de_Buenos_Aires" "Chubut" "Tucumán"
    #>   ..$ entity_type: chr [1:4] "LOC" "LOC" "LOC" "LOC"
    #>   ..$ lat        : num [1:4] 23.7 -34.6 -43.7 -26.6
    #>   ..$ long       : num [1:4] -102 -58.4 -68.7 -64.9
    #>  $ texto_nounphrase     :Classes 'spacyr_parsed' and 'data.frame':   120 obs. of  6 variables:
    #>   ..$ doc_id     : int [1:120] 1 1 1 1 1 1 1 1 1 1 ...
    #>   ..$ sentence_id: int [1:120] 1 1 1 1 1 1 1 1 1 1 ...
    #>   ..$ token_id   : num [1:120] 1 2 3 4 5 6 7 8 9 10 ...
    #>   ..$ token      : chr [1:120] "Sindicatos" "y" "estudiantes" "marchan" ...
    #>   ..$ lemma      : chr [1:120] "Sindicatos" "y" "estudiante" "marchar" ...
    #>   ..$ pos        : chr [1:120] "nounphrase" "CCONJ" "nounphrase" "VERB" ...
    #>  $ texto_only_nounphrase:'data.frame':   45 obs. of  3 variables:
    #>   ..$ doc_id     : int [1:45] 1 1 1 1 1 1 1 1 1 1 ...
    #>   ..$ sentence_id: int [1:45] 1 1 1 1 1 1 1 2 2 2 ...
    #>   ..$ nounphrase : chr [1:45] "Sindicatos" "estudiantes" "las_principales_ciudades" "México" ...

En este resultado podemos ver cómo la función crea los seis marcos de
datos con información relevante sobre el contenido y la forma de los
textos ingresados. En nuestro caso, textos referidos a conflictos.

Veamos con un poco más de detalle cada uno de los marcos de datos
creados con la función
[`acep_postag()`](https://agusnieto77.github.io/ACEP/reference/acep_postag.md):

### texto_tag

Como adelantamos, el primer objeto de la lista es un marco de datos
estructurado para servir de input de la función
[`acep_svo()`](https://agusnieto77.github.io/ACEP/reference/acep_svo.md).

``` r
head(titulares_tags$texto_tag[43:54, ], n = 12)
```

    #> Key: <doc_id, sentence, token_id>
    #>     doc_id sentence token_id      token     lemma    pos parent relation entity
    #>      <int>    <int>    <num>     <char>    <char> <char>  <num>   <char> <char>
    #>  1:      2        1        1        Los        el    DET      2      det       
    #>  2:      2        1        2    gremios    gremio   NOUN      4    nsubj       
    #>  3:      2        1        3   docentes   docente    ADJ      2     amod       
    #>  4:      2        1        4   rechazan  rechazar   VERB     NA     ROOT       
    #>  5:      2        1        5     volver    volver   VERB      4    xcomp       
    #>  6:      2        1        6          a         a    ADP      8     case       
    #>  7:      2        1        7        las        el    DET      8      det       
    #>  8:      2        1        8      aulas      aula   NOUN      5      obl       
    #>  9:      2        1        9        sin       sin    ADP     10     case       
    #> 10:      2        1       10  garantías  garantía   NOUN      5      obl       
    #> 11:      2        1       11 sanitarias sanitario    ADJ     10     amod       
    #> 12:      2        1       12          .         .  PUNCT      4    punct       
    #>     nounphrase whitespace is_upper is_title is_quote ent_iob_ ent_iob
    #>         <char>     <lgcl>   <lgcl>   <lgcl>   <lgcl>   <char>   <int>
    #>  1:        beg       TRUE    FALSE     TRUE    FALSE        O       2
    #>  2:   end_root       TRUE    FALSE    FALSE    FALSE        O       2
    #>  3:                  TRUE    FALSE    FALSE    FALSE        O       2
    #>  4:                  TRUE    FALSE    FALSE    FALSE        O       2
    #>  5:                  TRUE    FALSE    FALSE    FALSE        O       2
    #>  6:                  TRUE    FALSE    FALSE    FALSE        O       2
    #>  7:        beg       TRUE    FALSE    FALSE    FALSE        O       2
    #>  8:   end_root       TRUE    FALSE    FALSE    FALSE        O       2
    #>  9:                  TRUE    FALSE    FALSE    FALSE        O       2
    #> 10:   beg_root       TRUE    FALSE    FALSE    FALSE        O       2
    #> 11:                 FALSE    FALSE    FALSE    FALSE        O       2
    #> 12:                 FALSE    FALSE    FALSE    FALSE        O       2
    #>     is_left_punct is_right_punct
    #>            <lgcl>         <lgcl>
    #>  1:         FALSE          FALSE
    #>  2:         FALSE          FALSE
    #>  3:         FALSE          FALSE
    #>  4:         FALSE          FALSE
    #>  5:         FALSE          FALSE
    #>  6:         FALSE          FALSE
    #>  7:         FALSE          FALSE
    #>  8:         FALSE          FALSE
    #>  9:         FALSE          FALSE
    #> 10:         FALSE          FALSE
    #> 11:         FALSE          FALSE
    #> 12:         FALSE          FALSE
    #>                                                     morph
    #>                                                    <char>
    #>  1:     Definite=Def|Gender=Masc|Number=Plur|PronType=Art
    #>  2:                               Gender=Masc|Number=Plur
    #>  3:                                           Number=Plur
    #>  4: Mood=Ind|Number=Plur|Person=3|Tense=Pres|VerbForm=Fin
    #>  5:                                          VerbForm=Inf
    #>  6:                                          AdpType=Prep
    #>  7:      Definite=Def|Gender=Fem|Number=Plur|PronType=Art
    #>  8:                                Gender=Fem|Number=Plur
    #>  9:                                          AdpType=Prep
    #> 10:                                Gender=Fem|Number=Plur
    #> 11:                                Gender=Fem|Number=Plur
    #> 12:                                        PunctType=Peri
    #>                                                                           sent
    #>                                                                         <char>
    #>  1: Los gremios docentes rechazan volver a las aulas sin garantías sanitarias.
    #>  2: Los gremios docentes rechazan volver a las aulas sin garantías sanitarias.
    #>  3: Los gremios docentes rechazan volver a las aulas sin garantías sanitarias.
    #>  4: Los gremios docentes rechazan volver a las aulas sin garantías sanitarias.
    #>  5: Los gremios docentes rechazan volver a las aulas sin garantías sanitarias.
    #>  6: Los gremios docentes rechazan volver a las aulas sin garantías sanitarias.
    #>  7: Los gremios docentes rechazan volver a las aulas sin garantías sanitarias.
    #>  8: Los gremios docentes rechazan volver a las aulas sin garantías sanitarias.
    #>  9: Los gremios docentes rechazan volver a las aulas sin garantías sanitarias.
    #> 10: Los gremios docentes rechazan volver a las aulas sin garantías sanitarias.
    #> 11: Los gremios docentes rechazan volver a las aulas sin garantías sanitarias.
    #> 12: Los gremios docentes rechazan volver a las aulas sin garantías sanitarias.

### texto_tag_entity

El segundo objeto de la lista es un marco de datos que reescribe la
columna ‘pos’ con la etiqueta ‘ENTITY’ e identifica el tipo de entidad
en la columna ‘entity_type’. Si la entidad detectada está compuesta por
más de un token, la función colapsa todos los tokens referidos a esa
entidad en una sola celda de la columna token. Ejemplo:
‘Ciudad_de_Buenos_Aires’.

``` r
head(titulares_tags$texto_tag_entity[52:65, ], n = 14)
```

    #>    doc_id sentence_id token_id      token    lemma    pos entity_type
    #> 52      3           1        1        Los       el    DET            
    #> 53      3           1        2  estatales  estatal   NOUN            
    #> 54      3           1        3 rechazaron rechazar   VERB            
    #> 55      3           1        4         la       el    DET            
    #> 56      3           1        5     oferta   oferta   NOUN            
    #> 57      3           1        6   salarial salarial    ADJ            
    #> 58      3           1        7        que      que   PRON            
    #> 59      3           1        8        les       él   PRON            
    #> 60      3           1        9       hizo    hacer   VERB            
    #> 61      3           1       10         el       el    DET            
    #> 62      3           1       11   gobierno gobierno   NOUN            
    #> 63      3           1       12         en       en    ADP            
    #> 64      3           1       13     Chubut   Chubut ENTITY         LOC
    #> 65      3           1       14          .        .  PUNCT

### texto_only_entity

El tercer objeto de la lista es el marco de datos ‘texto_tag_entity’
filtrado por el valor ‘ENTITY’ de la columna ‘pos’.

``` r
head(titulares_tags$texto_only_entity, n = 10)
```

    #>    doc_id sentence_id                 entity entity_type
    #> 1       1           1                 México         LOC
    #> 2       1           1               Gobierno         ORG
    #> 3       1           2                Larreta         PER
    #> 4       1           2 Ciudad_de_Buenos_Aires         LOC
    #> 5       3           1                 Chubut         LOC
    #> 6       4           1                    CGT         ORG
    #> 7       5           1                    CTA         ORG
    #> 8       5           1              Izquierda         ORG
    #> 9       5           1                    CGT         ORG
    #> 10      6           1                Tucumán         LOC

### texto_only_entity_loc

El cuarto objeto de la lista es el marco de datos ‘texto_only_entity’
filtrado por el valor ‘LOC’ de la columna ‘entity_type’ y procesado con
la función ‘geo()’ del paquete *tidygeocoder*.

``` r
head(titulares_tags$texto_only_entity_loc[ , c(1:3, 6:7)], n = 4)
```

    #>    doc_id sentence                entity_       lat       long
    #> 1       1        1                 México  23.65851 -102.00771
    #> 22      1        2 Ciudad de Buenos Aires -34.60757  -58.43709
    #> 43      3        1                 Chubut -43.71284  -68.74618
    #> 57      6        1                Tucumán -26.56436  -64.88240

### texto_nounphrase

El quinto objeto de la lista es un marco de datos que reescribe la
columna ‘pos’ con la etiqueta ‘nounphrase’. Si el sustantivo detectado
está compuesto por más de un token, la función colapsa todos los tokens
referidos a ese sustantivo en una sola celda de la columna token.
Ejemplo: ‘las_principales_ciudades’.

``` r
head(titulares_tags$texto_nounphrase[ , c(1:2, 4, 6)], n = 10)
```

    #>    doc_id sentence_id                    token        pos
    #> 1       1           1               Sindicatos nounphrase
    #> 2       1           1                        y      CCONJ
    #> 3       1           1              estudiantes nounphrase
    #> 4       1           1                  marchan       VERB
    #> 5       1           1                      por        ADP
    #> 6       1           1 las_principales_ciudades nounphrase
    #> 7       1           1                       de        ADP
    #> 8       1           1                   México nounphrase
    #> 9       1           1                     para        ADP
    #> 10      1           1                   exigir       VERB

### texto_only_nounphrase

El sexto objeto de la lista es el marco de datos ‘texto_nounphrase’
filtrado por el valor ‘nounphrase’ de la columna ‘pos’.

``` r
head(titulares_tags$texto_only_nounphrase, n = 10)
```

    #>    doc_id sentence_id               nounphrase
    #> 1       1           1               Sindicatos
    #> 2       1           1              estudiantes
    #> 3       1           1 las_principales_ciudades
    #> 4       1           1                   México
    #> 5       1           1                un_cambio
    #> 6       1           1              la_política
    #> 7       1           1                 Gobierno
    #> 8       1           2              Los_gremios
    #> 9       1           2                  un_paro
    #> 10      1           2        la_presencialidad

## Función `acep_upos()`

Esta función realiza etiquetado POS, lematización, tokenización, pero no
realiza extracción de entidades y, por ende, no puede hacer
georreferenciación. Para llevar a cabo estas tareas acep_upos envuelve
la función udpipe() de la librería homonimia.

**Advertencia**: ponemos esta alternativa a `acep_postag` porque la
instalación de *reticulate*, *anaconda* y las librerías de Python
necesarias para el funcionamiento de *spacyr* pueden traer más de un
problema.

Repetimos el proceso realizado con la función `acep_postag`: activamos
la librería *ACEP*, luego, cargamos un vector de titulares de portales
noticiosos sobre notas referidas a conflictos para su prueba, y
agregamos una última oración unimembre como ejemplo extremo de oración
no procesable con la función
[`acep_svo()`](https://agusnieto77.github.io/ACEP/reference/acep_svo.md).

``` r
library(ACEP)

titulares <- c(acep_bases$titulares, "Hola mundo.")

titulares
```

    #> [1] "Sindicatos y estudiantes marchan por las principales ciudades de México para exigir un cambio en la política económica del Gobierno.\n          Los gremios convocan a un paro docente contra 'la presencialidad de Larreta' en Ciudad de Buenos Aires."
    #> [2] "Los gremios docentes rechazan volver a las aulas sin garantías sanitarias."                                                                                                                                                                             
    #> [3] "Los estatales rechazaron la oferta salarial que les hizo el gobierno en Chubut."                                                                                                                                                                        
    #> [4] "La CGT presiona para que los 1700 empleados cobren la doble indemnización."                                                                                                                                                                             
    #> [5] "Las dos CTA y la Izquierda rechazaron el acuerdo de la CGT para rebajar salarios."                                                                                                                                                                      
    #> [6] "Un gremio aéreo levantó el paro en Tucumán. Los judiciales ratificaron un paro.\n          La CGT marchó con críticas por la economía y evalúa si llama a un paro."                                                                                     
    #> [7] "Ctera convocó a un paro de 72 horas en todo el país."                                                                                                                                                                                                   
    #> [8] "Conciliación obligatoria en el conflicto del neumático."                                                                                                                                                                                                
    #> [9] "Hola mundo."

Ejecutamos la función
[`acep_upos()`](https://agusnieto77.github.io/ACEP/reference/acep_upos.md)
para los titulares contenidos en el vector.

¿Cuál es el resultado?

La función `acep_upos` toma el vector de textos y realiza diferentes
acciones:

- Verifica que el objeto entregado sea un vector de tipo caracter (de lo
  contrario imprime un mensaje de advertencia)

- Verifica que el parámetro ‘modelo’ sean un modelo válido (de lo
  contrario devuelve un mensaje de advertencia)

- Crea un objeto de clases ‘tokenIndex’ que sirve como input para la
  función
  [`acep_svo()`](https://agusnieto77.github.io/ACEP/reference/acep_svo.md).
  Contiene 17 variables que reúnen información de los procesos de
  tokenización, lematización, etiquetado pos, etiquetado de relaciones
  de dependencia y morfológico.

Cabe mencionar que, al igual que acep_postag, los textos ingresados son
tokenizados, es decir, cada palabra es un token.

``` r
titulares_utags <- acep_upos(
  texto = titulares,
  modelo = "spanish" # valor por defecto
)

str(titulares_utags)
```

    #> Classes 'tokenIndex', 'data.table' and 'data.frame': 153 obs. of  17 variables:
    #>  $ doc_id      : int  1 1 1 1 1 1 1 1 1 1 ...
    #>  $ paragraph_id: int  1 1 1 1 1 1 1 1 1 1 ...
    #>  $ sentence    : int  1 1 1 1 1 1 1 1 1 1 ...
    #>  $ sent        : chr  "Sindicatos y estudiantes marchan por las principales ciudades de México para exigir un cambio en la política ec"| __truncated__ "Sindicatos y estudiantes marchan por las principales ciudades de México para exigir un cambio en la política ec"| __truncated__ "Sindicatos y estudiantes marchan por las principales ciudades de México para exigir un cambio en la política ec"| __truncated__ "Sindicatos y estudiantes marchan por las principales ciudades de México para exigir un cambio en la política ec"| __truncated__ ...
    #>  $ start       : int  1 12 14 26 34 38 42 54 63 66 ...
    #>  $ end         : int  10 12 24 32 36 40 52 61 64 71 ...
    #>  $ term_id     : int  1 2 3 4 5 6 7 8 9 10 ...
    #>  $ token_id    : num  1 2 3 4 5 6 7 8 9 10 ...
    #>  $ token       : chr  "Sindicatos" "y" "estudiantes" "marchan" ...
    #>  $ lemma       : chr  "sindicatos" "y" "estudiante" "marchar" ...
    #>  $ pos         : chr  "NOUN" "CCONJ" "NOUN" "VERB" ...
    #>  $ xpos        : chr  NA NA NA NA ...
    #>  $ morph       : chr  "Gender=Masc|Number=Plur" NA "Number=Plur" "Mood=Ind|Number=Plur|Person=3|Tense=Pres|VerbForm=Fin" ...
    #>  $ parent      : num  4 3 1 NA 8 8 8 4 10 8 ...
    #>  $ relation    : chr  "nsubj" "cc" "conj" "ROOT" ...
    #>   ..- attr(*, "levels")= chr "ROOT"
    #>  $ deps        : chr  NA NA NA NA ...
    #>  $ misc        : chr  NA NA NA NA ...
    #>  - attr(*, ".internal.selfref")=<externalptr> 
    #>  - attr(*, "sorted")= chr [1:3] "doc_id" "sentence" "token_id"
    #>  - attr(*, "index")= int(0) 
    #>   ..- attr(*, "__doc_id__sentence__parent")= int [1:153] 4 3 2 1 8 12 22 5 6 7 ...
    #>   ..- attr(*, "__relation")= int [1:153] 4 25 46 57 71 88 101 109 115 130 ...

En este resultado podemos ver cómo la función crea el input para usar
con
[`acep_svo()`](https://agusnieto77.github.io/ACEP/reference/acep_svo.md).
Hay que tener en cuenta que *udpipe* y *spacyr* usan modelos distintos
para el etiquetado pos y las relaciones de dependencia, así como para
parsear el texto en oraciones. Por ende, el resultado obtenido de la
función `acep_svo` puede ser ligeramente diferente si usamos uno u otro
modelo de etiquetado. En el ejemplo que sigue usaremos el output de la
función `acep_upos`.

## Función `acep_svo()`

Una vez que tenemos la lista, con 6 marcos de datos, creada a partir de
la función
[`acep_upos()`](https://agusnieto77.github.io/ACEP/reference/acep_upos.md),
podemos utilizar la función
[`acep_svo()`](https://agusnieto77.github.io/ACEP/reference/acep_svo.md)
para obtener un listado nuevo, con otros 6 marcos de datos, que nos
proveerá la siguiente información:

- acep_annotate_svo: es un marco de datos con 22 variables. Mantiene la
  estructura del objeto ingresado a la función (titulares_utags) y
  agrega 5 nuevas variables (‘s_v_o’, ‘s_v_o_id’, ‘s_v_o_fill’, ‘s_p’,
  ‘conjugaciones’).

- acep_pro_svo: es un marco de datos con 13 variables (‘doc_id’,
  ‘oracion_id’, ‘eventos’, ‘sujeto_svo’, ‘root’, ‘objeto’, ‘sujeto’,
  ‘predicado’, ‘verbo’, ‘lemma_verb’, ‘aux_verbos’, ‘entidades’,
  ‘sust_pred’) que reúne los tripletes SVO e información de contexto.
  Ejemplo de extracción SVO: “gremios -\> convocan -\> paro
  presencialidad”.

- acep_list_svo: es un marco de datos con 6 variables (‘doc_id’,
  ‘oracion_id’, ‘eventos’, ‘sujeto’, ‘verbo’ ‘objeto’) que procesa los
  tripletes SVO y los devuelve separados en sujeto, verbo, objeto.
  Ejemplo de extracción SVO: “gremios” “convocan” “paro presencialidad”.

- acep_sp: es un marco de datos con 9 variables (‘doc_id’, ‘oracion_id’,
  ‘sujeto’, ‘predicado’, ‘verbo’, ‘lemma_verb’, ‘aux_verbos’,
  ‘entidades’, ‘sust_pred’) que ofrece más información de contexto como
  entidades, sustantivos dentro de la oración analizada, etc.

- acep_lista_lemmas: es un marco de datos con dos variables (‘lemma’,
  ‘n’) que ofrece la frecuencia absoluta de las palabras lemmatizadas
  presentes en el corpus analizado.

- acep_no_procesadas: es un marco de datos con tres variables (‘doc_id’,
  ‘oracion_id’, ‘oracion’) que ofrece la frecuencia absoluta de las
  palabras lemmatizadas presentes en el corpus analizado.

``` r
titulares_svo <- acep_svo(titulares_utags)

str(titulares_svo)
```

    #> List of 6
    #>  $ acep_annotate_svo :Classes 'tokenIndex', 'data.table' and 'data.frame':   153 obs. of  22 variables:
    #>   ..$ doc_id       : int [1:153] 1 1 1 1 1 1 1 1 1 1 ...
    #>   ..$ paragraph_id : int [1:153] 1 1 1 1 1 1 1 1 1 1 ...
    #>   ..$ sentence     : int [1:153] 1 1 1 1 1 1 1 1 1 1 ...
    #>   ..$ sent         : chr [1:153] "Sindicatos y estudiantes marchan por las principales ciudades de México para exigir un cambio en la política ec"| __truncated__ "Sindicatos y estudiantes marchan por las principales ciudades de México para exigir un cambio en la política ec"| __truncated__ "Sindicatos y estudiantes marchan por las principales ciudades de México para exigir un cambio en la política ec"| __truncated__ "Sindicatos y estudiantes marchan por las principales ciudades de México para exigir un cambio en la política ec"| __truncated__ ...
    #>   ..$ start        : int [1:153] 1 12 14 26 34 38 42 54 63 66 ...
    #>   ..$ end          : int [1:153] 10 12 24 32 36 40 52 61 64 71 ...
    #>   ..$ term_id      : int [1:153] 1 2 3 4 5 6 7 8 9 10 ...
    #>   ..$ token_id     : num [1:153] 1 2 3 4 5 6 7 8 9 10 ...
    #>   ..$ token        : chr [1:153] "Sindicatos" "y" "estudiantes" "marchan" ...
    #>   ..$ lemma        : chr [1:153] "sindicatos" "y" "estudiante" "marchar" ...
    #>   ..$ pos          : chr [1:153] "NOUN" "CCONJ" "NOUN" "VERB" ...
    #>   ..$ xpos         : chr [1:153] NA NA NA NA ...
    #>   ..$ morph        : chr [1:153] "Gender=Masc|Number=Plur" NA "Number=Plur" "Mood=Ind|Number=Plur|Person=3|Tense=Pres|VerbForm=Fin" ...
    #>   ..$ parent       : num [1:153] 4 3 1 NA 8 8 8 4 10 8 ...
    #>   ..$ relation     : chr [1:153] "nsubj" "cc" "conj" "ROOT" ...
    #>   .. ..- attr(*, "levels")= chr "ROOT"
    #>   ..$ deps         : chr [1:153] NA NA NA NA ...
    #>   ..$ misc         : chr [1:153] NA NA NA NA ...
    #>   ..$ s_v_o        : Factor w/ 3 levels "objeto","sujeto",..: 2 NA 1 3 NA NA 1 1 NA 1 ...
    #>   ..$ s_v_o_id     : Factor w/ 10 levels "1.1.4","1.2.3",..: 1 NA 1 1 NA NA 1 1 NA 1 ...
    #>   ..$ s_v_o_fill   : num [1:153] 0 NA 0 0 NA NA 1 0 NA 1 ...
    #>   ..$ s_p          : chr [1:153] "sujeto" "sujeto" "sujeto" "predicado" ...
    #>   ..$ conjugaciones: chr [1:153] NA NA NA "presente" ...
    #>   ..- attr(*, ".internal.selfref")=<externalptr> 
    #>   ..- attr(*, "sorted")= chr [1:3] "doc_id" "sentence" "token_id"
    #>  $ acep_pro_svo      :'data.frame':  10 obs. of  13 variables:
    #>   ..$ doc_id    : int [1:10] 1 1 2 3 4 5 6 6 6 7
    #>   ..$ oracion_id: int [1:10] 1 2 1 1 1 1 1 2 3 1
    #>   ..$ eventos   : chr [1:10] "Sindicatos -> marchan -> ciudades cambio" "gremios -> convocan -> paro" "gremios -> rechazan -> aulas garantías" "estatales -> rechazaron -> oferta gobierno Chubut" ...
    #>   ..$ sujeto_svo: chr [1:10] "Sindicatos" "gremios" "gremios" "estatales" ...
    #>   ..$ root      : chr [1:10] "marchan" "convocan" "rechazan" "rechazaron" ...
    #>   ..$ objeto    : chr [1:10] "ciudades cambio" "paro" "aulas garantías" "oferta gobierno Chubut" ...
    #>   ..$ sujeto    : chr [1:10] "Sindicatos estudiantes" "gremios" "gremios docentes" "estatales" ...
    #>   ..$ predicado : chr [1:10] "marchan principales ciudades México exigir cambio política económica Gobierno" "convocan paro docente presencialidad Larreta Ciudad Buenos Aires" "rechazan volver aulas garantías sanitarias" "rechazaron oferta salarial gobierno Chubut" ...
    #>   ..$ verbo     : chr [1:10] "marchan" "convocan" "rechazan" "rechazaron" ...
    #>   ..$ lemma_verb: chr [1:10] "marchan" "convocan" "rechazan" "rechazaron" ...
    #>   ..$ aux_verbos: chr [1:10] "| exigir |" "| NA |" "| volver |" "| NA |" ...
    #>   ..$ entidades : chr [1:10] "| México |" "| Larreta | Ciudad | Buenos | Aires |" "| NA |" "| Chubut |" ...
    #>   ..$ sust_pred : chr [1:10] "ciudades | México | cambio | política | Gobierno" "paro | presencialidad | Larreta | Ciudad | Buenos | Aires" "aulas | garantías" "oferta | gobierno | Chubut" ...
    #>  $ acep_list_svo     :'data.frame':  10 obs. of  6 variables:
    #>   ..$ doc_id    : int [1:10] 1 1 2 3 4 5 6 6 6 7
    #>   ..$ oracion_id: int [1:10] 1 2 1 1 1 1 1 2 3 1
    #>   ..$ eventos   : chr [1:10] "Sindicatos -> marchan -> ciudades cambio" "gremios -> convocan -> paro" "gremios -> rechazan -> aulas garantías" "estatales -> rechazaron -> oferta gobierno Chubut" ...
    #>   ..$ sujeto    : chr [1:10] "Sindicatos" "gremios" "gremios" "estatales" ...
    #>   ..$ verbo     : chr [1:10] "marchan" "convocan" "rechazan" "rechazaron" ...
    #>   ..$ objeto    : chr [1:10] "ciudades cambio" "paro" "aulas garantías" "oferta gobierno Chubut" ...
    #>  $ acep_sp           :'data.frame':  10 obs. of  9 variables:
    #>   ..$ doc_id    : int [1:10] 1 1 2 3 4 5 6 6 6 7
    #>   ..$ oracion_id: int [1:10] 1 2 1 1 1 1 1 2 3 1
    #>   ..$ sujeto    : chr [1:10] "Sindicatos estudiantes" "gremios" "gremios docentes" "estatales" ...
    #>   ..$ predicado : chr [1:10] "marchan principales ciudades México exigir cambio política económica Gobierno" "convocan paro docente presencialidad Larreta Ciudad Buenos Aires" "rechazan volver aulas garantías sanitarias" "rechazaron oferta salarial gobierno Chubut" ...
    #>   ..$ verbo     : chr [1:10] "marchan" "convocan" "rechazan" "rechazaron" ...
    #>   ..$ lemma_verb: chr [1:10] "marchan" "convocan" "rechazan" "rechazaron" ...
    #>   ..$ aux_verbos: chr [1:10] "| exigir |" "| NA |" "| volver |" "| NA |" ...
    #>   ..$ entidades : chr [1:10] "| México |" "| Larreta | Ciudad | Buenos | Aires |" "| NA |" "| Chubut |" ...
    #>   ..$ sust_pred : chr [1:10] "ciudades | México | cambio | política | Gobierno" "paro | presencialidad | Larreta | Ciudad | Buenos | Aires" "aulas | garantías" "oferta | gobierno | Chubut" ...
    #>  $ acep_lista_lemmas :'data.frame':  58 obs. of  2 variables:
    #>   ..$ lemma: Factor w/ 58 levels "acuerdo","aéreo",..: 45 7 28 52 9 13 18 27 38 1 ...
    #>   ..$ n    : int [1:58] 5 3 3 3 2 2 2 2 2 1 ...
    #>  $ acep_no_procesadas:Classes 'tokenIndex', 'data.table' and 'data.frame':   2 obs. of  3 variables:
    #>   ..$ doc_id    : int [1:2] 8 9
    #>   ..$ oracion_id: int [1:2] 1 1
    #>   ..$ oracion   : chr [1:2] "Conciliación obligatoria en el conflicto del neumático." "Hola mundo."
    #>   ..- attr(*, ".internal.selfref")=<externalptr> 
    #>   ..- attr(*, "sorted")= chr [1:2] "doc_id" "oracion_id"

Veamos con un poco más de detalle cada uno de los marcos de datos
creados con la función
[`acep_svo()`](https://agusnieto77.github.io/ACEP/reference/acep_svo.md).

### acep_annotate_svo

Es el marco de datos inicial procesado con las funciones del paquete
*rsyntax*.

``` r
head(titulares_svo$acep_annotate_svo[98:106, ], n=20)
```

    #> Key: <doc_id, sentence, token_id>
    #>    doc_id paragraph_id sentence                                        sent
    #>     <int>        <int>    <int>                                      <char>
    #> 1:      6            1        1 Un gremio aéreo levantó el paro en Tucumán.
    #> 2:      6            1        1 Un gremio aéreo levantó el paro en Tucumán.
    #> 3:      6            1        1 Un gremio aéreo levantó el paro en Tucumán.
    #> 4:      6            1        1 Un gremio aéreo levantó el paro en Tucumán.
    #> 5:      6            1        1 Un gremio aéreo levantó el paro en Tucumán.
    #> 6:      6            1        1 Un gremio aéreo levantó el paro en Tucumán.
    #> 7:      6            1        1 Un gremio aéreo levantó el paro en Tucumán.
    #> 8:      6            1        1 Un gremio aéreo levantó el paro en Tucumán.
    #> 9:      6            1        1 Un gremio aéreo levantó el paro en Tucumán.
    #>    start   end term_id token_id   token    lemma    pos   xpos
    #>    <int> <int>   <int>    <num>  <char>   <char> <char> <char>
    #> 1:     1     2       1        1      Un      uno    DET   <NA>
    #> 2:     4     9       2        2  gremio   gremio   NOUN   <NA>
    #> 3:    11    15       3        3   aéreo    aéreo    ADJ   <NA>
    #> 4:    17    23       4        4 levantó levantar   VERB   <NA>
    #> 5:    25    26       5        5      el       el    DET   <NA>
    #> 6:    28    31       6        6    paro     paro   NOUN   <NA>
    #> 7:    33    34       7        7      en       en    ADP   <NA>
    #> 8:    36    42       8        8 Tucumán  tucumán  PROPN   <NA>
    #> 9:    43    43       9        9       .        .  PUNCT   <NA>
    #>                                                    morph parent relation   deps
    #>                                                   <char>  <num>   <char> <char>
    #> 1:     Definite=Ind|Gender=Masc|Number=Sing|PronType=Art      2      det   <NA>
    #> 2:                               Gender=Masc|Number=Sing      4    nsubj   <NA>
    #> 3:                               Gender=Masc|Number=Sing      2     amod   <NA>
    #> 4: Mood=Ind|Number=Sing|Person=3|Tense=Past|VerbForm=Fin     NA     ROOT   <NA>
    #> 5:     Definite=Def|Gender=Masc|Number=Sing|PronType=Art      6      det   <NA>
    #> 6:                               Gender=Masc|Number=Sing      4      obj   <NA>
    #> 7:                                                  <NA>      8     case   <NA>
    #> 8:                                                  <NA>      6     nmod   <NA>
    #> 9:                                                  <NA>      4    punct   <NA>
    #>             misc  s_v_o s_v_o_id s_v_o_fill       s_p conjugaciones
    #>           <char> <fctr>   <fctr>      <num>    <char>        <char>
    #> 1:          <NA>   <NA>     <NA>         NA    sujeto          <NA>
    #> 2:          <NA> sujeto    6.1.4          0    sujeto          <NA>
    #> 3:          <NA> sujeto    6.1.4          1    sujeto          <NA>
    #> 4:          <NA>  verbo    6.1.4          0 predicado        pasado
    #> 5:          <NA>   <NA>     <NA>         NA predicado          <NA>
    #> 6:          <NA> objeto    6.1.4          0 predicado          <NA>
    #> 7:          <NA>   <NA>     <NA>         NA predicado          <NA>
    #> 8: SpaceAfter=No objeto    6.1.4          1 predicado          <NA>
    #> 9:          <NA>   <NA>     <NA>         NA predicado          <NA>

### acep_annotate_svo

Este marco de datos contiene las oraciones procesables con la
identificación y extracción de sujeto-verbo-objeto y contexto.

``` r
head(titulares_svo$acep_pro_svo, n=10)
```

    #>    doc_id oracion_id                                           eventos
    #> 1       1          1          Sindicatos -> marchan -> ciudades cambio
    #> 2       1          2                       gremios -> convocan -> paro
    #> 3       2          1            gremios -> rechazan -> aulas garantías
    #> 4       3          1 estatales -> rechazaron -> oferta gobierno Chubut
    #> 5       4          1                  CGT -> presiona -> indemnización
    #> 6       5          1             CTA -> rechazaron -> acuerdo salarios
    #> 7       6          1                         gremio -> levantó -> paro
    #> 8       6          2                 judiciales -> ratificaron -> paro
    #> 9       6          3                    CGT -> marchó -> críticas paro
    #> 10      7          1                     Ctera -> convocó -> paro país
    #>    sujeto_svo        root                 objeto                 sujeto
    #> 1  Sindicatos     marchan        ciudades cambio Sindicatos estudiantes
    #> 2     gremios    convocan                   paro                gremios
    #> 3     gremios    rechazan        aulas garantías       gremios docentes
    #> 4   estatales  rechazaron oferta gobierno Chubut              estatales
    #> 5         CGT    presiona          indemnización                    CGT
    #> 6         CTA  rechazaron       acuerdo salarios          CTA Izquierda
    #> 7      gremio     levantó                   paro           gremio aéreo
    #> 8  judiciales ratificaron                   paro             judiciales
    #> 9         CGT      marchó          críticas paro                    CGT
    #> 10      Ctera     convocó              paro país                  Ctera
    #>                                                                        predicado
    #> 1  marchan principales ciudades México exigir cambio política económica Gobierno
    #> 2               convocan paro docente presencialidad Larreta Ciudad Buenos Aires
    #> 3                                     rechazan volver aulas garantías sanitarias
    #> 4                                     rechazaron oferta salarial gobierno Chubut
    #> 5                              presiona que empleados cobren doble indemnización
    #> 6                                        rechazaron acuerdo CGT rebajar salarios
    #> 7                                                           levantó paro Tucumán
    #> 8                                                               ratificaron paro
    #> 9                                     marchó críticas economía evalúa llama paro
    #> 10                                                       convocó paro horas país
    #>          verbo  lemma_verb         aux_verbos
    #> 1      marchan     marchan         | exigir |
    #> 2     convocan    convocan             | NA |
    #> 3     rechazan    rechazan         | volver |
    #> 4   rechazaron  rechazaron             | NA |
    #> 5     presiona    presiona         | cobren |
    #> 6   rechazaron  rechazaron        | rebajar |
    #> 7      levantó     levantó             | NA |
    #> 8  ratificaron ratificaron             | NA |
    #> 9       marchó      marchó | evalúa | llama |
    #> 10     convocó     convocó             | NA |
    #>                                entidades
    #> 1                             | México |
    #> 2  | Larreta | Ciudad | Buenos | Aires |
    #> 3                                 | NA |
    #> 4                             | Chubut |
    #> 5                                | CGT |
    #> 6                          | CTA | CGT |
    #> 7                            | Tucumán |
    #> 8                                 | NA |
    #> 9                                | CGT |
    #> 10                             | Ctera |
    #>                                                    sust_pred
    #> 1           ciudades | México | cambio | política | Gobierno
    #> 2  paro | presencialidad | Larreta | Ciudad | Buenos | Aires
    #> 3                                          aulas | garantías
    #> 4                                 oferta | gobierno | Chubut
    #> 5                                  empleados | indemnización
    #> 6                                   acuerdo | CGT | salarios
    #> 7                                             paro | Tucumán
    #> 8                                                       paro
    #> 9                                 críticas | economía | paro
    #> 10                                       paro | horas | país

### acep_list_svo

Este marco de datos es una versión reducida del data.frame
‘acep_pro_svo’. Solo contiene los tripletes sujeto-verbo-objeto en
versión colapsada (‘gremios -\> convocan -\> paro’) y en versión
separada (una columna para ‘sujeto’, otra para ‘verbo’ y otra para
‘objeto’).

``` r
head(titulares_svo$acep_list_svo, n=10)
```

    #>    doc_id oracion_id                                           eventos
    #> 1       1          1          Sindicatos -> marchan -> ciudades cambio
    #> 2       1          2                       gremios -> convocan -> paro
    #> 3       2          1            gremios -> rechazan -> aulas garantías
    #> 4       3          1 estatales -> rechazaron -> oferta gobierno Chubut
    #> 5       4          1                  CGT -> presiona -> indemnización
    #> 6       5          1             CTA -> rechazaron -> acuerdo salarios
    #> 7       6          1                         gremio -> levantó -> paro
    #> 8       6          2                 judiciales -> ratificaron -> paro
    #> 9       6          3                    CGT -> marchó -> críticas paro
    #> 10      7          1                     Ctera -> convocó -> paro país
    #>        sujeto       verbo                 objeto
    #> 1  Sindicatos     marchan        ciudades cambio
    #> 2     gremios    convocan                   paro
    #> 3     gremios    rechazan        aulas garantías
    #> 4   estatales  rechazaron oferta gobierno Chubut
    #> 5         CGT    presiona          indemnización
    #> 6         CTA  rechazaron       acuerdo salarios
    #> 7      gremio     levantó                   paro
    #> 8  judiciales ratificaron                   paro
    #> 9         CGT      marchó          críticas paro
    #> 10      Ctera     convocó              paro país

### acep_sp

Este marco de datos contiene los ‘sujetos’ y los ‘predicados’
identificados en cada oración y una aproximación a ‘entidades’,
‘sustantivos’ y ‘verbos auxiliares’ como contexto que ayuda a mejorar la
extracción de sujetos y objetos de la acción.

``` r
head(titulares_svo$acep_sp, n=10)
```

    #>    doc_id oracion_id                 sujeto
    #> 1       1          1 Sindicatos estudiantes
    #> 2       1          2                gremios
    #> 3       2          1       gremios docentes
    #> 4       3          1              estatales
    #> 5       4          1                    CGT
    #> 6       5          1          CTA Izquierda
    #> 7       6          1           gremio aéreo
    #> 8       6          2             judiciales
    #> 9       6          3                    CGT
    #> 10      7          1                  Ctera
    #>                                                                        predicado
    #> 1  marchan principales ciudades México exigir cambio política económica Gobierno
    #> 2               convocan paro docente presencialidad Larreta Ciudad Buenos Aires
    #> 3                                     rechazan volver aulas garantías sanitarias
    #> 4                                     rechazaron oferta salarial gobierno Chubut
    #> 5                              presiona que empleados cobren doble indemnización
    #> 6                                        rechazaron acuerdo CGT rebajar salarios
    #> 7                                                           levantó paro Tucumán
    #> 8                                                               ratificaron paro
    #> 9                                     marchó críticas economía evalúa llama paro
    #> 10                                                       convocó paro horas país
    #>          verbo  lemma_verb         aux_verbos
    #> 1      marchan     marchan         | exigir |
    #> 2     convocan    convocan             | NA |
    #> 3     rechazan    rechazan         | volver |
    #> 4   rechazaron  rechazaron             | NA |
    #> 5     presiona    presiona         | cobren |
    #> 6   rechazaron  rechazaron        | rebajar |
    #> 7      levantó     levantó             | NA |
    #> 8  ratificaron ratificaron             | NA |
    #> 9       marchó      marchó | evalúa | llama |
    #> 10     convocó     convocó             | NA |
    #>                                entidades
    #> 1                             | México |
    #> 2  | Larreta | Ciudad | Buenos | Aires |
    #> 3                                 | NA |
    #> 4                             | Chubut |
    #> 5                                | CGT |
    #> 6                          | CTA | CGT |
    #> 7                            | Tucumán |
    #> 8                                 | NA |
    #> 9                                | CGT |
    #> 10                             | Ctera |
    #>                                                    sust_pred
    #> 1           ciudades | México | cambio | política | Gobierno
    #> 2  paro | presencialidad | Larreta | Ciudad | Buenos | Aires
    #> 3                                          aulas | garantías
    #> 4                                 oferta | gobierno | Chubut
    #> 5                                  empleados | indemnización
    #> 6                                   acuerdo | CGT | salarios
    #> 7                                             paro | Tucumán
    #> 8                                                       paro
    #> 9                                 críticas | economía | paro
    #> 10                                       paro | horas | país

### acep_lista_lemmas

Este marco de datos es un análisis de frecuencias absolutas de lemmas
presentes en el corpus procesado.

``` r
head(titulares_svo$acep_lista_lemmas, n=10)
```

    #>       lemma n
    #> 45     paro 5
    #> 7       CGT 3
    #> 28   gremio 3
    #> 52 rechazar 3
    #> 9    ciudad 2
    #> 13 convocar 2
    #> 18  docente 2
    #> 27 gobierno 2
    #> 38  marchar 2
    #> 1   acuerdo 1

### acep_no_procesadas

Este marco de datos contiene las oraciones que no pudieron ser
procesadas por no ser posible identificar sujeto y predicado.

``` r
head(titulares_svo$acep_no_procesadas, n=10)
```

    #> Key: <doc_id, oracion_id>
    #>    doc_id oracion_id                                                 oracion
    #>     <int>      <int>                                                  <char>
    #> 1:      8          1 Conciliación obligatoria en el conflicto del neumático.
    #> 2:      9          1                                             Hola mundo.

## Nota final

Los resultados obtenidos en este ejemplo son muy prometedores, pero la
realidad es que la bondad de los resultados está determinada por la
complejidad de las oraciones. Es verdad que los textos ingresados en
este ejemplo fueron tomados de portales de noticias, pero también es
verdad que no todos los títulos son igual de descriptivos y muchos son
oraciones unimembres. Sin embargo, con los cuidados del caso, los
resultados arrojados por la función
[`acep_svo()`](https://agusnieto77.github.io/ACEP/reference/acep_svo.md)
pueden ser muy útiles para una primera aproximación exploratoria de
eventos de protesta en un corpus extenso de notas.
