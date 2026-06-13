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
    #>  $ texto_tag            :Classes 'tokenIndex', 'data.table' and 'data.frame':    15 obs. of  20 variables:
    #>   ..$ doc_id        : int [1:15] 1 1 1 1 1 1 1 1 1 1 ...
    #>   ..$ sentence      : int [1:15] 1 1 1 1 1 1 1 1 1 1 ...
    #>   ..$ token_id      : num [1:15] 1 2 3 4 5 6 7 8 9 10 ...
    #>   ..$ token         : chr [1:15] "En" "Mar" "del" "Plata" ...
    #>   ..$ lemma         : chr [1:15] "en" "Mar" "del" "Plata" ...
    #>   ..$ pos           : chr [1:15] "ADP" "PROPN" "ADP" "PROPN" ...
    #>   ..$ parent        : num [1:15] 2 7 4 2 6 7 NA 9 7 13 ...
    #>   ..$ relation      : chr [1:15] "case" "obl" "case" "flat" ...
    #>   .. ..- attr(*, "levels")= chr "ROOT"
    #>   ..$ entity        : chr [1:15] "" "LOC_B" "LOC_I" "LOC_I" ...
    #>   ..$ nounphrase    : chr [1:15] "" "beg_root" "mid" "end" ...
    #>   ..$ whitespace    : logi [1:15] TRUE TRUE TRUE TRUE TRUE TRUE ...
    #>   ..$ is_upper      : logi [1:15] FALSE FALSE FALSE FALSE FALSE TRUE ...
    #>   ..$ is_title      : logi [1:15] TRUE TRUE FALSE TRUE FALSE FALSE ...
    #>   ..$ is_quote      : logi [1:15] FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ ent_iob_      : chr [1:15] "O" "B" "I" "I" ...
    #>   ..$ ent_iob       : int [1:15] 2 3 1 1 2 3 2 2 2 2 ...
    #>   ..$ is_left_punct : logi [1:15] FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ is_right_punct: logi [1:15] FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ morph         : chr [1:15] "AdpType=Prep" "" "AdpType=Preppron" "" ...
    #>   ..$ sent          : chr [1:15] "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." ...
    #>   ..- attr(*, ".internal.selfref")=<pointer: (nil)> 
    #>   ..- attr(*, "sorted")= chr [1:3] "doc_id" "sentence" "token_id"
    #>  $ texto_tag_entity     :Classes 'tokenIndex', 'data.table' and 'data.frame':    4 obs. of  20 variables:
    #>   ..$ doc_id        : int [1:4] 1 1 1 1
    #>   ..$ sentence      : int [1:4] 1 1 1 1
    #>   ..$ token_id      : num [1:4] 2 3 4 6
    #>   ..$ token         : chr [1:4] "Mar" "del" "Plata" "SOIP"
    #>   ..$ lemma         : chr [1:4] "Mar" "del" "Plata" "SOIP"
    #>   ..$ pos           : chr [1:4] "PROPN" "ADP" "PROPN" "PROPN"
    #>   ..$ parent        : num [1:4] 7 4 2 7
    #>   ..$ relation      : chr [1:4] "obl" "case" "flat" "nsubj"
    #>   .. ..- attr(*, "levels")= chr "ROOT"
    #>   ..$ entity        : chr [1:4] "LOC_B" "LOC_I" "LOC_I" "ORG_B"
    #>   ..$ nounphrase    : chr [1:4] "beg_root" "mid" "end" "end_root"
    #>   ..$ whitespace    : logi [1:4] TRUE TRUE TRUE TRUE
    #>   ..$ is_upper      : logi [1:4] FALSE FALSE FALSE TRUE
    #>   ..$ is_title      : logi [1:4] TRUE FALSE TRUE FALSE
    #>   ..$ is_quote      : logi [1:4] FALSE FALSE FALSE FALSE
    #>   ..$ ent_iob_      : chr [1:4] "B" "I" "I" "B"
    #>   ..$ ent_iob       : int [1:4] 3 1 1 3
    #>   ..$ is_left_punct : logi [1:4] FALSE FALSE FALSE FALSE
    #>   ..$ is_right_punct: logi [1:4] FALSE FALSE FALSE FALSE
    #>   ..$ morph         : chr [1:4] "" "AdpType=Preppron" "" ""
    #>   ..$ sent          : chr [1:4] "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial."
    #>   ..- attr(*, ".internal.selfref")=<pointer: 0x55a5871e6ee0> 
    #>   ..- attr(*, "sorted")= chr [1:3] "doc_id" "sentence" "token_id"
    #>  $ texto_only_entity    :'data.frame':   4 obs. of  4 variables:
    #>   ..$ entity     : chr [1:4] "Mar" "del" "Plata" "SOIP"
    #>   ..$ entity_type: chr [1:4] "LOC" "LOC" "LOC" "ORG"
    #>   ..$ doc_id     : int [1:4] 1 1 1 1
    #>   ..$ sentence   : int [1:4] 1 1 1 1
    #>  $ texto_only_entity_loc:'data.frame':   1 obs. of  7 variables:
    #>   ..$ entity_    : chr "Mar del Plata"
    #>   ..$ doc_id     : int 1
    #>   ..$ sentence   : int 1
    #>   ..$ entity     : chr "Mar_del_Plata"
    #>   ..$ entity_type: chr "LOC"
    #>   ..$ lat        : num -38
    #>   ..$ long       : num -57.5
    #>  $ texto_nounphrase     :Classes 'tokenIndex', 'data.table' and 'data.frame':    15 obs. of  20 variables:
    #>   ..$ doc_id        : int [1:15] 1 1 1 1 1 1 1 1 1 1 ...
    #>   ..$ sentence      : int [1:15] 1 1 1 1 1 1 1 1 1 1 ...
    #>   ..$ token_id      : num [1:15] 1 2 3 4 5 6 7 8 9 10 ...
    #>   ..$ token         : chr [1:15] "En" "Mar" "del" "Plata" ...
    #>   ..$ lemma         : chr [1:15] "en" "Mar" "del" "Plata" ...
    #>   ..$ pos           : chr [1:15] "ADP" "PROPN" "ADP" "PROPN" ...
    #>   ..$ parent        : num [1:15] 2 7 4 2 6 7 NA 9 7 13 ...
    #>   ..$ relation      : chr [1:15] "case" "obl" "case" "flat" ...
    #>   .. ..- attr(*, "levels")= chr "ROOT"
    #>   ..$ entity        : chr [1:15] "" "LOC_B" "LOC_I" "LOC_I" ...
    #>   ..$ nounphrase    : chr [1:15] "" "beg_root" "mid" "end" ...
    #>   ..$ whitespace    : logi [1:15] TRUE TRUE TRUE TRUE TRUE TRUE ...
    #>   ..$ is_upper      : logi [1:15] FALSE FALSE FALSE FALSE FALSE TRUE ...
    #>   ..$ is_title      : logi [1:15] TRUE TRUE FALSE TRUE FALSE FALSE ...
    #>   ..$ is_quote      : logi [1:15] FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ ent_iob_      : chr [1:15] "O" "B" "I" "I" ...
    #>   ..$ ent_iob       : int [1:15] 2 3 1 1 2 3 2 2 2 2 ...
    #>   ..$ is_left_punct : logi [1:15] FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ is_right_punct: logi [1:15] FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ morph         : chr [1:15] "AdpType=Prep" "" "AdpType=Preppron" "" ...
    #>   ..$ sent          : chr [1:15] "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." ...
    #>   ..- attr(*, ".internal.selfref")=<pointer: (nil)> 
    #>   ..- attr(*, "sorted")= chr [1:3] "doc_id" "sentence" "token_id"
    #>  $ texto_only_nounphrase:Classes 'tokenIndex', 'data.table' and 'data.frame':    9 obs. of  20 variables:
    #>   ..$ doc_id        : int [1:9] 1 1 1 1 1 1 1 1 1
    #>   ..$ sentence      : int [1:9] 1 1 1 1 1 1 1 1 1
    #>   ..$ token_id      : num [1:9] 2 3 4 5 6 8 9 11 13
    #>   ..$ token         : chr [1:9] "Mar" "del" "Plata" "el" ...
    #>   ..$ lemma         : chr [1:9] "Mar" "del" "Plata" "el" ...
    #>   ..$ pos           : chr [1:9] "PROPN" "ADP" "PROPN" "DET" ...
    #>   ..$ parent        : num [1:9] 7 4 2 6 7 9 7 10 9
    #>   ..$ relation      : chr [1:9] "obl" "case" "flat" "det" ...
    #>   .. ..- attr(*, "levels")= chr "ROOT"
    #>   ..$ entity        : chr [1:9] "LOC_B" "LOC_I" "LOC_I" "" ...
    #>   ..$ nounphrase    : chr [1:9] "beg_root" "mid" "end" "beg" ...
    #>   ..$ whitespace    : logi [1:9] TRUE TRUE TRUE TRUE TRUE TRUE ...
    #>   ..$ is_upper      : logi [1:9] FALSE FALSE FALSE FALSE TRUE FALSE ...
    #>   ..$ is_title      : logi [1:9] TRUE FALSE TRUE FALSE FALSE FALSE ...
    #>   ..$ is_quote      : logi [1:9] FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ ent_iob_      : chr [1:9] "B" "I" "I" "O" ...
    #>   ..$ ent_iob       : int [1:9] 3 1 1 2 3 2 2 2 2
    #>   ..$ is_left_punct : logi [1:9] FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ is_right_punct: logi [1:9] FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ morph         : chr [1:9] "" "AdpType=Preppron" "" "Definite=Def|Gender=Masc|Number=Sing|PronType=Art" ...
    #>   ..$ sent          : chr [1:9] "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." ...
    #>   ..- attr(*, ".internal.selfref")=<pointer: 0x55a5871e6ee0> 
    #>   ..- attr(*, "sorted")= chr [1:3] "doc_id" "sentence" "token_id"

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

