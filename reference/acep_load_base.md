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
if (FALSE) { # \dontrun{
bd_sismos <- acep_bases$rev_puerto
head(acep_load_base(tag = bd_sismos))
} # }
```
