# FASE 1: LIMPIEZA Y CONSOLIDACIÓN - Plan de Refactorización

**Fecha**: 2025-10-28
**Objetivo**: Eliminar código redundante, deprecar funciones obsoletas y estandarizar manejo de errores

---

## 1. FUNCIONES HELPER CREADAS

### Archivo: `R/utils_validation.R`

✅ **COMPLETADO** - Se crearon 7 funciones de validación:

- `validate_character(x, arg_name, allow_null)` - Validación de vectores de texto
- `validate_numeric(x, arg_name, min, max, allow_null)` - Validación numérica con rangos
- `validate_logical(x, arg_name)` - Validación de booleanos
- `validate_dataframe(df, required_cols, arg_name)` - Validación de estructura de data.frames
- `validate_date(x, arg_name)` - Validación de vectores Date
- `validate_choice(x, choices, arg_name)` - Validación de opciones permitidas

**Beneficios**:
- Reducción de ~100+ líneas de código duplicado
- Mensajes de error consistentes y más informativos
- Uso de `stop()` en lugar de `return(message())` para errores críticos

---

## 2. FUNCIONES A REFACTORIZAR CON HELPERS

### 2.1. Refactorizar validaciones en funciones existentes

| Función | Archivo | Cambio Required | Prioridad |
|---------|---------|-----------------|-----------|
| `acep_frec()` | R/acep_frec.R | Reemplazar validación manual por `validate_character(x, "x")` | Alta |
| `acep_count()` | R/acep_count.R | Reemplazar validaciones por `validate_character()` | Alta |
| `acep_detect()` | R/acep_detect.R | Usar `validate_character()`, `validate_logical()`, `validate_numeric()` | Alta |
| `acep_int()` | R/acep_int.R | Usar `validate_numeric()` con parámetro min=0 | Alta |
| `acep_cleaning()` | R/acep_cleaning.R | Consolidar 14 validaciones booleanas con loop | Alta |
| `acep_sst()` | R/acep_sst.R | Usar `validate_dataframe()` con required_cols | Media |
| `acep_svo()` | R/acep_svo.R | Agregar validaciones al inicio | Media |
| `acep_postag()` | R/acep_postag.R | Agregar validaciones al inicio | Media |
| `acep_context()` | R/acep_context.R | Agregar validaciones al inicio | Baja |

**Ejemplo de refactorización** (`acep_frec.R`):

**ANTES**:
```r
acep_frec <- function(x) {
  if(!is.character(x) || is.list(x)){
    return(message("No ingresaste un vector de texto.
           Vuelve a intentarlo ingresando un vector de texto!"))
  } else {
    out <- tryCatch({ str_count(x, "\\S+") })
    return(out)
  }
}
```

**DESPUÉS**:
```r
acep_frec <- function(x) {
  validate_character(x, "x")
  str_count(x, "\\S+")
}
```

---

## 3. FUNCIONES DEPRECATED A ELIMINAR

### 3.1. `acep_clean()` → Reemplazada por `acep_cleaning()`

**Archivo**: `R/acep_clean.R`

**Problemas**:
- Descarga recursos externos repetidamente (tildes.rds, sintildes.rds, emojis.txt, etc.)
- Muy lenta comparada con `acep_cleaning()`
- 140 líneas de código

**Estrategia**:
1. ~~Eliminar completamente el archivo~~ ❌ **NO RECOMENDADO** (breaking change)
2. ✅ **Agregar deprecation warning** y redirigir a `acep_cleaning()`

**Implementación**:
```r
acep_clean <- function(...) {
  .Deprecated("acep_cleaning",
              msg = paste("La función 'acep_clean()' está deprecada y será eliminada en una futura versión.\n",
                         "Por favor use 'acep_cleaning()' que es significativamente más rápida.\n",
                         "Ver vignette 'rendimiento_funciones_acep' para comparación de tiempos."))
  acep_cleaning(...)
}
```

**Archivos a actualizar**:
- `R/acep_clean.R` - Agregar deprecation wrapper
- `man/acep_clean.Rd` - Agregar nota de deprecación
- `README.md` - Actualizar ejemplos para usar `acep_cleaning()`
- `vignettes/limpieza_de_texto_con_acep.Rmd` - Usar `acep_cleaning()` en ejemplos
- `tests/testthat/test-acep_clean.R` - Agregar test de deprecation warning

### 3.2. `acep_men()` → Reemplazada por `acep_count()`

**Archivo**: `R/acep_men.R`

**Problemas**:
- Usa `sapply()` con `gregexpr()` (más lento)
- `acep_count()` usa `stringr::str_count()` (vectorizado)
- Nombres de parámetros inconsistentes (x, y vs texto, dic)

**Estrategia**:
1. ✅ **Agregar deprecation warning** y redirigir a `acep_count()`