head(titulares_tags$texto_tag, n = 12)
```

    #> Key: <doc_id, sentence, token_id>
    #>     doc_id sentence token_id   token    lemma    pos parent relation entity
    #>      <int>    <int>    <num>  <char>   <char> <char>  <num>   <char> <char>
    #>  1:      1        1        1      En       en    ADP      2     case       
    #>  2:      1        1        2     Mar      Mar  PROPN      7      obl  LOC_B
    #>  3:      1        1        3     del      del    ADP      4     case  LOC_I
    #>  4:      1        1        4   Plata    Plata  PROPN      2     flat  LOC_I
    #>  5:      1        1        5      el       el    DET      6      det       
    #>  6:      1        1        6    SOIP     SOIP  PROPN      7    nsubj  ORG_B
    #>  7:      1        1        7 declara declarar   VERB     NA     ROOT       
    #>  8:      1        1        8      la       el    DET      9      det       
    #>  9:      1        1        9  huelga   huelga   NOUN      7      obj       
    #> 10:      1        1       10      en       en    ADP     13     case       
    #> 11:      1        1       11 demanda  demanda   NOUN     10    fixed       
    #> 12:      1        1       12      de       de    ADP     10    fixed       
    #>     nounphrase whitespace is_upper is_title is_quote ent_iob_ ent_iob
    #>         <char>     <lgcl>   <lgcl>   <lgcl>   <lgcl>   <char>   <int>
    #>  1:                  TRUE    FALSE     TRUE    FALSE        O       2
    #>  2:   beg_root       TRUE    FALSE     TRUE    FALSE        B       3
    #>  3:        mid       TRUE    FALSE    FALSE    FALSE        I       1
    #>  4:        end       TRUE    FALSE     TRUE    FALSE        I       1
    #>  5:        beg       TRUE    FALSE    FALSE    FALSE        O       2
    #>  6:   end_root       TRUE     TRUE    FALSE    FALSE        B       3
    #>  7:                  TRUE    FALSE    FALSE    FALSE        O       2
    #>  8:        beg       TRUE    FALSE    FALSE    FALSE        O       2
    #>  9:   end_root       TRUE    FALSE    FALSE    FALSE        O       2
    #> 10:                  TRUE    FALSE    FALSE    FALSE        O       2
    #> 11:   beg_root       TRUE    FALSE    FALSE    FALSE        O       2
    #> 12:                  TRUE    FALSE    FALSE    FALSE        O       2
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
    #>  1:                                          AdpType=Prep
    #>  2:                                                      
    #>  3:                                      AdpType=Preppron
    #>  4:                                                      
    #>  5:     Definite=Def|Gender=Masc|Number=Sing|PronType=Art
    #>  6:                                                      
    #>  7: Mood=Ind|Number=Sing|Person=3|Tense=Pres|VerbForm=Fin
    #>  8:      Definite=Def|Gender=Fem|Number=Sing|PronType=Art
    #>  9:                                Gender=Fem|Number=Sing
    #> 10:                                          AdpType=Prep
    #> 11:                                                      
    #> 12:                                          AdpType=Prep
    #>                                                                           sent
    #>                                                                         <char>
    #>  1: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>  2: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>  3: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>  4: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>  5: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>  6: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>  7: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>  8: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>  9: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 10: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 11: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 12: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.

### texto_tag_entity

El segundo objeto de la lista es un marco de datos que reescribe la
columna ‘pos’ con la etiqueta ‘ENTITY’ e identifica el tipo de entidad
en la columna ‘entity_type’. Si la entidad detectada está compuesta por
más de un token, la función colapsa todos los tokens referidos a esa
entidad en una sola celda de la columna token. Ejemplo:
‘Ciudad_de_Buenos_Aires’.

``` r

