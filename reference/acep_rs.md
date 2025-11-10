# Cadenas de caracteres para limpiar y normalizar textos.

Cadenas de caracteres y expresiones regulares para limpiar y normalizar
textos.

## Usage

``` r
data(acep_rs)
```

## Format

Son cadenas de caracteres.

- sw1:

  es un string de palabras vacias.

- sw1:

  es un string de palabras vacias.

- dias:

  es un string de dias.

- meses:

  es un string de meses.

- emoji:

  es un string con expresiones regulares para emojis.

- sintildes:

  es un string de letras sin tildes.

- tildes:

  es un string de letras con tildes.

- punt:

  es un string de puntuación.

- num:

  es una expresión regular para números.

- hashtag:

  es una expresión regular para hashtag.

- espacios:

  es una expresión regular para espacios.

- saltos:

  es una expresión regular para saltos de línea.

- url:

  es una expresión regular para urls.

- users:

  es una expresión regular para usuarixs.

## Examples

``` r
print(acep_rs)
#> $sintildes
#> [1] "SZszYAAAAAACEEEEIIIIDNOOOOOUUUUYaaaaaaceeeeiiiidnooooouuuuyy"
#> 
#> $url
#> [1] "http\\S+|ftp\\S+|Http\\S+|Ftp\\S+|HTTP\\S+|FTP\\S+"
#> 
#> $users
#> [1] "@\\S+"
#> 
#> $saltos
#> [1] "[ \t\r\n]"
#> 
#> $espacios
#> [1] "^ *|(?<= ) | *$"
#> 
#> $hashtag
#> [1] "#\\S+"
#> 
#> $num
#> [1] "[[:digit:]]*"
#> 
#> $sw1
#> [1] "\\bde\\b|\\bla\\b|\\bque\\b|\\bel\\b|\\ben\\b|\\by\\b|\\ba\\b|\\blos\\b|\\bdel\\b|\\bse\\b|\\blas\\b|\\bpor\\b|\\bun\\b|\\bpara\\b|\\bcon\\b|\\bno\\b|\\buna\\b|\\bsu\\b|\\bal\\b|\\blo\\b|\\bcomo\\b|\\bmás\\b|\\bpero\\b|\\bsus\\b|\\ble\\b|\\bya\\b|\\bo\\b|\\beste\\b|\\bsí\\b|\\bporque\\b|\\besta\\b|\\bentre\\b|\\bcuando\\b|\\bmuy\\b|\\bsin\\b|\\bsobre\\b|\\btambién\\b|\\bme\\b|\\bhasta\\b|\\bhay\\b|\\bdonde\\b|\\bquien\\b|\\bdesde\\b|\\btodo\\b|\\bnos\\b|\\bdurante\\b|\\btodos\\b|\\buno\\b|\\bles\\b|\\bni\\b|\\bcontra\\b|\\botros\\b|\\bese\\b|\\beso\\b|\\bante\\b|\\bellos\\b|\\be\\b|\\besto\\b|\\bmí\\b|\\bantes\\b|\\balgunos\\b|\\bqué\\b|\\bunos\\b|\\byo\\b|\\botro\\b|\\botras\\b|\\botra\\b|\\bél\\b|\\btanto\\b|\\besa\\b|\\bestos\\b|\\bmucho\\b|\\bquienes\\b|\\bnada\\b|\\bmuchos\\b|\\bcual\\b|\\bpoco\\b|\\bella\\b|\\bestar\\b|\\bestas\\b|\\balgunas\\b|\\balgo\\b|\\bnosotros\\b|\\bmi\\b|\\bmis\\b|\\btú\\b|\\bte\\b|\\bti\\b|\\btu\\b|\\btus\\b|\\bellas\\b|\\bnosotras\\b|\\bvosotros\\b|\\bvosotras\\b|\\bos\\b|\\bmío\\b|\\bmía\\b|\\bmíos\\b|\\bmías\\b|\\btuyo\\b|\\btuya\\b|\\btuyos\\b|\\btuyas\\b|\\bsuyo\\b|\\bsuya\\b|\\bsuyos\\b|\\bsuyas\\b|\\bnuestro\\b|\\bnuestra\\b|\\bnuestros\\b|\\bnuestras\\b|\\bvuestro\\b|\\bvuestra\\b|\\bvuestros\\b|\\bvuestras\\b|\\besos\\b|\\besas\\b|\\bestoy\\b|\\bestás\\b|\\bestá\\b|\\bestamos\\b|\\bestáis\\b|\\bestán\\b|\\besté\\b|\\bestés\\b|\\bestemos\\b|\\bestéis\\b|\\bestén\\b|\\bestaré\\b|\\bestarás\\b|\\bestará\\b|\\bestaremos\\b|\\bestaréis\\b|\\bestarán\\b|\\bestaría\\b|\\bestarías\\b|\\bestaríamos\\b|\\bestaríais\\b|\\bestarían\\b|\\bestaba\\b|\\bestabas\\b|\\bestábamos\\b|\\bestabais\\b|\\bestaban\\b|\\bestuve\\b|\\bestuviste\\b|\\bestuvo\\b|\\bestuvimos\\b|\\bestuvisteis\\b|\\bestuvieron\\b|\\bestuviera\\b|\\bestuvieras\\b|\\bestuviéramos\\b|\\bestuvierais\\b|\\bestuvieran\\b|\\bestuviese\\b|\\bestuvieses\\b|\\bestuviésemos\\b|\\bestuvieseis\\b|\\bestuviesen\\b|\\bestando\\b|\\bestado\\b|\\bestada\\b|\\bestados\\b|\\bestadas\\b|\\bestad\\b|\\bhe\\b|\\bhas\\b|\\bha\\b|\\bhemos\\b|"
#> 
#> $sw2
#> [1] "\\bhabéis\\b|\\bhan\\b|\\bhaya\\b|\\bhayas\\b|\\bhayamos\\b|\\bhayáis\\b|\\bhayan\\b|\\bhabré\\b|\\bhabrás\\b|\\bhabrá\\b|\\bhabremos\\b|\\bhabréis\\b|\\bhabrán\\b|\\bhabría\\b|\\bhabrías\\b|\\bhabríamos\\b|\\bhabríais\\b|\\bhabrían\\b|\\bhabía\\b|\\bhabías\\b|\\bhabíamos\\b|\\bhabíais\\b|\\bhabían\\b|\\bhube\\b|\\bhubiste\\b|\\bhubo\\b|\\bhubimos\\b|\\bhubisteis\\b|\\bhubieron\\b|\\bhubiera\\b|\\bhubieras\\b|\\bhubiéramos\\b|\\bhubierais\\b|\\bhubieran\\b|\\bhubiese\\b|\\bhubieses\\b|\\bhubiésemos\\b|\\bhubieseis\\b|\\bhubiesen\\b|\\bhabiendo\\b|\\bhabido\\b|\\bhabida\\b|\\bhabidos\\b|\\bhabidas\\b|\\bsoy\\b|\\beres\\b|\\bes\\b|\\bsomos\\b|\\bsois\\b|\\bson\\b|\\bsea\\b|\\bseas\\b|\\bseamos\\b|\\bseáis\\b|\\bsean\\b|\\bseré\\b|\\bserás\\b|\\bserá\\b|\\bseremos\\b|\\bseréis\\b|\\bserán\\b|\\bsería\\b|\\bserías\\b|\\bseríamos\\b|\\bseríais\\b|\\bserían\\b|\\bera\\b|\\beras\\b|\\béramos\\b|\\berais\\b|\\beran\\b|\\bfui\\b|\\bfuiste\\b|\\bfue\\b|\\bfuimos\\b|\\bfuisteis\\b|\\bfueron\\b|\\bfuera\\b|\\bfueras\\b|\\bfuéramos\\b|\\bfuerais\\b|\\bfueran\\b|\\bfuese\\b|\\bfueses\\b|\\bfuésemos\\b|\\bfueseis\\b|\\bfuesen\\b|\\bsiendo\\b|\\bsido\\b|\\btengo\\b|\\btienes\\b|\\btiene\\b|\\btenemos\\b|\\btenéis\\b|\\btienen\\b|\\btenga\\b|\\btengas\\b|\\btengamos\\b|\\btengáis\\b|\\btengan\\b|\\btendré\\b|\\btendrás\\b|\\btendrá\\b|\\btendremos\\b|\\btendréis\\b|\\btendrán\\b|\\btendría\\b|\\btendrías\\b|\\btendríamos\\b|\\btendríais\\b|\\btendrían\\b|\\btenía\\b|\\btenías\\b|\\bteníamos\\b|\\bteníais\\b|\\btenían\\b|\\btuve\\b|\\btuviste\\b|\\btuvo\\b|\\btuvimos\\b|\\btuvisteis\\b|\\btuvieron\\b|\\btuviera\\b|\\btuvieras\\b|\\btuviéramos\\b|\\btuvierais\\b|\\btuvieran\\b|\\btuviese\\b|\\btuvieses\\b|\\btuviésemos\\b|\\btuvieseis\\b|\\btuviesen\\b|\\bteniendo\\b|\\btenido\\b|\\btenida\\b|\\btenidos\\b|\\btenidas\\b|\\btened\\b"
#> 
#> $dias
#> [1] "\\bdomingo\\b|\\blunes\\b|\\bmartes\\b|\\bmiércoles\\b|\\bjueves\\b|\\bviernes\\b|\\bsábado\\b|\\bDomingo\\b|\\bLunes\\b|\\bMartes\\b|\\bMiércoles\\b|\\bJueves\\b|\\bViernes\\b|\\bSábado\\b|\\bMiercoles\\b|\\bmiercoles\\b|\\bMIERCOLES\\b|\\bSABADO\\b|\\bSabado\\b|\\bsabado\\b|\\bDOMINGO\\b|\\bLUNES\\b|\\bMARTES\\b|\\bMIÉRCOLES\\b|\\bJUEVES\\b|\\bVIERNES\\b|\\bSÁBADO\\b"
#> 
#> $meses
#> [1] "\\benero\\b|\\bfebrero\\b|\\bmarzo\\b|\\babril\\b|\\bmayo\\b|\\bjunio\\b|\\bjulio\\b|\\bagosto\\b|\\bseptiembre\\b|\\boctubre\\b|\\bnoviembre\\b|\\bdiciembre\\b|\\bEnero\\b|\\bFebrero\\b|\\bMarzo\\b|\\bAbril\\b|\\bMayo\\b|\\bJunio\\b|\\bJulio\\b|\\bAgosto\\b|\\bSeptiembre\\b|\\bOctubre\\b|\\bNoviembre\\b|\\bDiciembre\\b|\\bENERO\\b|\\bFEBRERO\\b|\\bMARZO\\b|\\bABRIL\\b|\\bMAYO\\b|\\bJUNIO\\b|\\bJULIO\\b|\\bAGOSTO\\b|\\bSEPTIEMBRE\\b|\\bOCTUBRE\\b|\\bNOVIEMBRE\\b|\\bDICIEMBRE\\b"
#> 
#> $punt
#> [1] "[^[:alnum:][:digit:][:blank:]\\p{So}|\\p{Cn}\\t\\r\\n#@ŠŽšžŸÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝàáâãäåçèéêëìíîïðñòóôõöùúûüýÿ]"
#> 
#> $emojis
#> [1] "[^ñáéíóúüç…ÇÜÁÉÍÓÚÑ\\001-\\177]"
#> 
#> $tildes
#> [1] "ŠŽšžŸÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝàáâãäåçèéêëìíîïðñòóôõöùúûüýÿ"
#> 
```
