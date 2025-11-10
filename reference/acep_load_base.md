# Carga los corpus y las bases creadas por el Observatorio.

Función para cargar bases de datos disponibles online. Por ahora están
disponibles las siguientes bases: Revista Puerto 'rp_mdp'; La Nueva
'ln_bb', La Capital 'lc_mdp', Ecos Diarios 'ed_neco', La Nación 'ln_arg'

## Usage

``` r
acep_load_base(tag)
```

## Arguments

- tag:

  etiqueta identificatoria del data frame a cargar: acep_bases\$rp_mdp,
  acep_bases\$ln_bb, acep_bases\$lc_mdp, acep_bases\$ed_neco,
  acep_bases\$ln_arg

## Value

Si todas las entradas son correctas, la salida sera una base de datos en
formato tabular con un corpus de notas.

## Examples

``` r
bd_sismos <- acep_bases$rev_puerto
head(acep_load_base(tag = bd_sismos))
#> Descargando...
#> # A tibble: 6 × 3
#>   fecha      titulo                                                        nota 
#>   <date>     <chr>                                                         <chr>
#> 1 2019-03-29 Astillero Contessi botó al Luca Santino, un fresquero de nue… "Tra…
#> 2 2019-03-29 Di Leva despidió a trabajadores de El Marisco y Sebastián Ga… "Tra…
#> 3 2019-03-29 El Consejo aprobó la apertura al norte para el calamar        "En …
#> 4 2019-03-28 “Todos los empresarios me dicen que tendrían que achicarse”   "Cri…
#> 5 2019-03-28 En el Puerto de Montevideo siguen bajando un muerto por mes   "La …
#> 6 2019-03-28 Habilitan el muelle Piedra Buena para descarga de congelador… "La …
```