head(titulares_tags$texto_tag_entity, n = 14)
```

    #> Key: <doc_id, sentence, token_id>
    #>    doc_id sentence token_id  token  lemma    pos parent relation entity
    #>     <int>    <int>    <num> <char> <char> <char>  <num>   <char> <char>
    #> 1:      1        1        2    Mar    Mar  PROPN      7      obl  LOC_B
    #> 2:      1        1        3    del    del    ADP      4     case  LOC_I
    #> 3:      1        1        4  Plata  Plata  PROPN      2     flat  LOC_I
    #> 4:      1        1        6   SOIP   SOIP  PROPN      7    nsubj  ORG_B
    #>    nounphrase whitespace is_upper is_title is_quote ent_iob_ ent_iob
    #>        <char>     <lgcl>   <lgcl>   <lgcl>   <lgcl>   <char>   <int>
    #> 1:   beg_root       TRUE    FALSE     TRUE    FALSE        B       3
    #> 2:        mid       TRUE    FALSE    FALSE    FALSE        I       1
    #> 3:        end       TRUE    FALSE     TRUE    FALSE        I       1
    #> 4:   end_root       TRUE     TRUE    FALSE    FALSE        B       3
    #>    is_left_punct is_right_punct            morph
    #>           <lgcl>         <lgcl>           <char>
    #> 1:         FALSE          FALSE                 
    #> 2:         FALSE          FALSE AdpType=Preppron
    #> 3:         FALSE          FALSE                 
    #> 4:         FALSE          FALSE                 
    #>                                                                          sent
    #>                                                                        <char>
    #> 1: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 2: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 3: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 4: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.

### texto_only_entity

El tercer objeto de la lista es el marco de datos ‘texto_tag_entity’
filtrado por el valor ‘ENTITY’ de la columna ‘pos’.

``` r

