# Interaccion con modelos Gemini usando Structured Outputs

Funcion para interactuar con la API de Google Gemini utilizando
Structured Outputs nativos. Gemini soporta generacion de JSON
estructurado mediante el parametro \`responseSchema\` que garantiza que
las respuestas cumplan con el esquema definido. Compatible con todos los
modelos Gemini 2.5 y Gemini 2.0. Acceso gratuito para uso limitado
disponible en Google AI Studio.

## Usage

``` r
acep_gemini(
  texto,
  instrucciones,
  modelo = "gemini-2.5-flash",
  api_key = Sys.getenv("GEMINI_API_KEY"),
  schema = NULL,
  parse_json = TRUE,
  temperature = 0,
  max_tokens = 2000,
  top_p = 0.95,
  top_k = 40
)
```

## Arguments

- texto:

  Texto a analizar con Gemini. Puede ser una noticia, tweet, documento,
  etc.

- instrucciones:

  Instrucciones en lenguaje natural que indican al modelo que hacer con
  el texto. Ejemplo: "Extrae todas las entidades nombradas", "Clasifica
  el sentimiento".

- modelo:

  Modelo de Gemini a utilizar. Opciones recomendadas: - Gemini 2.5:
  \`"gemini-2.5-flash"\` (rapido, multimodal, por defecto),
  \`"gemini-2.5-flash-lite"\` (mas economico), \`"gemini-2.5-pro"\` (mas
  potente) - Gemini 2.0: \`"gemini-2.0-flash"\`,
  \`"gemini-2.0-flash-lite"\` Por defecto: \`"gemini-2.5-flash"\`. Ver:
  https://ai.google.dev/gemini-api/docs/models

- api_key:

  Clave de API de Google Gemini. Si no se proporciona, busca la variable
  de entorno \`GEMINI_API_KEY\`. Para obtener una clave:
  https://aistudio.google.com/apikey

- schema:

  Esquema JSON que define la estructura de la respuesta. Puede usar
  \`acep_gpt_schema()\` para obtener esquemas predefinidos o crear uno
  personalizado. Si es \`NULL\`, usa un esquema simple con campo
  "respuesta". NOTA: Gemini usa un subconjunto de OpenAPI 3.0 Schema
  para definir estructuras.

- parse_json:

  Logico. Si \`TRUE\` (por defecto), parsea automaticamente el JSON a un
  objeto R (lista o data frame). Si \`FALSE\`, devuelve el JSON como
  string.

- temperature:

  Parametro de temperatura (0-2). Valores bajos (0-0.3) generan
  respuestas mas deterministas. Valores altos (0.7-1) mas creativas. Por
  defecto: 0. Valor recomendado por Google: 1.0.

- max_tokens:

  Numero maximo de tokens en la respuesta. Por defecto: 2000.

- top_p:

  Parametro top-p para nucleus sampling (0-1). Controla la diversidad de
  la respuesta. Por defecto: 0.95 (valor tipico para Gemini).

- top_k:

  Parametro top-k. Limita la seleccion a los K tokens mas probables. Por
  defecto: 40 (valor tipico para Gemini).

## Value

Si \`parse_json=TRUE\`, devuelve una lista o data frame con la respuesta
estructurada segun el esquema. Si \`parse_json=FALSE\`, devuelve un
string JSON.

## Details

La API de Gemini usa un enfoque diferente para structured outputs: -
Define \`responseMimeType: "application/json"\` en
\`generationConfig\` - Usa \`responseSchema\` con formato OpenAPI 3.0
Schema - Soporta tipos: string, integer, number, boolean, array,
object - Campo opcional \`propertyOrdering\` controla orden de
propiedades en respuesta

Diferencias importantes con OpenAI: - No requiere campo
\`additionalProperties: false\` (se maneja automaticamente) - Los campos
son opcionales por defecto (usar \`required\` para campos
obligatorios) - El esquema cuenta como tokens de entrada

## Examples

``` r
if (FALSE) { # \dontrun{
# Configurar API key
Sys.setenv(GEMINI_API_KEY = "tu-api-key")

# Extraer entidades con Gemini 2.5 Flash
texto <- "El SUTEBA convoco a un paro en Buenos Aires el 15 de marzo."
resultado <- acep_gemini(texto, "Extrae las entidades nombradas",
                         schema = acep_gpt_schema("extraccion_entidades"))

# Analisis de sentimiento con modelo economico
resultado <- acep_gemini(texto, "Analiza el sentimiento",
                         modelo = "gemini-2.5-flash-lite",
                         schema = acep_gpt_schema("sentimiento"))

# Usar Gemini 2.0 Flash Lite (mas rapido)
resultado <- acep_gemini(texto, "Extrae entidades",
                         modelo = "gemini-2.0-flash-lite",
                         schema = acep_gpt_schema("extraccion_entidades"))
} # }
```
