# Funcion auxiliar para proteger arrays en esquemas JSON

Protege arrays en esquemas JSON para evitar que jsonlite::toJSON los
convierta incorrectamente. Aplica I() a campos 'required' y 'enum'
recursivamente.

Protege arrays en esquemas JSON para evitar que jsonlite::toJSON los
convierta incorrectamente. Aplica I() a campos 'required' y 'enum'
recursivamente.

## Usage

``` r
proteger_arrays_schema(schema)

proteger_arrays_schema(schema)
```

## Arguments

- schema:

  Esquema JSON como lista de R

## Value

Esquema con arrays protegidos

Esquema con arrays protegidos
