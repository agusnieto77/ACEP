# Coleccion de notas y recursos de prueba

Lista con fuentes de datos y muestras preprocesadas utilizadas en los
ejemplos del paquete. Incluye enlaces de descarga para distintos
portales, resumenes estadisticos y conjuntos anotados manualmente que
permiten evaluar diccionarios, extraccion de tripletes y desempeno de
modelos generativos.

## Usage

``` r
data(acep_bases)
```

## Format

Lista con 11 objetos:

- la_nueva:

  URL para descargar una muestra del corpus de notas del diario La Nueva
  Provincia de Bahia Blanca.

- rev_puerto:

  URL para descargar el corpus de notas de Revista Puerto.

- rp_procesada:

  data frame con indicadores de conflictividad construidos a partir de
  Revista Puerto.

- lc_mdp:

  URL para descargar el corpus de notas del diario La Capital (Mar del
  Plata).

- rp_mdp:

  URL para descargar el corpus de notas de Revista Puerto (edicion Mar
  del Plata).

- ed_neco:

  URL para descargar el corpus de notas del diario Ecos Diarios
  (Necochea).

- ln_bb:

  URL para descargar el corpus de notas de La Nueva (Bahia Blanca).

- ln_arg:

  URL para descargar un subconjunto de notas de La Nacion.

- lc_720:

  data frame con 720 notas de La Capital publicadas entre 2016 y 2019,
  curado y documentado por Guillermina Laitano. Contiene etiquetas
  binarias manuales que permiten evaluar el diccionario de
  conflictividad, la extraccion de tripletes semanticos y la capacidad
  de distintos modelos generativos para tareas de clasificacion binaria
  y extraccion estructurada de eventos de protesta.

- spacy_postag:

  data frame con una oracion procesada con spacyr que sirve como ejemplo
  para funciones de dependencias y SVO.

- titulares:

  vector con titulares sinteticos referidos a conflictos sociales.

## Source

[Revista Puerto](https://revistapuerto.com.ar/)

[La Nueva](https://www.lanueva.com/)

## References

Nieto, Agustin 2020 "Intersecciones entre historia digital e historia
social: un ejercicio de lectura distante sobre la conflictividad
maritima en la historia argentina reciente". Drassana: revista del Museu
Maritim (28):122-42. ([Revista
Drassana](https://observatoriodeconflictividad.org/nietohd.pdf))

## Examples

``` r
acep_bases$rp_procesada[1:6, ]
#> # A tibble: 6 × 4
#>   fecha      n_palabras conflictos intensidad
#>   <date>          <int>      <int>      <dbl>
#> 1 2020-12-29         31          0     0     
#> 2 2020-12-28       1128          4     0.0035
#> 3 2020-12-24        530          0     0     
#> 4 2020-12-24        483          3     0.0062
#> 5 2020-12-23        525          1     0.0019
#> 6 2020-12-23        462          0     0     
```