**Implementación**:
```r
acep_men <- function(x, y, tolower = TRUE) {
  .Deprecated("acep_count",
              msg = paste("La función 'acep_men()' está deprecada y será eliminada en una futura versión.\n",
                         "Por favor use 'acep_count(texto, dic)' que es más rápida y tiene nombres de parámetros más claros."))

  # Si tolower=FALSE, necesitamos ajustar el texto antes de pasar a acep_count
  if (!tolower) {
    warning("El parámetro 'tolower' no es soportado en acep_count(). El texto será procesado en minúsculas.")
  }

  acep_count(texto = x, dic = y)
}
```

**Archivos a actualizar**:
- `R/acep_men.R` - Agregar deprecation wrapper
- `R/acep_db.R` - Ya usa `acep_count()` internamente ✅
- `R/acep_count.R` - Verificar que el ejemplo en @examples no use `acep_men()`
- `man/acep_men.Rd` - Agregar nota de deprecación
- `README.md` - Reemplazar `acep_men()` por `acep_count()`
- `tests/testthat/test-acep_men.R` - Agregar test de deprecation warning

### 3.3. `acep_rst()` → Reemplazada por `acep_sst()`

**Archivo**: `R/acep_rst.R`

**Problemas**:
- Requiere pasar 4 parámetros individuales (datos, fecha, frecp, frecm)
- `acep_sst()` simplificó a solo 1 parámetro (datos) + opcionales
- Más propensa a errores por desalineación de vectores
- 107 líneas de código

**Estrategia**:
1. ✅ **Agregar deprecation warning** y redirigir a `acep_sst()`

**Implementación**:
```r
acep_rst <- function(datos, fecha, frecp, frecm, st = "mes", u = 2, d = 4) {
  .Deprecated("acep_sst",
              msg = paste("La función 'acep_rst()' está deprecada y será eliminada en una futura versión.\n",
                         "Por favor use 'acep_sst(datos, st, u, d)' que simplifica los parámetros.\n",
                         "El data frame 'datos' debe contener las columnas: fecha, n_palabras, conflictos, intensidad."))

  # Llamar a acep_sst asumiendo que datos ya tiene la estructura correcta
  acep_sst(datos = datos, st = st, u = u, d = d)
}
```

**Archivos a actualizar**:
- `R/acep_rst.R` - Agregar deprecation wrapper
- `R/acep_plot_rst.R` - Ya usa `acep_sst()` internamente? Verificar
- `man/acep_rst.Rd` - Agregar nota de deprecación
- `README.md` - Reemplazar ejemplos con `acep_sst()`
- `tests/testthat/test-acep_rst.R` - Agregar test de deprecation warning

---

## 4. ESTANDARIZACIÓN DE MANEJO DE ERRORES

### 4.1. Reglas de uso de mensajes

| Tipo | Cuándo usar | Función R | Comportamiento |
|------|-------------|-----------|----------------|
| **Error** | Parámetro inválido, operación imposible | `stop(..., call.=FALSE)` | Detiene ejecución |
| **Warning** | Operación puede continuar pero con advertencia | `warning()` | Continúa ejecución |
| **Message** | Información de progreso (verbose) | `message()` | Solo informativo |

### 4.2. Problemas actuales a corregir

**Problema 1**: Uso de `return(message(...))` en lugar de `stop()`

**INCORRECTO** (no detiene ejecución, retorna NULL implícitamente):
```r
if (!is.character(x)) {
  return(message("Error: x debe ser character"))
}
```

**CORRECTO**:
```r
if (!is.character(x)) {
  stop("El parámetro 'x' debe ser un vector de texto (character)", call. = FALSE)
}
```

**Problema 2**: Mensajes de error poco informativos

**INCORRECTO**:
```r
message("No ingresaste un vector. Vuelve a intentarlo!")
```

**CORRECTO**:
```r
stop(sprintf("El parámetro '%s' debe ser un vector de texto (character).\nRecibido: %s",
             arg_name, class(x)[1]),
     call. = FALSE)
```

**Problema 3**: `tryCatch` sin manejo de errores

**INCORRECTO**:
```r
out <- tryCatch({ some_operation(x) })
```

**CORRECTO**:
```r
out <- tryCatch(
  { some_operation(x) },
  error = function(e) {
    stop(sprintf("Error al procesar: %s", e$message), call. = FALSE)
  }
)
```

---

## 5. ACTUALIZACIÓN DE DOCUMENTACIÓN

### 5.1. Archivos man/ a actualizar

Agregar sección de deprecación en:
- `man/acep_clean.Rd`
- `man/acep_men.Rd`
- `man/acep_rst.Rd`

**Formato**:
```
\note{
  \strong{DEPRECATED}: Esta función está deprecada y será eliminada en una futura versión.
  Por favor use \code{\link{acep_cleaning}} en su lugar.
}
```

### 5.2. README.md y README.Rmd

- Reemplazar todos los ejemplos de `acep_clean()` → `acep_cleaning()`
- Reemplazar todos los ejemplos de `acep_men()` → `acep_count()`
- Reemplazar todos los ejemplos de `acep_rst()` → `acep_sst()`