head(titulares_tags$texto_only_entity, n = 10)
```

    #>   entity entity_type doc_id sentence
    #> 1    Mar         LOC      1        1
    #> 2    del         LOC      1        1
    #> 3  Plata         LOC      1        1
    #> 4   SOIP         ORG      1        1

### texto_only_entity_loc

El cuarto objeto de la lista es el marco de datos ‘texto_only_entity’
filtrado por el valor ‘LOC’ de la columna ‘entity_type’ y procesado con
la función ‘geo()’ del paquete *tidygeocoder*.

``` r

head(titulares_tags$texto_only_entity_loc[ , c(1:3, 6:7)], n = 4)
```

    #>         entity_ doc_id sentence      lat     long
    #> 1 Mar del Plata      1        1 -38.0055 -57.5426

### texto_nounphrase

El quinto objeto de la lista es un marco de datos que reescribe la
columna ‘pos’ con la etiqueta ‘nounphrase’. Si el sustantivo detectado
está compuesto por más de un token, la función colapsa todos los tokens
referidos a ese sustantivo en una sola celda de la columna token.
Ejemplo: ‘las_principales_ciudades’.

``` r

head(titulares_tags$texto_nounphrase[ , c(1:2, 4, 6)], n = 10)
```

    #> Key: <doc_id, sentence>
    #>     doc_id sentence   token    pos
    #>      <int>    <int>  <char> <char>
    #>  1:      1        1      En    ADP
    #>  2:      1        1     Mar  PROPN
    #>  3:      1        1     del    ADP
    #>  4:      1        1   Plata  PROPN
    #>  5:      1        1      el    DET
    #>  6:      1        1    SOIP  PROPN
    #>  7:      1        1 declara   VERB
    #>  8:      1        1      la    DET
    #>  9:      1        1  huelga   NOUN
    #> 10:      1        1      en    ADP

### texto_only_nounphrase

El sexto objeto de la lista es el marco de datos ‘texto_nounphrase’
filtrado por el valor ‘nounphrase’ de la columna ‘pos’.

``` r

