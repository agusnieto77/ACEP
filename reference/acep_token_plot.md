# Gráfico de barras de palabras más recurrentes en un corpus.

Función que devuelve un gráfico de barras con las palabras mas
recurrentes en un corpus textual.

## Usage

``` r
acep_token_plot(x, u = 10, frec = TRUE)
```

## Arguments

- x:

  vector de palabras tokenizadas.

- u:

  numero de corte para el top de palabras mas frecuentes.

- frec:

  parámetro para determinar si los valores se visualizaran como
  frecuencia absoluta o relativa.

## Value

Si todas las entradas son correctas, la salida sera un gráfico de
barras.

## Examples

``` r
tokens <- c(rep("paro",15), rep("piquete",25), rep("corte",20), rep("manifestación",10),
rep("bloqueo",5), rep("alerta",16), rep("ciudad",12), rep("sindicato",11), rep("paritaria",14),
rep("huelga",14), rep("escrache",15))
acep_token_plot(tokens)
```
