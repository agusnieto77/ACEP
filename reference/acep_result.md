# Constructor de resultados de analisis

Crea un objeto de clase \`acep_result\` que encapsula los resultados de
un analisis de texto realizado con funciones de ACEP. Este objeto
proporciona metodos especializados para visualizacion (\`plot()\`),
resumen (\`summary()\`) y conversion a data frame (\`as.data.frame()\`).

## Usage

``` r
acep_result(data, tipo = "general", metadata = NULL)
```

## Arguments

- data:

  Data frame con los resultados del analisis.

- tipo:

  Tipo de resultado que contiene el objeto. Valores comunes:
  \`"frecuencia"\`, \`"intensidad"\`, \`"svo"\`, \`"serie_temporal"\`,
  \`"general"\`. Este parametro determina el comportamiento de los
  metodos de impresion y visualizacion.

- metadata:

  Lista opcional con informacion sobre el analisis realizado (ej:
  diccionario utilizado, parametros aplicados, corpus de origen).

## Value

Objeto de clase \`acep_result\` con la siguiente estructura:

- `data`: Data frame con los resultados del analisis

- `tipo`: Etiqueta del tipo de resultado

- `metadata`: Informacion adicional del analisis

- `fecha_creacion`: Timestamp de creacion del objeto

## Examples

``` r
# Crear resultado de analisis de frecuencias
datos <- data.frame(
  texto = c("El SUTEBA va al paro", "SOIP protesta"),
  frecuencia = c(5, 3)
)
resultado <- acep_result(datos, tipo = "frecuencia")
print(resultado)
#> acep_result object
#> ==================
#> Tipo: frecuencia 
#> Filas: 2 
#> Columnas: 2 
#> Creado: 2025-11-10 02:23:47 
#> 
#> Primeras filas:
#>                  texto frecuencia
#> 1 El SUTEBA va al paro          5
#> 2        SOIP protesta          3
summary(resultado)
#> acep_result summary
#> ===================
#> Tipo: frecuencia 
#> Dimensiones: 2 x 2 
#> Columnas: texto, frecuencia 
#> 

# Convertir a data frame
df <- as.data.frame(resultado)
```