head(titulares_tags$texto_only_nounphrase, n = 10)
```

    #> Key: <doc_id, sentence, token_id>
    #>    doc_id sentence token_id   token   lemma    pos parent relation entity
    #>     <int>    <int>    <num>  <char>  <char> <char>  <num>   <char> <char>
    #> 1:      1        1        2     Mar     Mar  PROPN      7      obl  LOC_B
    #> 2:      1        1        3     del     del    ADP      4     case  LOC_I
    #> 3:      1        1        4   Plata   Plata  PROPN      2     flat  LOC_I
    #> 4:      1        1        5      el      el    DET      6      det       
    #> 5:      1        1        6    SOIP    SOIP  PROPN      7    nsubj  ORG_B
    #> 6:      1        1        8      la      el    DET      9      det       
    #> 7:      1        1        9  huelga  huelga   NOUN      7      obj       
    #> 8:      1        1       11 demanda demanda   NOUN     10    fixed       
    #> 9:      1        1       13 aumento aumento   NOUN      9     nmod       
    #>    nounphrase whitespace is_upper is_title is_quote ent_iob_ ent_iob
    #>        <char>     <lgcl>   <lgcl>   <lgcl>   <lgcl>   <char>   <int>
    #> 1:   beg_root       TRUE    FALSE     TRUE    FALSE        B       3
    #> 2:        mid       TRUE    FALSE    FALSE    FALSE        I       1
    #> 3:        end       TRUE    FALSE     TRUE    FALSE        I       1
    #> 4:        beg       TRUE    FALSE    FALSE    FALSE        O       2
    #> 5:   end_root       TRUE     TRUE    FALSE    FALSE        B       3
    #> 6:        beg       TRUE    FALSE    FALSE    FALSE        O       2
    #> 7:   end_root       TRUE    FALSE    FALSE    FALSE        O       2
    #> 8:   beg_root       TRUE    FALSE    FALSE    FALSE        O       2
    #> 9:   beg_root       TRUE    FALSE    FALSE    FALSE        O       2
    #>    is_left_punct is_right_punct
    #>           <lgcl>         <lgcl>
    #> 1:         FALSE          FALSE
    #> 2:         FALSE          FALSE
    #> 3:         FALSE          FALSE
    #> 4:         FALSE          FALSE
    #> 5:         FALSE          FALSE
    #> 6:         FALSE          FALSE
    #> 7:         FALSE          FALSE
    #> 8:         FALSE          FALSE
    #> 9:         FALSE          FALSE
    #>                                                morph
    #>                                               <char>
    #> 1:                                                  
    #> 2:                                  AdpType=Preppron
    #> 3:                                                  
    #> 4: Definite=Def|Gender=Masc|Number=Sing|PronType=Art
    #> 5:                                                  
    #> 6:  Definite=Def|Gender=Fem|Number=Sing|PronType=Art
    #> 7:                            Gender=Fem|Number=Sing
    #> 8:                                                  
    #> 9:                           Gender=Masc|Number=Sing
    #>                                                                          sent
    #>                                                                        <char>
    #> 1: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 2: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 3: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 4: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 5: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 6: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 7: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 8: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 9: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.

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

    #> Classes 'tokenIndex', 'data.table' and 'data.frame': 15 obs. of  20 variables:
    #>  $ doc_id        : int  1 1 1 1 1 1 1 1 1 1 ...
    #>  $ sentence      : int  1 1 1 1 1 1 1 1 1 1 ...
    #>  $ token_id      : num  1 2 3 4 5 6 7 8 9 10 ...
    #>  $ token         : chr  "En" "Mar" "del" "Plata" ...
    #>  $ lemma         : chr  "en" "Mar" "del" "Plata" ...
    #>  $ pos           : chr  "ADP" "PROPN" "ADP" "PROPN" ...
    #>  $ parent        : num  2 7 4 2 6 7 NA 9 7 13 ...
    #>  $ relation      : chr  "case" "obl" "case" "flat" ...
    #>   ..- attr(*, "levels")= chr "ROOT"
    #>  $ entity        : chr  "" "LOC_B" "LOC_I" "LOC_I" ...
    #>  $ nounphrase    : chr  "" "beg_root" "mid" "end" ...
    #>  $ whitespace    : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
    #>  $ is_upper      : logi  FALSE FALSE FALSE FALSE FALSE TRUE ...
    #>  $ is_title      : logi  TRUE TRUE FALSE TRUE FALSE FALSE ...
    #>  $ is_quote      : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>  $ ent_iob_      : chr  "O" "B" "I" "I" ...
    #>  $ ent_iob       : int  2 3 1 1 2 3 2 2 2 2 ...
    #>  $ is_left_punct : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>  $ is_right_punct: logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>  $ morph         : chr  "AdpType=Prep" "" "AdpType=Preppron" "" ...
    #>  $ sent          : chr  "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." ...
    #>  - attr(*, ".internal.selfref")=<pointer: (nil)> 
    #>  - attr(*, "sorted")= chr [1:3] "doc_id" "sentence" "token_id"

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
    #>  $ acep_annotate_svo :Classes 'tokenIndex', 'data.table' and 'data.frame':   15 obs. of  25 variables:
    #>   ..$ doc_id        : int [1:15] 1 1 1 1 1 1 1 1 1 1 ...
    #>   ..$ sentence      : int [1:15] 1 1 1 1 1 1 1 1 1 1 ...
    #>   ..$ token_id      : num [1:15] 1 2 3 4 5 6 7 8 9 10 ...
    #>   ..$ token         : chr [1:15] "En" "Mar" "del" "Plata" ...
    #>   ..$ lemma         : chr [1:15] "en" "Mar" "del" "Plata" ...
    #>   ..$ pos           : chr [1:15] "ADP" "PROPN" "ADP" "PROPN" ...
    #>   ..$ parent        : num [1:15] 2 7 4 2 6 7 NA 9 7 13 ...
    #>   ..$ relation      : chr [1:15] "case" "obl" "case" "flat" ...
    #>   .. ..- attr(*, "levels")= chr "ROOT"
    #>   ..$ entity        : chr [1:15] "" "LOC_B" "LOC_I" "LOC_I" ...
    #>   ..$ nounphrase    : chr [1:15] "" "beg_root" "mid" "end" ...
    #>   ..$ whitespace    : logi [1:15] TRUE TRUE TRUE TRUE TRUE TRUE ...
    #>   ..$ is_upper      : logi [1:15] FALSE FALSE FALSE FALSE FALSE TRUE ...
    #>   ..$ is_title      : logi [1:15] TRUE TRUE FALSE TRUE FALSE FALSE ...
    #>   ..$ is_quote      : logi [1:15] FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ ent_iob_      : chr [1:15] "O" "B" "I" "I" ...
    #>   ..$ ent_iob       : int [1:15] 2 3 1 1 2 3 2 2 2 2 ...
    #>   ..$ is_left_punct : logi [1:15] FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ is_right_punct: logi [1:15] FALSE FALSE FALSE FALSE FALSE FALSE ...
    #>   ..$ morph         : chr [1:15] "AdpType=Prep" "" "AdpType=Preppron" "" ...
    #>   ..$ sent          : chr [1:15] "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." "En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial." ...
    #>   ..$ s_v_o         : Factor w/ 3 levels "objeto","sujeto",..: NA 1 NA 1 NA 2 3 NA 1 NA ...
    #>   ..$ s_v_o_id      : Factor w/ 1 level "1.1.7": NA 1 NA 1 NA 1 1 NA 1 NA ...
    #>   ..$ s_v_o_fill    : num [1:15] NA 0 NA 1 NA 0 0 NA 0 NA ...
    #>   ..$ s_p           : chr [1:15] "sujeto" "sujeto" "sujeto" "sujeto" ...
    #>   ..$ conjugaciones : chr [1:15] NA NA NA NA ...
    #>   ..- attr(*, ".internal.selfref")=<pointer: 0x55a5871e6ee0> 
    #>   ..- attr(*, "sorted")= chr [1:3] "doc_id" "sentence" "token_id"
    #>  $ acep_pro_svo      :'data.frame':  1 obs. of  13 variables:
    #>   ..$ doc_id    : int 1
    #>   ..$ oracion_id: int 1
    #>   ..$ eventos   : chr "SOIP -> declara -> Mar huelga"
    #>   ..$ sujeto_svo: chr "SOIP"
    #>   ..$ root      : chr "declara"
    #>   ..$ objeto    : chr "Mar huelga"
    #>   ..$ sujeto    : chr "Mar Plata SOIP"
    #>   ..$ predicado : chr "declara huelga demanda aumento salarial"
    #>   ..$ verbo     : chr "declara"
    #>   ..$ lemma_verb: chr "declara"
    #>   ..$ aux_verbos: chr "| NA |"
    #>   ..$ entidades : chr "| Mar | Plata | SOIP |"
    #>   ..$ sust_pred : chr "huelga | demanda | aumento"
    #>  $ acep_list_svo     :'data.frame':  1 obs. of  6 variables:
    #>   ..$ doc_id    : int 1
    #>   ..$ oracion_id: int 1
    #>   ..$ eventos   : chr "SOIP -> declara -> Mar huelga"
    #>   ..$ sujeto    : chr "SOIP"
    #>   ..$ verbo     : chr "declara"
    #>   ..$ objeto    : chr "Mar huelga"
    #>  $ acep_sp           :'data.frame':  1 obs. of  9 variables:
    #>   ..$ doc_id    : int 1
    #>   ..$ oracion_id: int 1
    #>   ..$ sujeto    : chr "Mar Plata SOIP"
    #>   ..$ predicado : chr "declara huelga demanda aumento salarial"
    #>   ..$ verbo     : chr "declara"
    #>   ..$ lemma_verb: chr "declara"
    #>   ..$ aux_verbos: chr "| NA |"
    #>   ..$ entidades : chr "| Mar | Plata | SOIP |"
    #>   ..$ sust_pred : chr "huelga | demanda | aumento"
    #>  $ acep_lista_lemmas :'data.frame':  8 obs. of  2 variables:
    #>   ..$ lemma: Factor w/ 8 levels "aumento","declarar",..: 1 2 3 4 5 6 7 8
    #>   ..$ n    : int [1:8] 1 1 1 1 1 1 1 1
    #>  $ acep_no_procesadas:Classes 'tokenIndex', 'data.table' and 'data.frame':   0 obs. of  3 variables:
    #>   ..$ doc_id    : int(0) 
    #>   ..$ oracion_id: int(0) 
    #>   ..$ oracion   : chr(0) 
    #>   ..- attr(*, ".internal.selfref")=<pointer: 0x55a5871e6ee0>

Veamos con un poco más de detalle cada uno de los marcos de datos
creados con la función
[`acep_svo()`](https://agusnieto77.github.io/ACEP/reference/acep_svo.md).

### acep_annotate_svo

Es el marco de datos inicial procesado con las funciones del paquete
*rsyntax*.

``` r

