# Ejecutar una peticion POST a un proveedor de IA

Centraliza la construccion de la peticion HTTP comun a los proveedores
en la nube: serializa el cuerpo a JSON con \`auto_unbox = TRUE\`, arma
las cabeceras, aplica un timeout y realiza el POST. El ensamblado del
\`body\` y el parseo de la respuesta siguen siendo especificos de cada
proveedor.

## Usage

``` r
.acep_provider_post(url, headers, body, timeout = 120, encode = "raw")
```
