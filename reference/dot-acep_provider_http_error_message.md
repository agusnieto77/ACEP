# Extraer un mensaje de error legible de una respuesta HTTP de error

Maneja de forma robusta los distintos cuerpos de error que puede
devolver una API: una lista con \`error\$message\`, un campo \`error\`
atomico (una cadena en lugar de un objeto), un cuerpo de texto plano (p.
ej. una pagina HTML de un gateway 5xx) o un contenido nulo. Nunca falla
con "\$ operator is invalid for atomic vectors".

## Usage

``` r
.acep_provider_http_error_message(error_content)
```
