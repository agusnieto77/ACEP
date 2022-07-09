
<!-- README.md is generated from README.Rmd. Please edit that file -->

## ACEP: Análisis Computacional de Eventos de Protesta<img src="man/figures/logo.png" align="right" height="139"/>

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/agusnieto77/ACEP/branch/master/graph/badge.svg)](https://app.codecov.io/gh/agusnieto77/ACEP?branch=master)
[![R-CMD-check](https://github.com/agusnieto77/ACEP/workflows/R-CMD-check/badge.svg)](https://github.com/agusnieto77/ACEP/actions)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6800706.svg)](https://doi.org/10.5281/zenodo.6800706)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![](https://img.shields.io/badge/devel%20version-0.0.1.9000-blue.svg)](https://github.com/agusnieto77/ACEP)
[![License:
MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://cran.r-project.org/web/licenses/MIT)
[![](https://img.shields.io/github/languages/code-size/agusnieto77/ACEP.svg)](https://github.com/agusnieto77/ACEP)
[![](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![](https://img.shields.io/badge/Build%20with-R%20&%20RStudio-blue?style=plastic=appveyor)](https://github.com/agusnieto77/ACEP)
[![](https://img.shields.io/badge/ACEP-ready%20to%20use-color:%20#39c?style=plastic=appveyor)](https://github.com/agusnieto77/ACEP)
[![](https://img.shields.io/badge/Developed%20by-SISMOS-darkred?style=plastic=appveyor)](https://observatoriodeconflictividad.org/el-pulso-de-la-conflictividad-en-tiempo-real/)

<!-- badges: end -->

### Visión general

ACEP es un paquete de funciones en lenguaje R útiles para la detección y
el análisis de eventos de protesta en corpus de textos periodísticos.
Contiene también base de datos con colecciones de notas sobre protestas
y diccionarios de palabras conflictivas. Colección de diccionarios que
reúne diccionarios de diferentes orígenes.

### Instalación de la versión en desarrollo

Puedes instalar la versión de desarrollo de ACEP desde
[GitHub](https://github.com/) con:

``` r
# install.packages("devtools")
devtools::install_github("agusnieto77/ACEP")
```

### Funciones

| Nombre             | Descripción                                                           |
|:-------------------|:----------------------------------------------------------------------|
| `acep_db()`        | Frecuencia, menciones e intensidad.                                   |
| `acep_frec()`      | Frecuencia de palabras totales.                                       |
| `acep_int()`       | Índice de intensidad.                                                 |
| `acep_load_base()` | Carga bases de datos creadas por el Observatorio.                     |
| `acep_men()`       | Frecuencia de menciones de palabras.                                  |
| `acep_post_rst()`  | Resumen visual de la serie temporal de los índices de conflictividad. |
| `acep_post_st()`   | Gráfico de barras de la serie temporal de índices de conflictividad.  |
| `acep_rst()`       | Serie temporal de índices de conflictividad.                          |

### Colecciones

| Nombre              | Descripción                |
|:--------------------|:---------------------------|
| `acep_bases`        | Colección de notas.        |
| `acep_diccionarios` | Colección de diccionarios. |

### Corpus

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6800663.svg)](https://doi.org/10.5281/zenodo.6800663)
Colección de notas del diario ***La Nación***

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6800765.svg)](https://doi.org/10.5281/zenodo.6800765)
Subset de notas del diario ***La Nación***

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6800617.svg)](https://doi.org/10.5281/zenodo.6800617)
Colección de notas del ***Ecos Diarios***

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6800637.svg)](https://doi.org/10.5281/zenodo.6800637)
Colección de notas de la ***Revista Puerto***

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6800650.svg)](https://doi.org/10.5281/zenodo.6800650)
Colección de notas del diario ***La Nueva***

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6800660.svg)](https://doi.org/10.5281/zenodo.6800660)
Colección de notas del diario ***La Capital***

### Bases de datos de Eventos de protesta disponibles online

[ACLED](https://acleddata.com/#/dashboard): Armed Conflict Location &
Event Data Project.

[GDELT](https://www.gdeltproject.org/): The GDELT Project About.

[GPT](https://carnegieendowment.org/publications/interactive/protest-tracker#):
Global Protest Tracker.

[MMPD](https://dataverse.harvard.edu/dataverse/MMdata): Mass
Mobilization Protest Data Project.

[NAVCO](https://dataverse.harvard.edu/dataverse/navco): Nonviolent and
Violent Campaigns and Outcomes data project.

[NVCO](https://nvdatabase.swarthmore.edu/): Global Nonviolent Action
Database.

[SCAD](https://www.strausscenter.org/ccaps-research-areas/social-conflict/database/):
Social Conflict Analysis Database.

[SPEED](https://clinecenter.illinois.edu/project/human-loop-event-data-projects/SPEED):
The Social, Political and Economic Event Database Project.

[UCDP](https://www.pcr.uu.se/research/ucdp/): Uppsala Conflict Data
Program.

### Bases de datos de interés general

[FMI](https://data.imf.org/?sk=388dfa60-1d26-4ade-b505-a05a558d9a42):
FMI Data.

[BM](https://datos.bancomundial.org/): Datos de libre acceso del Banco
Mundial.

[OIT](https://www.ilo.org/global/statistics-and-databases/lang--es/index.htm):
Estadísticas y bases de datos.

[CEPAL](https://www.cepal.org/es/datos-y-estadisticas): Datos y
estadísticas.

[DARG](https://www.datos.gob.ar/): Datos abiertos de Argentina.

[MGP](https://datos.mardelplata.gob.ar/): Datos abiertos del Municipio
de Gral. Pueyrredon, Buenos Aires, Argentina.

### Uso de las funciones del paquete ACEP: un ejemplo.

``` r
# Cargamos la librería
require(ACEP)
#> Loading required package: ACEP

# Cargamos la base de notas de La Nueva
la_nueva <- acep_bases$la_nueva

# Imprimimos las primeras 10 filas
head(la_nueva, 20) |> tibble::as_tibble()
#> # A tibble: 20 × 3
#>    fecha      titulo                                                       nota 
#>    <date>     <chr>                                                        <chr>
#>  1 2022-01-15 "Llevan 36 horas sin energía por un cable suelto y EDES cal… "Vec…
#>  2 2022-01-15 "Explotó un generador que EDES colocó en el centro de la ci… "Mom…
#>  3 2022-01-15 "Amenazaron a trabajadores de ABSA en el barrio Stella Mari… "Tra…
#>  4 2022-01-15 "Intenso calor y falta de lluvia, el combo ideal para los i… "Las…
#>  5 2022-01-15 "Investigan un incendio que destruyó un automóvil"           "La …
#>  6 2022-01-15 "Con la ola de contagios, ¿cuándo vuelven las clases?"       "Por…
#>  7 2022-01-15 "Pavimento que estalla: ¿a qué se deben las roturas?"        "Aud…
#>  8 2022-01-15 "¿Cuánto falta para que la pandemia llegue a su fin y pase … "Aud…
#>  9 2022-01-14 "Vecinos del barrio Patagonia piden que avance una obra en … "La …
#> 10 2022-01-14 "Otra renuncia en el Municipio: se va Karina Mahon"          "La …
#> 11 2022-01-14 "Bomberos tuvieron que apagar un incendio en un balcón"      "Bom…
#> 12 2022-01-14 "Romera: \"Dichiara se equivoca, no es lo mismo ser intende… "El …
#> 13 2022-01-14 "Los 43,6 grados no alcanzaron para el récord, pero la marc… "Mar…
#> 14 2022-01-14 "Cortaron 20 metros de un cableado de teléfonos: los detuvi… "Est…
#> 15 2022-01-14 "Hospitalizaron a un nene de 4 años que tomó aguarrás por e… "Est…
#> 16 2022-01-14 "Arrestaron a un hombre tras robar una moto estacionada en … "Un …
#> 17 2022-01-14 "Atropellaron a un hombre que se manifestaba por los cortes… "Un …
#> 18 2022-01-14 "Pérdidas totales en el incendio de una casa en Spurr"       "Una…
#> 19 2022-01-14 "Caluroso, pero no tanto como ayer: así estará el tiempo es… "Des…
#> 20 2022-01-13 "Se prendió fuego una subestación de EDES en pleno centro"   "Una…

# Cargamos el diccionario de conflictos de SISMOS
dicc_confl_sismos <- acep_diccionarios$dicc_confl_sismos

# Con la función acep_frec() contamos la frecuencia de palabras de cada nota y creamos una
# nueva columna llamada  n_palabras
la_nueva$n_palabras <- acep_frec(la_nueva$nota)

# Imprimimos en pantalla la base con la nueva columna de frecuencia de palabras
head(la_nueva, 20) |> tibble::as_tibble()
#> # A tibble: 20 × 4
#>    fecha      titulo                                            nota  n_palabras
#>    <date>     <chr>                                             <chr>      <int>
#>  1 2022-01-15 "Llevan 36 horas sin energía por un cable suelto… "Vec…        208
#>  2 2022-01-15 "Explotó un generador que EDES colocó en el cent… "Mom…         97
#>  3 2022-01-15 "Amenazaron a trabajadores de ABSA en el barrio … "Tra…        176
#>  4 2022-01-15 "Intenso calor y falta de lluvia, el combo ideal… "Las…        815
#>  5 2022-01-15 "Investigan un incendio que destruyó un automóvi… "La …        115
#>  6 2022-01-15 "Con la ola de contagios, ¿cuándo vuelven las cl… "Por…        742
#>  7 2022-01-15 "Pavimento que estalla: ¿a qué se deben las rotu… "Aud…        810
#>  8 2022-01-15 "¿Cuánto falta para que la pandemia llegue a su … "Aud…       1029
#>  9 2022-01-14 "Vecinos del barrio Patagonia piden que avance u… "La …        274
#> 10 2022-01-14 "Otra renuncia en el Municipio: se va Karina Mah… "La …        112
#> 11 2022-01-14 "Bomberos tuvieron que apagar un incendio en un … "Bom…         73
#> 12 2022-01-14 "Romera: \"Dichiara se equivoca, no es lo mismo … "El …        428
#> 13 2022-01-14 "Los 43,6 grados no alcanzaron para el récord, p… "Mar…        689
#> 14 2022-01-14 "Cortaron 20 metros de un cableado de teléfonos:… "Est…        146
#> 15 2022-01-14 "Hospitalizaron a un nene de 4 años que tomó agu… "Est…        109
#> 16 2022-01-14 "Arrestaron a un hombre tras robar una moto esta… "Un …        121
#> 17 2022-01-14 "Atropellaron a un hombre que se manifestaba por… "Un …        208
#> 18 2022-01-14 "Pérdidas totales en el incendio de una casa en … "Una…        123
#> 19 2022-01-14 "Caluroso, pero no tanto como ayer: así estará e… "Des…        167
#> 20 2022-01-13 "Se prendió fuego una subestación de EDES en ple… "Una…         67
```