head(titulares_svo$acep_annotate_svo, n=20)
```

    #> Key: <doc_id, sentence, token_id>
    #>     doc_id sentence token_id    token    lemma    pos parent relation entity
    #>      <int>    <int>    <num>   <char>   <char> <char>  <num>   <char> <char>
    #>  1:      1        1        1       En       en    ADP      2     case       
    #>  2:      1        1        2      Mar      Mar  PROPN      7      obl  LOC_B
    #>  3:      1        1        3      del      del    ADP      4     case  LOC_I
    #>  4:      1        1        4    Plata    Plata  PROPN      2     flat  LOC_I
    #>  5:      1        1        5       el       el    DET      6      det       
    #>  6:      1        1        6     SOIP     SOIP  PROPN      7    nsubj  ORG_B
    #>  7:      1        1        7  declara declarar   VERB     NA     ROOT       
    #>  8:      1        1        8       la       el    DET      9      det       
    #>  9:      1        1        9   huelga   huelga   NOUN      7      obj       
    #> 10:      1        1       10       en       en    ADP     13     case       
    #> 11:      1        1       11  demanda  demanda   NOUN     10    fixed       
    #> 12:      1        1       12       de       de    ADP     10    fixed       
    #> 13:      1        1       13  aumento  aumento   NOUN      9     nmod       
    #> 14:      1        1       14 salarial salarial    ADJ     13     amod       
    #> 15:      1        1       15        .        .  PUNCT      7    punct       
    #>     nounphrase whitespace is_upper is_title is_quote ent_iob_ ent_iob
    #>         <char>     <lgcl>   <lgcl>   <lgcl>   <lgcl>   <char>   <int>
    #>  1:                  TRUE    FALSE     TRUE    FALSE        O       2
    #>  2:   beg_root       TRUE    FALSE     TRUE    FALSE        B       3
    #>  3:        mid       TRUE    FALSE    FALSE    FALSE        I       1
    #>  4:        end       TRUE    FALSE     TRUE    FALSE        I       1
    #>  5:        beg       TRUE    FALSE    FALSE    FALSE        O       2
    #>  6:   end_root       TRUE     TRUE    FALSE    FALSE        B       3
    #>  7:                  TRUE    FALSE    FALSE    FALSE        O       2
    #>  8:        beg       TRUE    FALSE    FALSE    FALSE        O       2
    #>  9:   end_root       TRUE    FALSE    FALSE    FALSE        O       2
    #> 10:                  TRUE    FALSE    FALSE    FALSE        O       2
    #> 11:   beg_root       TRUE    FALSE    FALSE    FALSE        O       2
    #> 12:                  TRUE    FALSE    FALSE    FALSE        O       2
    #> 13:   beg_root       TRUE    FALSE    FALSE    FALSE        O       2
    #> 14:                 FALSE    FALSE    FALSE    FALSE        O       2
    #> 15:                 FALSE    FALSE    FALSE    FALSE        O       2
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
    #> 13:         FALSE          FALSE
    #> 14:         FALSE          FALSE
    #> 15:         FALSE          FALSE
    #>                                                     morph
    #>                                                    <char>
    #>  1:                                          AdpType=Prep
    #>  2:                                                      
    #>  3:                                      AdpType=Preppron
    #>  4:                                                      
    #>  5:     Definite=Def|Gender=Masc|Number=Sing|PronType=Art
    #>  6:                                                      
    #>  7: Mood=Ind|Number=Sing|Person=3|Tense=Pres|VerbForm=Fin
    #>  8:      Definite=Def|Gender=Fem|Number=Sing|PronType=Art
    #>  9:                                Gender=Fem|Number=Sing
    #> 10:                                          AdpType=Prep
    #> 11:                                                      
    #> 12:                                          AdpType=Prep
    #> 13:                               Gender=Masc|Number=Sing
    #> 14:                                           Number=Sing
    #> 15:                                        PunctType=Peri
    #>                                                                           sent
    #>                                                                         <char>
    #>  1: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>  2: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>  3: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>  4: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>  5: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>  6: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>  7: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>  8: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>  9: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 10: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 11: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 12: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 13: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 14: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #> 15: En Mar del Plata el SOIP declara la huelga en demanda de aumento salarial.
    #>      s_v_o s_v_o_id s_v_o_fill       s_p conjugaciones
    #>     <fctr>   <fctr>      <num>    <char>        <char>
    #>  1:   <NA>     <NA>         NA    sujeto          <NA>
    #>  2: objeto    1.1.7          0    sujeto          <NA>
    #>  3:   <NA>     <NA>         NA    sujeto          <NA>
    #>  4: objeto    1.1.7          1    sujeto          <NA>
    #>  5:   <NA>     <NA>         NA    sujeto          <NA>
    #>  6: sujeto    1.1.7          0    sujeto          <NA>
    #>  7:  verbo    1.1.7          0 predicado      presente
    #>  8:   <NA>     <NA>         NA predicado          <NA>
    #>  9: objeto    1.1.7          0 predicado          <NA>
    #> 10:   <NA>     <NA>         NA predicado          <NA>
    #> 11: objeto    1.1.7          3 predicado          <NA>
    #> 12: objeto    1.1.7          3 predicado          <NA>
    #> 13: objeto    1.1.7          1 predicado          <NA>
    #> 14: objeto    1.1.7          2 predicado          <NA>
    #> 15:   <NA>     <NA>         NA predicado          <NA>

### acep_annotate_svo

Este marco de datos contiene las oraciones procesables con la
identificación y extracción de sujeto-verbo-objeto y contexto.

``` r

