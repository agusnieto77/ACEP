# Interaccion con modelos de IA usando OpenRouter

Funcion para interactuar con multiples proveedores de IA (OpenAI,
Anthropic, Google, Meta, etc.) a traves de la API unificada de
OpenRouter. Soporta Structured Outputs para modelos compatibles (OpenAI
GPT-4o+, Fireworks, y otros). OpenRouter normaliza las diferencias entre
proveedores, permitiendo acceder a 400+ modelos con una sola API. Ideal
para comparar modelos o usar fallbacks automaticos.

## Usage

``` r
acep_openrouter(
  texto,
  instrucciones,
  modelo = "openai/gpt-4o-mini",
  api_key = Sys.getenv("OPENROUTER_API_KEY"),
  schema = NULL,
  parse_json = TRUE,
  temperature = 0,
  max_tokens = 2000,
  top_p = 0.2,
  app_name = NULL,
  site_url = NULL,
  use_fallback = FALSE,
  fallback_provider_order = NULL,
  fallback_models = NULL
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

  Modelo a utilizar con formato "proveedor/modelo". Ejemplos
  populares: - OpenAI: \`"openai/gpt-4o-mini"\` (rapido y economico),
  \`"openai/gpt-4o"\` (potente) - Anthropic:
  \`"anthropic/claude-sonnet-4.5"\`, \`"anthropic/claude-3.5-haiku"\` -
  Google: \`"google/gemini-2.5-flash"\`,
  \`"google/gemini-2.0-flash-001"\` - Meta:
  \`"meta-llama/llama-3.3-70b-instruct"\`,
  \`"meta-llama/llama-4-maverick:free"\` - Qwen:
  \`"qwen/qwen3-next-80b-a3b-instruct-2509"\` - DeepSeek:
  \`"deepseek/deepseek-chat-v3-0324:free"\`,
  \`"deepseek/deepseek-r1:free"\` Por defecto: \`"openai/gpt-4o-mini"\`.
  Ver lista completa: https://openrouter.ai/models

- api_key:

  Clave de API de OpenRouter. Si no se proporciona, busca la variable de
  entorno \`OPENROUTER_API_KEY\`. Para obtener una clave:
  https://openrouter.ai/settings/keys

- schema:

  Esquema JSON que define la estructura de la respuesta. Puede usar
  \`acep_gpt_schema()\` para obtener esquemas predefinidos o crear uno
  personalizado. Si es \`NULL\`, usa un esquema simple con campo
  "respuesta". NOTA: Structured Outputs solo funciona con modelos
  compatibles (OpenAI GPT-4o+, Fireworks). Para otros modelos, se usara
  JSON mode basico.

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

- app_name:

  Nombre de tu aplicacion (opcional). Se muestra en
  openrouter.ai/activity.

- site_url:

  URL de tu aplicacion (opcional). Para estadisticas en OpenRouter.

- use_fallback:

  Logico. Si \`TRUE\`, OpenRouter usara modelos alternativos si el
  proveedor primario falla. Por defecto: FALSE (sin fallbacks).

- fallback_provider_order:

  Vector opcional de slugs de proveedores para forzar un orden
  especifico de enrutamiento (ej.: \`c("openai", "anthropic")\`).
  Requiere \`use_fallback = TRUE\` para habilitar intentos sucesivos.

- fallback_models:

  Vector opcional de modelos alternativos (en formato
  \`"proveedor/modelo"\`) que se probaran en orden si el modelo
  principal devuelve un error recuperable (429, 5xx, timeouts). Ideal
  para definir variantes pagas cuando la version \`:free\` alcance su
  limite.

## Value

Si \`parse_json=TRUE\`, devuelve una lista o data frame con la respuesta
estructurada segun el esquema. Si \`parse_json=FALSE\`, devuelve un
string JSON.

## Details

OpenRouter abstrae las diferencias entre proveedores, mapeando
automaticamente los parametros a la interfaz nativa de cada modelo. Los
parametros no soportados por un modelo son ignorados silenciosamente.
Esto permite usar la misma funcion para cualquier modelo sin preocuparse
por las especificidades de cada API.

Cuando \`use_fallback = TRUE\`, la funcion configura el objeto
\`provider\` de OpenRouter para conservar la resiliencia ante errores
transitorios y, si se define \`fallback_models\`, intenta llamar
secuencialmente a cada modelo alternativo ante codigos recuperables
(429, 5xx, timeouts). Esto evita depender del campo \`route\`, ya
deprecado en la API.

Para Structured Outputs estrictos, recomendamos usar modelos OpenAI
(gpt-4o+) o Fireworks. Otros modelos intentaran seguir el esquema pero
sin garantias estrictas.

## MODELOS COMPATIBLES Y PROBADOS (ACTUALIZADO)

### OpenAI - Familia GPT-5 (Ultima Generacion)

- `openai/gpt-5` - Modelo principal GPT-5

- `openai/gpt-5-pro` - Version Pro, maxima precision

- `openai/gpt-5-mini` - Version mini, economica

- `openai/gpt-5-nano` - Version nano, ultrarrapida

- `openai/gpt-5-chat` - Optimizado para chat

### OpenAI - Familia GPT-4.1

- `openai/gpt-4.1` - Modelo principal GPT-4.1

- `openai/gpt-4.1-mini` - Version mini

- `openai/gpt-4.1-nano` - Version nano

### OpenAI - Familia GPT-4

- `openai/gpt-4o` - GPT-4 optimizado

- `openai/gpt-4o-mini` - Economico, rapido, ideal para produccion

- `openai/gpt-4-turbo` - Version turbo

- `openai/gpt-4` - Modelo base GPT-4

### OpenAI - Familia GPT-3.5

- `openai/gpt-3.5-turbo` - Version turbo, economica

### OpenAI - Modelos OSS (Open Source Style)

- `openai/gpt-oss-120b` - Modelo grande (120B parametros)

- `openai/gpt-oss-120b:exacto` - Version exacta

- `openai/gpt-oss-20b` - Modelo pequeno (20B parametros)

- `openai/gpt-oss-20b:free` - Version gratuita

### xAI - Familia Grok 4 (Ultima Generacion)

- `x-ai/grok-4` - Modelo principal Grok 4

- `x-ai/grok-4-fast` - Version rapida, optimizada

### xAI - Familia Grok 3

- `x-ai/grok-3` - Modelo principal Grok 3

- `x-ai/grok-3-mini` - Version mini, economica

- `x-ai/grok-3-beta` - Version beta

- `x-ai/grok-3-mini-beta` - Version mini beta

### DeepSeek - Familia V3 (Ultima Generacion)

- `deepseek/deepseek-v3.2-exp` - Version experimental 3.2

- `deepseek/deepseek-v3.1-terminus` - Version terminus 3.1

- `deepseek/deepseek-v3.1-terminus:exacto` - Version terminus exacta

### DeepSeek - Familia R1 (Razonamiento)

- `deepseek/deepseek-r1-0528` - Version R1 de mayo 2028

- `deepseek/deepseek-r1` - Modelo principal R1

- `deepseek/deepseek-r1:free` - Version R1 gratuita

### DeepSeek - R1 Distilled (Basado en Llama)

- `deepseek/deepseek-r1-distill-llama-70b` - R1 destilado en Llama 70B

- `deepseek/deepseek-r1-distill-llama-70b:free` - Version gratuita

### DeepSeek - Chat y Otros

- `deepseek/deepseek-chat` - Optimizado para chat

### DeepCogito - Modelos Especializados

- `deepcogito/cogito-v2-preview-deepseek-671b` - Modelo cogito 671B
  basado en DeepSeek

### Meta Llama - Familia 4

- `meta-llama/llama-4-maverick` - Llama 4 Maverick

### Meta Llama - Familia 3.3

- `meta-llama/llama-3.3-70b-instruct` - Version de pago

- `meta-llama/llama-3.3-70b-instruct:free` - Version gratuita

### Meta Llama - Familia 3.2

- `meta-llama/llama-3.2-90b-vision-instruct` - Con capacidades de vision

### Meta Llama - Familia 3.1

- `meta-llama/llama-3.1-405b-instruct` - Modelo grande 405B

- `meta-llama/llama-3.1-70b-instruct` - Modelo mediano 70B

### NousResearch - Modelos Hermes

- `nousresearch/hermes-3-llama-3.1-405b` - Hermes 3 basado en Llama 405B

### Mistral AI - Familia Magistral

- `mistralai/magistral-medium-2506` - Magistral medium

- `mistralai/magistral-medium-2506:thinking` - Con razonamiento
  extendido

### Mistral AI - Otros Modelos

- `mistralai/mistral-large-2407` - Mistral large

- `mistralai/mixtral-8x22b-instruct` - Mixtral 8x22B (MoE)

### MoonshotAI - Familia Kimi K2

- `moonshotai/kimi-k2` - Modelo principal Kimi K2

- `moonshotai/kimi-k2-0905` - Version 09/05

- `moonshotai/kimi-k2-0905:exacto` - Version exacta

- `moonshotai/kimi-k2-thinking` - Con razonamiento extendido

### Qwen - Familia Qwen3 (235B - Modelos Grandes)

- `qwen/qwen3-235b-a22b-2507` - Modelo grande 235B (version 2507)

- `qwen/qwen3-235b-a22b` - Modelo grande 235B

- `qwen/qwen3-235b-a22b-thinking-2507` - Con razonamiento extendido

- `qwen/qwen3-max` - Version maxima

### Qwen - Familia Qwen3 (30B-80B - Modelos Medianos)

- `qwen/qwen3-next-80b-a3b-instruct` - Modelo next 80B

- `qwen/qwen3-32b` - Modelo 32B

- `qwen/qwen3-30b-a3b` - Modelo 30B

- `qwen/qwen3-30b-a3b-instruct-2507` - Version instruct 2507

- `qwen/qwen3-30b-a3b:free` - Version 30B gratuita

### Qwen - Familia Qwen3 (Modelos Pequenos)

- `qwen/qwen3-14b:free` - Modelo 14B gratuito

- `qwen/qwen3-4b:free` - Modelo 4B gratuito, ultrarrapido

### Qwen - Familia Qwen 2.5

- `qwen/qwen-2.5-72b-instruct` - Modelo 2.5 generacion anterior

- `qwen/qwen-plus` - Version plus

### Google Gemini - Familia 2.5 (Ultima Generacion)

- `google/gemini-2.5-flash` - Rapido, ultima generacion

- `google/gemini-2.5-pro` - Mayor precision, ultima generacion

- `google/gemini-2.5-flash-lite` - Ultrarrapido, ligero

- `google/gemini-2.5-flash-preview-09-2025` - Preview version septiembre

- `google/gemini-2.5-flash-lite-preview-09-2025` - Preview lite
  septiembre

### Google Gemini - Familia 2.0

- `google/gemini-2.0-flash-001` - Version estable 2.0

- `google/gemini-2.0-flash-lite-001` - Version ligera 2.0

### Google Gemini - Familia 1.5

- `google/gemini-pro-1.5` - Version anterior, estable

### Anthropic Claude - Familia Haiku (Rapidos y Economicos)

- `anthropic/claude-3.5-haiku` - Version 3.5, muy rapido

- `anthropic/claude-3-haiku` - Version 3, economico

- `anthropic/claude-haiku-4.5` - Ultima version, mas preciso

### Anthropic Claude - Familia Sonnet (Equilibrados)

- `anthropic/claude-3.5-sonnet` - Popular, buen balance

- `anthropic/claude-3.7-sonnet` - Version mejorada

- `anthropic/claude-3.7-sonnet:thinking` - Con razonamiento extendido

- `anthropic/claude-sonnet-4` - Generacion 4

- `anthropic/claude-sonnet-4.5` - Ultima version, mas preciso

### Anthropic Claude - Familia Opus (Maxima Precision)

- `anthropic/claude-3-opus` - Version 3, muy preciso

- `anthropic/claude-opus-4` - Generacion 4

- `anthropic/claude-opus-4.1` - Ultima version disponible

\*\*Importante:\*\* los modelos etiquetados como \`:free\` operan con
cuotas comunitarias y suelen estar sometidos a limites de tasa estrictos
por parte de OpenRouter. Es frecuente recibir respuestas HTTP 429 (Too
Many Requests) cuando la demanda supera la cuota disponible; este codigo
indica que el proveedor rechazo la peticion para proteger la
infraestructura compartida. Si ocurre, espera unos segundos y reintenta,
o selecciona la variante de pago equivalente (sin sufijo \`:free\`) o
activa \`use_fallback\` para que OpenRouter cambie automaticamente a un
modelo disponible.

## Examples

``` r
if (FALSE) { # \dontrun{
# Configurar API key
Sys.setenv(OPENROUTER_API_KEY = "tu-api-key")

# Usar GPT-4o mini (rapido y economico)
texto <- "El SUTEBA convoco a un paro en Buenos Aires el 15 de marzo."
resultado <- acep_openrouter(texto, "Extrae las entidades nombradas",
                              modelo = "openai/gpt-4o-mini",
                              schema = acep_gpt_schema("extraccion_entidades"))

# Comparar con Claude
resultado_claude <- acep_openrouter(texto, "Extrae las entidades nombradas",
                                     modelo = "anthropic/claude-sonnet-4.5",
                                     schema = acep_gpt_schema("extraccion_entidades"))

# Usar modelo gratuito
resultado_free <- acep_openrouter(texto, "Clasifica el sentimiento",
                                   modelo = "meta-llama/llama-4-maverick:free",
                                   schema = acep_gpt_schema("sentimiento"))

# Definir fallback hacia variantes pagas o proveedores alternativos
resultado_resiliente <- acep_openrouter(
  texto,
  "Extrae las entidades nombradas",
  modelo = "meta-llama/llama-4-maverick:free",
  schema = acep_gpt_schema("extraccion_entidades"),
  use_fallback = TRUE,
  fallback_models = c("meta-llama/llama-4-maverick", "openai/gpt-4o-mini")
)

} # }
```
