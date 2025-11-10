# Función para buscar y extraer palabras en un texto.

Esta función busca palabras clave en un texto y extrae los resultados en
un formato especifico.

## Usage

``` r
acep_extract(texto, dic, sep = "; ", izq = "\\b\\w*", der = "\\w*\\b")
```

## Arguments

- texto:

  El texto en el que se buscaran las palabras clave.

- dic:

  Un vector con las palabras clave a buscar.

- sep:

  El separador utilizado para concatenar las palabras clave encontradas
  (por defecto: " \| ").

- izq:

  expresión regular para incorporar otros caracteres a la izquierda de
  los términos del vector 'dic'.

- der:

  expresión regular para incorporar otros caracteres a la derecha de los
  términos del vector 'dic'.

## Value

Si todas las entradas son correctas, la salida sera un vector de tipo
caracter. procesado y el contexto de las palabras y/o frases entradas.

## Examples

``` r
texto <- "Los obreros del pescado, en el marco de una huelga y
realizaron una manifestación con piquete en el puerto de la ciudad."
dicc <- c("huel", "manif", "piq")
acep_extract(texto, dicc)
#> [1] "huelga; manifestación; piquete"
```
