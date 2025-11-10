# Constructor de corpus para analisis de texto

Crea un objeto de clase \`acep_corpus\` que encapsula una coleccion de
textos junto con su metadata asociada. Este objeto esta disenado para
trabajar con las funciones pipeline de ACEP (\`pipe_clean\`,
\`pipe_count\`, etc.), permitiendo un flujo de trabajo encadenado y
manteniendo trazabilidad de las transformaciones aplicadas.

## Usage

``` r
acep_corpus(texto, metadata = NULL, id = NULL)
```

## Arguments

- texto:

  Vector de caracteres con los textos a almacenar en el corpus.

- metadata:

  Lista opcional con informacion adicional sobre el corpus (ej: fuente,
  fecha de recoleccion, categorias tematicas).

- id:

  Vector opcional de identificadores unicos para cada texto. Si no se
  proporciona, se asignan IDs secuenciales (1, 2, 3, ...).

## Value

Objeto de clase \`acep_corpus\` con la siguiente estructura:

- `texto_original`: Vector con los textos originales sin procesar

- `texto_procesado`: Vector con textos procesados (NULL inicialmente)

- `id`: Identificadores de cada texto

- `metadata`: Metadata adicional del corpus

- `procesamiento`: Registro de transformaciones aplicadas

## Examples

``` r
# Crear corpus simple
textos <- c("El SUTEBA va al paro", "SOIP protesta por salarios")
corpus <- acep_corpus(textos)
print(corpus)
#> acep_corpus object
#> ==================
#> Documentos: 2 
#> Procesado: FALSE 
#> Pasos aplicados: 0 

# Crear corpus con metadata e IDs personalizados
corpus <- acep_corpus(
  texto = c("Noticia 1", "Noticia 2"),
  metadata = list(fuente = "Diario La Nacion", year = 2024),
  id = c("LN001", "LN002")
)
```