head(titulares_svo$acep_pro_svo, n=10)
```

    #>   doc_id oracion_id                       eventos sujeto_svo    root     objeto
    #> 1      1          1 SOIP -> declara -> Mar huelga       SOIP declara Mar huelga
    #>           sujeto                               predicado   verbo lemma_verb
    #> 1 Mar Plata SOIP declara huelga demanda aumento salarial declara    declara
    #>   aux_verbos              entidades                  sust_pred
    #> 1     | NA | | Mar | Plata | SOIP | huelga | demanda | aumento

### acep_list_svo

Este marco de datos es una versión reducida del data.frame
‘acep_pro_svo’. Solo contiene los tripletes sujeto-verbo-objeto en
versión colapsada (‘gremios -\> convocan -\> paro’) y en versión
separada (una columna para ‘sujeto’, otra para ‘verbo’ y otra para
‘objeto’).

``` r

head(titulares_svo$acep_list_svo, n=10)
```

    #>   doc_id oracion_id                       eventos sujeto   verbo     objeto
    #> 1      1          1 SOIP -> declara -> Mar huelga   SOIP declara Mar huelga

### acep_sp

Este marco de datos contiene los ‘sujetos’ y los ‘predicados’
identificados en cada oración y una aproximación a ‘entidades’,
‘sustantivos’ y ‘verbos auxiliares’ como contexto que ayuda a mejorar la
extracción de sujetos y objetos de la acción.

``` r

head(titulares_svo$acep_sp, n=10)
```

    #>   doc_id oracion_id         sujeto                               predicado
    #> 1      1          1 Mar Plata SOIP declara huelga demanda aumento salarial
    #>     verbo lemma_verb aux_verbos              entidades
    #> 1 declara    declara     | NA | | Mar | Plata | SOIP |
    #>                    sust_pred
    #> 1 huelga | demanda | aumento

### acep_lista_lemmas

Este marco de datos es un análisis de frecuencias absolutas de lemmas
presentes en el corpus procesado.

``` r

head(titulares_svo$acep_lista_lemmas, n=10)
```

    #>      lemma n
    #> 1  aumento 1
    #> 2 declarar 1
    #> 3  demanda 1
    #> 4   huelga 1
    #> 5      Mar 1
    #> 6    Plata 1
    #> 7 salarial 1
    #> 8     SOIP 1

### acep_no_procesadas

Este marco de datos contiene las oraciones que no pudieron ser
procesadas por no ser posible identificar sujeto y predicado.

``` r

head(titulares_svo$acep_no_procesadas, n=10)
```

    #> Empty data.table (0 rows and 3 cols): doc_id,oracion_id,oracion

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
