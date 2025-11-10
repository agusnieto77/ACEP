# Esquemas JSON predefinidos para analisis de texto con GPT

Proporciona esquemas JSON predefinidos y validados para casos de uso
comunes en analisis de texto con GPT. Estos esquemas garantizan
respuestas estructuradas y consistentes para tareas como extraccion de
entidades, clasificacion, analisis de sentimiento, resumen,
pregunta-respuesta, extraccion de tripletes y analisis de acciones de
protesta.

## Usage

``` r
acep_gpt_schema(tipo = "extraccion_entidades")
```

## Arguments

- tipo:

  Tipo de esquema a devolver. Opciones:

  - `"extraccion_entidades"`: Extrae personas, organizaciones, lugares,
    fechas y eventos

  - `"clasificacion"`: Clasifica el texto en categorias con nivel de
    confianza

  - `"sentimiento"`: Analiza sentimiento general y por aspectos
    especificos

  - `"resumen"`: Genera resumenes cortos y detallados con puntos clave

  - `"qa"`: Responde preguntas con citas textuales y nivel de confianza

  - `"tripletes"`: Extrae relaciones sujeto-predicado-objeto

  - `"protesta_breve"`: Extrae informacion basica de acciones de
    protesta (fecha, sujeto, accion, objeto, lugar)

  - `"protesta_detallada"`: Extrae informacion detallada de multiples
    acciones de protesta con 9 campos por accion

  - `"verdadero_falso"`: Devuelve una respuesta booleana simple (TRUE o
    FALSE) con nivel de confianza (0 a 1) y justificacion opcional

## Value

Lista con esquema JSON compatible con OpenAI Structured Outputs. Puede
usarse directamente en el parametro \`schema\` de \`acep_gpt()\` o
\`acep_ollama()\`.

## Examples

``` r
# Obtener esquema para extraccion de entidades
schema_entidades <- acep_gpt_schema("extraccion_entidades")
names(schema_entidades$properties)  # personas, organizaciones, lugares, fechas, eventos
#> [1] "personas"       "organizaciones" "lugares"        "fechas"        
#> [5] "eventos"       

# Obtener esquema para clasificacion
schema_clasif <- acep_gpt_schema("clasificacion")
names(schema_clasif$properties)  # categoria, confianza, justificacion
#> [1] "categoria"     "confianza"     "justificacion"

# Obtener esquema para analisis de sentimiento
schema_sent <- acep_gpt_schema("sentimiento")
names(schema_sent$properties)  # sentimiento_general, puntuacion, aspectos
#> [1] "sentimiento_general" "puntuacion"          "aspectos"           

# Obtener esquema para analisis breve de protestas
schema_protesta <- acep_gpt_schema("protesta_breve")
names(schema_protesta$properties)  # fecha, sujeto, accion, objeto, lugar
#> [1] "fecha"  "sujeto" "accion" "objeto" "lugar" 

# Obtener esquema para analisis detallado de protestas
schema_protesta_det <- acep_gpt_schema("protesta_detallada")
names(schema_protesta_det$properties)  # acciones (array con 9 campos cada una)
#> [1] "acciones"

# Obtener esquema para respuesta verdadero/falso
schema_bool <- acep_gpt_schema("verdadero_falso")
names(schema_bool$properties)  # respuesta, nivel_confianza, justificacion
#> [1] "respuesta"       "nivel_confianza" "justificacion"  
```
