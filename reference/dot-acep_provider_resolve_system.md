# Resolver el prompt de sistema (persona) de un proveedor

Si \`system\` es NULL devuelve \`default\` (la persona por defecto del
proveedor, preservando el comportamiento previo). Si es una cadena no
vacia la usa como persona. Cualquier otro valor (no caracter, vacio, NA
o longitud != 1) es un error.

## Usage

``` r
.acep_provider_resolve_system(system, default)
```
