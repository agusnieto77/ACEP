# Interaccion con modelos de IA usando TogetherAI

Funcion para interactuar con modelos de IA a traves de la API de
TogetherAI. TogetherAI proporciona acceso a modelos open-source de alta
calidad como Llama, Qwen, Mistral, DeepSeek y muchos otros. Soporta JSON
mode para respuestas estructuradas. La API es compatible con el formato
de OpenAI, lo que facilita la integracion.

## Usage

``` r
acep_together(
  texto,
  instrucciones,
  modelo = "meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo",
  api_key = Sys.getenv("TOGETHER_API_KEY"),
  schema = NULL,
  parse_json = TRUE,
  temperature = 0,
  max_tokens = 2000,
  top_p = 0.2,
  top_k = 50,
  repetition_penalty = 1,
  stop = NULL,
  prompt_system = "json"
)
```

## Arguments

- texto:

  Texto a analizar. Puede ser una noticia, tweet, documento, etc.

- instrucciones:

  Instrucciones en lenguaje natural que indican al modelo que hacer con
  el texto. Ejemplo: "Extrae todas las entidades nombradas", "Clasifica
  el sentimiento".

- modelo:

  Modelo a utilizar. Ejemplos populares: - Moonshot:
  \`"moonshotai/Kimi-K2-Instruct-0905"\` (128K context) - Meta Llama:
  \`"meta-llama/Meta-Llama-3.1-405B-Instruct-Turbo"\`,
  \`"meta-llama/Llama-3.3-70B-Instruct-Turbo"\` - Qwen:
  \`"Qwen/Qwen2.5-72B-Instruct-Turbo"\`, \`"Qwen/QwQ-32B-Preview"\` -
  Mistral: \`"mistralai/Mixtral-8x22B-Instruct-v0.1"\`,
  \`"mistralai/Mistral-7B-Instruct-v0.3"\` - DeepSeek:
  \`"deepseek-ai/DeepSeek-V3"\`, \`"deepseek-ai/DeepSeek-R1"\` - Google:
  \`"google/gemma-2-27b-it"\`, \`"google/gemma-2-9b-it"\` Por defecto:
  \`"meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo"\`. Ver lista
  completa: https://docs.together.ai/docs/chat-models

- api_key:

  Clave de API de TogetherAI. Si no se proporciona, busca la variable de
  entorno \`TOGETHER_API_KEY\`. Para obtener una clave:
  https://api.together.xyz/settings/api-keys

- schema:

  Esquema JSON que define la estructura de la respuesta. Puede usar
  \`acep_gpt_schema()\` para obtener esquemas predefinidos o crear uno
  personalizado. Si es \`NULL\`, usa un esquema simple con campo
  "respuesta". NOTA: TogetherAI soporta JSON mode con
  `response_format: {type: "json_object"}` para modelos compatibles.
  Consulta la lista de modelos soportados en:
  https://docs.together.ai/docs/json-mode

- parse_json:

  Logico. Si \`TRUE\` (por defecto), parsea automaticamente el JSON a un
  objeto R (lista o data frame). Si \`FALSE\`, devuelve el JSON como
  string.

- temperature:

  Parametro de temperatura (0-2). Valores bajos (0-0.3) generan
  respuestas mas deterministas. Valores altos (0.7-1) mas creativas. Por
  defecto: 0.

- max_tokens:

  Numero maximo de tokens en la respuesta. Por defecto: 2000.

- top_p:

  Parametro top-p para nucleus sampling (0-1). Por defecto: 0.2.

- top_k:

  Parametro top-k para muestreo. Limita las opciones a los k tokens mas
  probables. Por defecto: 50. Usar 0 o -1 para desactivar.

- repetition_penalty:

  Penalizacion por repeticion de tokens (0.1-2.0). Valores \> 1
  penalizan repeticiones. Por defecto: 1.

- stop:

  Secuencias de parada opcionales. Vector de strings que detienen la
  generacion. Por defecto: NULL.

- prompt_system:

  Prompt del sistema que define el comportamiento del modelo.
  Opciones: - \`"json"\` (por defecto): Usa un prompt estructurado que
  instruye al modelo a responder SOLO en formato JSON siguiendo el
  esquema proporcionado. Agrega
  `response_format: {type: "json_object"}` - \`"texto"\`: Usa un prompt
  simple para respuestas en texto plano sin estructura. Elimina
  automaticamente el contenido de pensamiento (\<think\>...\</think\>)
  de modelos como Qwen3-Thinking - String personalizado: Cualquier texto
  que definas como prompt del sistema

## Value

Si \`parse_json=TRUE\`, devuelve una lista o data frame con la respuesta
estructurada segun el esquema. Si \`parse_json=FALSE\`, devuelve un
string JSON.

## Details

\*\*Sobre TogetherAI:\*\*

TogetherAI es una plataforma especializada en modelos open-source que
ofrece: - Precios competitivos y modelos gratuitos - Alta velocidad de
inferencia optimizada - Acceso a modelos de ultima generacion (Llama,
Qwen, DeepSeek, etc.) - API compatible con formato OpenAI

\*\*JSON Mode:\*\*

La funcion utiliza JSON mode de TogetherAI para obtener respuestas
estructuradas. Cuando \`prompt_system = "json"\`, la funcion: 1. Incluye
el esquema JSON en el prompt del sistema (REQUERIDO por TogetherAI) 2.
Agrega `response_format: {type: "json_object"}` al body de la peticion
3. Instruye explicitamente al modelo a responder SOLO en JSON

Esta combinacion de esquema textual + `response_format` asegura
respuestas JSON validas y consistentes en cada llamada.

\*\*Modelos compatibles con JSON mode:\*\*

Los modelos mas recientes que soportan JSON mode incluyen: - Qwen3,
Qwen2.5 (Instruct, Coder, VL, Thinking) - DeepSeek-R1, DeepSeek-V3 -
Meta Llama 3.1, 3.3, 4 - Mistral 7B Instruct - Google Gemma

Ver lista completa: https://docs.together.ai/docs/json-mode

\*\*Validaciones:\*\*

La funcion incluye validacion de limite de tokens. Si la respuesta es
truncada por \`max_tokens\`, devuelve un mensaje claro indicando que se
necesitan mas tokens.

## Examples

``` r
if (FALSE) { # \dontrun{
# Configurar API key
Sys.setenv(TOGETHER_API_KEY = "tu-api-key")

# Usar Llama 3.1 70B (rapido y potente)
texto <- "El SUTEBA convoco a un paro en Buenos Aires el 15 de marzo."
resultado <- acep_together(texto, "Extrae las entidades nombradas",
                           modelo = "meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo",
                           schema = acep_gpt_schema("extraccion_entidades"))

# Usar Qwen para analisis de sentimiento
resultado_qwen <- acep_together(texto, "Clasifica el sentimiento",
                                modelo = "Qwen/Qwen2.5-72B-Instruct-Turbo",
                                schema = acep_gpt_schema("sentimiento"))

# Usar DeepSeek-V3
resultado_ds <- acep_together(texto, "Analiza el texto",
                              modelo = "deepseek-ai/DeepSeek-V3",
                              schema = acep_gpt_schema("clasificacion"))

# Usar Moonshot Kimi con 128K context
resultado_kimi <- acep_together(texto, "Resume el texto",
                                modelo = "moonshotai/Kimi-K2-Instruct-0905",
                                schema = acep_gpt_schema("resumen"))

# Usar modo texto plano (sin estructura JSON)
resultado_texto <- acep_together(texto, "Resume este texto en una frase",
                                 modelo = "meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo",
                                 prompt_system = "texto",
                                 parse_json = FALSE)
print(resultado_texto)  # Devuelve string de texto plano

# Usar prompt del sistema personalizado
resultado_custom <- acep_together(
  texto,
  "Analiza el sentimiento",
  modelo = "Qwen/Qwen2.5-72B-Instruct-Turbo",
  prompt_system = paste(
    "Eres un experto en analisis de sentimientos politicos.",
    "Se objetivo y neutral."
  ),
  parse_json = FALSE
)
} # }
```
