#' @title Limpieza de texto.
#' @description Función que limpia y normaliza las notas/textos.
#' @param x vector de textos al que se le aplica la función de limpieza de texto.
#' @param rm_hashtag remueve los hashtags.
#' @param rm_emoji remueve los emojis.
#' @param rm_punt remueve la puntuación.
#' @param rm_num remueve números.
#' @param rm_whitespace remueve los espacios en blanco.
#' @param rm_newline remueve los saltos de línea.
#' @param rm_cesp remueve caracteres especiales.
#' @param rm_stopwords remueve palabras vacías.
#' @param rm_dias remueve los días de la semana.
#' @param rm_meses remueve los meses del año.
#' @param rm_shortwords remueve las palabras cortas.
#' @param rm_url remueve las url.
#' @param rm_users remueve las menciones de usuarixs de redes sociales.
#' @param u umbral de caracteres para la función rm_shortwords.
#' @param tolower convierte los textos a minúsculas.
#' @keywords normalización
#' @examples
#' rev_puerto <- acep_bases$rev_puerto
#' rev_puerto$conflictos <- acep_clean(rev_puerto$nota)
#' rev_puerto |> head()
#' @export

acep_clean <- function(x,
                       tolower = TRUE,
                       rm_cesp = TRUE,
                       rm_emoji = TRUE,
                       rm_hashtag = TRUE,
                       rm_users = TRUE,
                       rm_punt = TRUE,
                       rm_num = TRUE,
                       rm_url = TRUE,
                       rm_meses = TRUE,
                       rm_dias = TRUE,
                       rm_stopwords = TRUE,
                       rm_shortwords = TRUE,
                       rm_newline = TRUE,
                       rm_whitespace = TRUE,
                       u = 1) {

  punt = '[[:punct:]]*'
  num = '[[:digit:]]*'
  emoji = "[^ñáéíóúüçÇÜÁÉÍÓÚÑ^\x01-\x7F]"
  hashtag = '#\\S+'
  espacios = "^ *|(?<= ) | *$"
  saltos = '[ \t\r\n]'
  stopwords = "\\bde\\b|\\bla\\b|\\bque\\b|\\bel\\b|\\ben\\b|\\by\\b|\\ba\\b|\\blos\\b|\\bdel\\b|\\bse\\b|\\blas\\b|\\bpor\\b|\\bun\\b|\\bpara\\b|\\bcon\\b|\\bno\\b|\\buna\\b|\\bsu\\b|\\bal\\b|\\blo\\b|\\bcomo\\b|\\bmás\\b|\\bpero\\b|\\bsus\\b|\\ble\\b|\\bya\\b|\\bo\\b|\\beste\\b|\\bsí\\b|\\bporque\\b|\\besta\\b|\\bentre\\b|\\bcuando\\b|\\bmuy\\b|\\bsin\\b|\\bsobre\\b|\\btambién\\b|\\bme\\b|\\bhasta\\b|\\bhay\\b|\\bdonde\\b|\\bquien\\b|\\bdesde\\b|\\btodo\\b|\\bnos\\b|\\bdurante\\b|\\btodos\\b|\\buno\\b|\\bles\\b|\\bni\\b|\\bcontra\\b|\\botros\\b|\\bese\\b|\\beso\\b|\\bante\\b|\\bellos\\b|\\be\\b|\\besto\\b|\\bmí\\b|\\bantes\\b|\\balgunos\\b|\\bqué\\b|\\bunos\\b|\\byo\\b|\\botro\\b|\\botras\\b|\\botra\\b|\\bél\\b|\\btanto\\b|\\besa\\b|\\bestos\\b|\\bmucho\\b|\\bquienes\\b|\\bnada\\b|\\bmuchos\\b|\\bcual\\b|\\bpoco\\b|\\bella\\b|\\bestar\\b|\\bestas\\b|\\balgunas\\b|\\balgo\\b|\\bnosotros\\b|\\bmi\\b|\\bmis\\b|\\btú\\b|\\bte\\b|\\bti\\b|\\btu\\b|\\btus\\b|\\bellas\\b|\\bnosotras\\b|\\bvosotros\\b|\\bvosotras\\b|\\bos\\b|\\bmío\\b|\\bmía\\b|\\bmíos\\b|\\bmías\\b|\\btuyo\\b|\\btuya\\b|\\btuyos\\b|\\btuyas\\b|\\bsuyo\\b|\\bsuya\\b|\\bsuyos\\b|\\bsuyas\\b|\\bnuestro\\b|\\bnuestra\\b|\\bnuestros\\b|\\bnuestras\\b|\\bvuestro\\b|\\bvuestra\\b|\\bvuestros\\b|\\bvuestras\\b|\\besos\\b|\\besas\\b|\\bestoy\\b|\\bestás\\b|\\bestá\\b|\\bestamos\\b|\\bestáis\\b|\\bestán\\b|\\besté\\b|\\bestés\\b|\\bestemos\\b|\\bestéis\\b|\\bestén\\b|\\bestaré\\b|\\bestarás\\b|\\bestará\\b|\\bestaremos\\b|\\bestaréis\\b|\\bestarán\\b|\\bestaría\\b|\\bestarías\\b|\\bestaríamos\\b|\\bestaríais\\b|\\bestarían\\b|\\bestaba\\b|\\bestabas\\b|\\bestábamos\\b|\\bestabais\\b|\\bestaban\\b|\\bestuve\\b|\\bestuviste\\b|\\bestuvo\\b|\\bestuvimos\\b|\\bestuvisteis\\b|\\bestuvieron\\b|\\bestuviera\\b|\\bestuvieras\\b|\\bestuviéramos\\b|\\bestuvierais\\b|\\bestuvieran\\b|\\bestuviese\\b|\\bestuvieses\\b|\\bestuviésemos\\b|\\bestuvieseis\\b|\\bestuviesen\\b|\\bestando\\b|\\bestado\\b|\\bestada\\b|\\bestados\\b|\\bestadas\\b|\\bestad\\b|\\bhe\\b|\\bhas\\b|\\bha\\b|\\bhemos\\b|\\bhabéis\\b|\\bhan\\b|\\bhaya\\b|\\bhayas\\b|\\bhayamos\\b|\\bhayáis\\b|\\bhayan\\b|\\bhabré\\b|\\bhabrás\\b|\\bhabrá\\b|\\bhabremos\\b|\\bhabréis\\b|\\bhabrán\\b|\\bhabría\\b|\\bhabrías\\b|\\bhabríamos\\b|\\bhabríais\\b|\\bhabrían\\b|\\bhabía\\b|\\bhabías\\b|\\bhabíamos\\b|\\bhabíais\\b|\\bhabían\\b|\\bhube\\b|\\bhubiste\\b|\\bhubo\\b|\\bhubimos\\b|\\bhubisteis\\b|\\bhubieron\\b|\\bhubiera\\b|\\bhubieras\\b|\\bhubiéramos\\b|\\bhubierais\\b|\\bhubieran\\b|\\bhubiese\\b|\\bhubieses\\b|\\bhubiésemos\\b|\\bhubieseis\\b|\\bhubiesen\\b|\\bhabiendo\\b|\\bhabido\\b|\\bhabida\\b|\\bhabidos\\b|\\bhabidas\\b|\\bsoy\\b|\\beres\\b|\\bes\\b|\\bsomos\\b|\\bsois\\b|\\bson\\b|\\bsea\\b|\\bseas\\b|\\bseamos\\b|\\bseáis\\b|\\bsean\\b|\\bseré\\b|\\bserás\\b|\\bserá\\b|\\bseremos\\b|\\bseréis\\b|\\bserán\\b|\\bsería\\b|\\bserías\\b|\\bseríamos\\b|\\bseríais\\b|\\bserían\\b|\\bera\\b|\\beras\\b|\\béramos\\b|\\berais\\b|\\beran\\b|\\bfui\\b|\\bfuiste\\b|\\bfue\\b|\\bfuimos\\b|\\bfuisteis\\b|\\bfueron\\b|\\bfuera\\b|\\bfueras\\b|\\bfuéramos\\b|\\bfuerais\\b|\\bfueran\\b|\\bfuese\\b|\\bfueses\\b|\\bfuésemos\\b|\\bfueseis\\b|\\bfuesen\\b|\\bsiendo\\b|\\bsido\\b|\\btengo\\b|\\btienes\\b|\\btiene\\b|\\btenemos\\b|\\btenéis\\b|\\btienen\\b|\\btenga\\b|\\btengas\\b|\\btengamos\\b|\\btengáis\\b|\\btengan\\b|\\btendré\\b|\\btendrás\\b|\\btendrá\\b|\\btendremos\\b|\\btendréis\\b|\\btendrán\\b|\\btendría\\b|\\btendrías\\b|\\btendríamos\\b|\\btendríais\\b|\\btendrían\\b|\\btenía\\b|\\btenías\\b|\\bteníamos\\b|\\bteníais\\b|\\btenían\\b|\\btuve\\b|\\btuviste\\b|\\btuvo\\b|\\btuvimos\\b|\\btuvisteis\\b|\\btuvieron\\b|\\btuviera\\b|\\btuvieras\\b|\\btuviéramos\\b|\\btuvierais\\b|\\btuvieran\\b|\\btuviese\\b|\\btuvieses\\b|\\btuviésemos\\b|\\btuvieseis\\b|\\btuviesen\\b|\\bteniendo\\b|\\btenido\\b|\\btenida\\b|\\btenidos\\b|\\btenidas\\b|\\btened\\b"
  dias = paste0(c('domingo','lunes','martes','miércoles','jueves','viernes','sábado',
                  'Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado',
                  'Miercoles','miercoles','MIERCOLES','SABADO','Sabado', 'sabado',
                  toupper(c('domingo','lunes','martes','miércoles','jueves','viernes','sábado'))),
                collapse = '|')
  meses = paste0(c('enero','febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre',
                   'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre',
                   toupper(c('enero','febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre'))),
                 collapse = '|')
  shortwords = paste0('\\b[[:alpha:]]{1,',u,'}\\b')
  url = paste0('http\\S+|ftp\\S+|Http\\S+|Ftp\\S+', '|', toupper('http\\S+|ftp\\S+'))
  users = '@\\S+'

  if(tolower == TRUE){
    x <- tolower(x)}
  if(rm_cesp == TRUE){
    x <- gsub('á', "a", x, perl = TRUE)
    x <- gsub('é', "e", x, perl = TRUE)
    x <- gsub('í', "i", x, perl = TRUE)
    x <- gsub('ó', "o", x, perl = TRUE)
    x <- gsub('ú', "u", x, perl = TRUE)
    x <- gsub('à', "a", x, perl = TRUE)
    x <- gsub('è', "e", x, perl = TRUE)
    x <- gsub('ì', "i", x, perl = TRUE)
    x <- gsub('ò', "o", x, perl = TRUE)
    x <- gsub('ù', "u", x, perl = TRUE)
    x <- gsub('ñ', "n", x, perl = TRUE)
    x <- gsub('Á', "A", x, perl = TRUE)
    x <- gsub('É', "E", x, perl = TRUE)
    x <- gsub('Í', "I", x, perl = TRUE)
    x <- gsub('Ó', "O", x, perl = TRUE)
    x <- gsub('Ú', "U", x, perl = TRUE)
    x <- gsub('À', "A", x, perl = TRUE)
    x <- gsub('È', "E", x, perl = TRUE)
    x <- gsub('Ì', "I", x, perl = TRUE)
    x <- gsub('Ò', "O", x, perl = TRUE)
    x <- gsub('Ù', "U", x, perl = TRUE)
    x <- gsub('ü', "u", x, perl = TRUE)
    x <- gsub('Ü', "U", x, perl = TRUE)
    x <- gsub('Ñ', "N", x, perl = TRUE)
    x <- gsub('ñ', "n", x, perl = TRUE)}
  if(rm_emoji == TRUE){
    x <- gsub(emoji, " ", x, perl = TRUE)}
  if(rm_hashtag == TRUE){
    x <- gsub(hashtag, "", x, perl = TRUE)}
  if(rm_users == TRUE){
    x <- gsub(users, "", x, perl = TRUE)}
  if(rm_punt == TRUE){
    x <- gsub(punt, "", x, perl = TRUE)}
  if(rm_num == TRUE){
    x <- gsub(num, "", x, perl = TRUE)}
  if(rm_url == TRUE){
    x <- gsub(url, "", x, perl = TRUE)}
  if(rm_meses == TRUE){
    x <- gsub(meses, "", x, perl = TRUE)}
  if(rm_dias == TRUE){
    x <- gsub(dias, "", x, perl = TRUE)}
  if(rm_stopwords == TRUE){
    x <- gsub(stopwords, " ", x, perl = FALSE)}
  if(rm_shortwords == TRUE){
    x <- gsub(shortwords, " ", x, perl = FALSE)}
  if(rm_newline == TRUE){
    x <- gsub(saltos, " ", x, perl = TRUE)}
  if(rm_whitespace == TRUE){
    gsub(espacios, "", x, perl = TRUE)
      } else {
        x
      }
}
