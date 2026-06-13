# Eliminar recursivamente una clave de un esquema con estructura anidada

Recorre el esquema (objetos anidados, items de arrays) y elimina todas
las apariciones de \`key\`, no solo la del nivel raiz. Util para
proveedores cuyo formato de esquema no admite ciertas claves (por
ejemplo \`additionalProperties\` en el responseSchema de Gemini).

## Usage

``` r
.acep_provider_strip_key(schema, key)
```
