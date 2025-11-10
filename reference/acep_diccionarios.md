# Colección de diccionarios.

Colección de diccionarios que reúne diccionarios de diferentes orígenes.
El diccionario dicc_confl_acep fueron construidos en el marco del
Observatorio de Conflictividad de la UNMdP. Los diccionarios
dicc_confl_gp y dicc_viol_gp fueron extraídos de Albrieu y Palazzo
(2020).

## Usage

``` r
data(acep_diccionarios)
```

## Format

Es un objeto de clase 'list' con 3 componentes.

- dicc_confl_gp:

  es un vector con palabras de un diccionario de términos que refieren a
  conflictos

- dicc_viol_gp:

  es un vector con palabras de un diccionario de términos que refieren a
  violencia

- dicc_confl_sismos:

  es un vector con palabras de un diccionario de términos que refieren a
  conflictos

## Source

[Revista Puerto](https://revistapuerto.com.ar/)

[La Nueva](https://www.lanueva.com/)

## References

Albrieu, Ramiro y Gabriel Palazzo 2020 «Categorización de conflictos
sociales en el ámbito de los recursos naturales: un estudio de las
actividades extractivas mediante la minería de textos». Revista CEPAL
(131):29-59. ([Revista
CEPAL](https://observatoriodeconflictividad.org/RVE131_AP.pdf))

Laitano, Guillermina y Agustín Nieto «Análisis computacional de la
conflictividad laboral en Mar del Plata durante el gobierno de
Cambiemos». Ponencia presentado en VI Workshop - Los conflictos
laborales en la Argentina del siglo XX y XXI: un abordaje
interdisciplinario de conceptos, problemas y escalas de análisis,
Tandil, 2021.

## Examples

``` r
diccionario <- acep_load_base(acep_diccionarios$dicc_viol_gp)
#> Descargando...
diccionario
#>   [1] "agresivo"         "combativo"        "provocador"      
#>   [4] "violento"         "agresividad"      "belicosidad"     
#>   [7] "combatividad"     "provocación"      "emboscada"       
#>  [10] "celada"           "trampa"           "asechanza"       
#>  [13] "artería"          "artimaña"         "emboscar"        
#>  [16] "trampear"         "asechar"          "armas"           
#>  [19] "armamento"        "armado"           "asaltar"         
#>  [22] "atracar"          "robar"            "agredir"         
#>  [25] "acometer"         "irrumpir"         "invadir"         
#>  [28] "ataque"           "embate"           "irrupción"       
#>  [31] "combate"          "lucha"            "agresión"        
#>  [34] "golpear"          "golpe"            "sanguinario"     
#>  [37] "choque"           "asalto"           "atropello"       
#>  [40] "atentado"         "coletazo"         "bomba"           
#>  [43] "explosivo"        "granada"          "munición"        
#>  [46] "bala"             "brutalidad"       "bestialidad"     
#>  [49] "ferocidad"        "crueldad"         "atrocidad"       
#>  [52] "monstruosidad"    "irracionalidad"   "vandalismo"      
#>  [55] "salvajada"        "grosería"         "masacre"         
#>  [58] "matanza"          "mortandad"        "hecatombe"       
#>  [61] "catástrofe"       "degollina"        "aplastar"        
#>  [64] "triturar"         "reventar"         "destripar"       
#>  [67] "moler"            "aplastamiento"    "mortal"          
#>  [70] "mortífero"        "letal"            "fatídico"        
#>  [73] "fatal"            "funesto"          "disparar"        
#>  [76] "tirotear"         "ametrallar"       "despedir"        
#>  [79] "expulsar"         "destituir"        "guerrilla"       
#>  [82] "guerrillero"      "milicia"          "arma"            
#>  [85] "pistola"          "revólver"         "pistolete"       
#>  [88] "ametralladora"    "metralleta"       "pistolero"       
#>  [91] "atracador"        "bandido"          "forajido"        
#>  [94] "delincuente"      "gánster"          "terrorista"      
#>  [97] "asesino"          "matar"            "asesinar"        
#> [100] "ahorcar"          "ahogar"           "decapitar"       
#> [103] "desnucar"         "degollar"         "fusilar"         
#> [106] "guillotinar"      "asfixiar"         "electrocutar"    
#> [109] "envenenar"        "linchar"          "asesinato"       
#> [112] "crimen"           "homicidio"        "delito"          
#> [115] "muerte"           "parricidio"       "fratricidio"     
#> [118] "magnicidio"       "regicidio"        "criminal"        
#> [121] "homicida"         "monstruo"         "engendro"        
#> [124] "deforme"          "monstruosa"       "rebelarse"       
#> [127] "incitar"          "sublevarse"       "insubordinarse"  
#> [130] "levantarse"       "alzarse"          "amotinarse"      
#> [133] "insurreccionarse" "rebelión"         "levantamiento"   
#> [136] "revuelta"         "alzamiento"       "revolución"      
#> [139] "subversión"       "conspiración"     "conjuración"     
#> [142] "sedición"         "insurrección"     "motín"           
#> [145] "acuchillar"       "apuñalar"         "lesionar"        
#> [148] "violencia"        "exabrupto"        "coacción"        
#> [151] "profanación"      "furia"            "ensañamiento"    
#> [154] "violación"        "implacable"       "furioso"         
#> [157] "guerrero"         "soldado"          "militar"         
#> [160] "látigo"           "azote"            "fusta"           
#> [163] "tralla"           "vergajo"          "flagelo"         
#> [166] "zurriago"         "latigazos"        "azotando"        
#> [169] "litigar"          "azotar"           "fustigar"        
#> [172] "flagelar"        
```