### 5.3. Vignettes a actualizar

- `vignettes/limpieza_de_texto_con_acep.Rmd` - Usar `acep_cleaning()`
- `vignettes/rendimiento_funciones_acep.Rmd` - Ya compara `acep_clean()` vs `acep_cleaning()` ✅

---

## 6. ACTUALIZACIÓN DE TESTS

### 6.1. Tests de deprecation warnings

Crear tests que verifiquen que las funciones deprecated lanzan warnings apropiados:

**Archivo**: `tests/testthat/test-deprecated.R` (NUEVO)

```r
test_that("acep_clean() shows deprecation warning", {
  expect_warning(
    acep_clean("texto de prueba"),
    regexp = "deprecada.*acep_cleaning"
  )
})

test_that("acep_men() shows deprecation warning", {
  expect_warning(
    acep_men("texto", c("palabra")),
    regexp = "deprecada.*acep_count"
  )
})

test_that("acep_rst() shows deprecation warning", {
  datos <- data.frame(
    fecha = as.Date("2024-01-01"),
    n_palabras = 100,
    conflictos = 5,
    intensidad = 0.05
  )
  expect_warning(
    acep_rst(datos, datos$fecha, datos$n_palabras, datos$conflictos),
    regexp = "deprecada.*acep_sst"
  )
})
```

### 6.2. Tests de validación con helpers

**Archivo**: `tests/testthat/test-utils_validation.R` (NUEVO)

```r
test_that("validate_character() rejects non-character input", {
  expect_error(validate_character(123, "x"), regexp = "debe ser un vector de texto")
  expect_error(validate_character(list("a"), "x"), regexp = "debe ser un vector de texto")
})

test_that("validate_character() accepts valid input", {
  expect_silent(validate_character("texto", "x"))
  expect_silent(validate_character(c("texto1", "texto2"), "x"))
})

test_that("validate_numeric() rejects non-numeric input", {
  expect_error(validate_numeric("123", "x"), regexp = "debe ser numérico")
})

test_that("validate_numeric() enforces min/max", {
  expect_error(validate_numeric(5, "x", min = 10), regexp = ">= 10")
  expect_error(validate_numeric(15, "x", max = 10), regexp = "<= 10")
})

# ... más tests ...
```

---

## 7. VERIFICACIÓN FINAL

### 7.1. Comandos a ejecutar

```r
# En R:
library(devtools)

# 1. Cargar todo
load_all()

# 2. Ejecutar tests
test()

# 3. Verificar documentación
document()

# 4. Verificar paquete completo
check()

# 5. Instalar localmente
install()
```

### 7.2. Checklist de verificación

- [ ] Todas las funciones helper están documentadas con `@keywords internal` y `@noRd`
- [ ] Las 3 funciones deprecated muestran warnings apropiados
- [ ] Los tests pasan (al menos los existentes no se rompen)
- [ ] `R CMD check` no muestra errores (warnings de deprecation son OK)
- [ ] README.md no menciona funciones deprecated en ejemplos principales
- [ ] Vignettes compilansin errores

---

## 8. MÉTRICAS DE ÉXITO

### Antes de FASE 1:
- **LOC total**: ~2,034 líneas
- **Funciones exportadas**: 25 (incluyendo 3 deprecated)
- **Validaciones duplicadas**: ~100+ líneas
- **Funciones con manejo inconsistente de errores**: ~15

### Después de FASE 1:
- **LOC total**: ~1,850 líneas (-9%)
- **Funciones exportadas**: 22 activas + 3 deprecated
- **Validaciones duplicadas**: 0 (todas usan helpers)
- **Funciones con manejo inconsistente de errores**: 0

### Reducción estimada de código:
- Validaciones eliminadas: -100 líneas
- Simplificación de lógica: -84 líneas
- Helpers añadidos: +~170 líneas
- **Neto**: -184 líneas de código

---

## 9. RIESGOS Y MITIGACIONES

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Breaking changes para usuarios existentes | Media | Alto | Usar `.Deprecated()` en lugar de eliminar funciones |
| Tests fallan después de refactorización | Media | Medio | Ejecutar tests incrementalmente después de cada cambio |
| Mensajes de error rompen código que los captura | Baja | Medio | Mantener formato de mensaje similar |
| Validaciones muy estrictas | Baja | Bajo | Agregar parámetro `allow_null` donde sea apropiado |

---

## 10. PRÓXIMOS PASOS (POST-FASE 1)

Una vez completada la FASE 1, proceder con:

1. **FASE 2**: Optimización de rendimiento
   - Refactorizar `acep_context()` (eliminar bucles anidados)
   - Refactorizar `acep_svo()` (consolidar código repetido)
   - Precompilar regex frecuentes

2. **FASE 3**: Mejora de arquitectura
   - Crear clases `acep_corpus` y `acep_result`
   - Implementar sistema de pipeline

---

**Fin del documento de estrategia FASE 1**
