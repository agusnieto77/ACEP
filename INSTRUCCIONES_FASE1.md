# INSTRUCCIONES PARA EJECUTAR FASE 1

## Paso 1: Abrir RStudio

Abre RStudio y establece el directorio de trabajo en la raíz del paquete ACEP:

```r
setwd("e:/GoogleDriveWD/R/PROYECTOS/R_LIBRERIAS/ACEP")
```

## Paso 2: Instalar dependencias necesarias

Si aún no lo has hecho, instala los paquetes necesarios:

```r
install.packages(c("devtools", "here", "testthat", "roxygen2"))
```

## Paso 3: Ejecutar el script de refactorización

Ejecuta el script que aplicará todos los cambios de FASE 1:

```r
source("refactorizar_fase1.R")
```

Este script:
- Creará backups de todos los archivos originales en `backup_fase1/`
- Refactorizará 7 archivos R con los cambios de FASE 1
- Mostrará un resumen de cambios al finalizar

## Paso 4: Regenerar documentación

Después de ejecutar el script, regenera la documentación:

```r
library(devtools)
document()
```

Esto actualizará los archivos `.Rd` en `man/` y el archivo `NAMESPACE`.

## Paso 5: Ejecutar tests

Verifica que los tests existentes no se hayan roto:

```r
library(devtools)
test()
```

Si algún test falla, revisa el archivo `backup_fase1/` para restaurar el original.

## Paso 6: Crear tests de deprecación

Crea un nuevo archivo `tests/testthat/test-deprecated.R` con el siguiente contenido:

```r
# Tests para funciones deprecated

test_that("acep_clean() muestra warning de deprecación", {
  expect_warning(
    acep_clean("texto de prueba"),
    regexp = "deprecada.*acep_cleaning"
  )
})

test_that("acep_men() muestra warning de deprecación", {
  expect_warning(
    acep_men("texto de prueba", c("palabra")),
    regexp = "deprecada.*acep_count"
  )
})

test_that("acep_rst() muestra warning de deprecación", {
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

test_that("acep_clean() redirige correctamente a acep_cleaning()", {
  texto <- "El SUTEBA fue al paro. Reclaman mejoras salariales."

  suppressWarnings({
    resultado_clean <- acep_clean(texto, rm_punt = FALSE)
  })

  resultado_cleaning <- acep_cleaning(texto, rm_punt = FALSE)

  expect_equal(resultado_clean, resultado_cleaning)
})

test_that("acep_men() redirige correctamente a acep_count()", {
  texto <- c("paro general", "lucha obrera")
  dic <- c("paro", "lucha")

  suppressWarnings({
    resultado_men <- acep_men(texto, dic)
  })

  resultado_count <- acep_count(texto, dic)

  expect_equal(resultado_men, resultado_count)
})
```

Luego ejecuta:

```r
test_file("tests/testthat/test-deprecated.R")
```

## Paso 7: Crear tests para helpers de validación

Crea un nuevo archivo `tests/testthat/test-utils_validation.R`:

```r
# Tests para funciones helper de validación

test_that("validate_character() rechaza input no-character", {
  expect_error(validate_character(123, "x"), regexp = "debe ser un vector de texto")
  expect_error(validate_character(list("a"), "x"), regexp = "debe ser un vector de texto")
})

test_that("validate_character() acepta input válido", {
  expect_silent(validate_character("texto", "x"))
  expect_silent(validate_character(c("texto1", "texto2"), "x"))
})

test_that("validate_numeric() rechaza input no-numérico", {
  expect_error(validate_numeric("123", "x"), regexp = "debe ser numérico")
})

test_that("validate_numeric() valida rangos min/max", {
  expect_error(validate_numeric(5, "x", min = 10), regexp = ">= 10")
  expect_error(validate_numeric(15, "x", max = 10), regexp = "<= 10")
  expect_silent(validate_numeric(10, "x", min = 5, max = 15))
})

test_that("validate_logical() rechaza input no-lógico", {
  expect_error(validate_logical(1, "x"), regexp = "debe ser un valor lógico")
  expect_error(validate_logical("TRUE", "x"), regexp = "debe ser un valor lógico")
})

test_that("validate_logical() acepta input válido", {
  expect_silent(validate_logical(TRUE, "x"))
  expect_silent(validate_logical(FALSE, "x"))
})

test_that("validate_dataframe() rechaza non-dataframes", {
  expect_error(validate_dataframe(list(a = 1), arg_name = "datos"), regexp = "debe ser un data frame")
})

test_that("validate_dataframe() valida columnas requeridas", {
  df <- data.frame(a = 1, b = 2)
  expect_error(
    validate_dataframe(df, required_cols = c("a", "b", "c"), arg_name = "datos"),
    regexp = "Columnas faltantes: c"
  )
  expect_silent(validate_dataframe(df, required_cols = c("a", "b"), arg_name = "datos"))
})

test_that("validate_date() rechaza non-Date input", {
  expect_error(validate_date(123, "fecha"), regexp = "debe ser un vector de tipo Date")
})

test_that("validate_date() acepta Date válido", {
  expect_silent(validate_date(as.Date("2024-01-01"), "fecha"))
})

test_that("validate_choice() valida opciones permitidas", {
  expect_error(validate_choice("invalid", c("mes", "anio", "dia"), "st"),
               regexp = "debe ser uno de")
  expect_silent(validate_choice("mes", c("mes", "anio", "dia"), "st"))
})
```

Luego ejecuta:

```r
test_file("tests/testthat/test-utils_validation.R")
```

## Paso 8: Verificar el paquete completo

Ejecuta la verificación completa del paquete:

```r
library(devtools)
check()
```

Esto puede tomar varios minutos. Revisa:
- ✓ No errores (0 errors)
- ✓ Warnings de deprecación son esperados
- ✓ Notes sobre funciones deprecated son normales

## Paso 9: Actualizar README.md

Edita manualmente el archivo `README.md` y reemplaza:

**ANTES**:
```r
# Limpieza de texto
texto_limpio <- acep_clean(texto, rm_stopwords = TRUE)

# Conteo de menciones
menciones <- acep_men(texto, diccionario)

# Serie temporal
serie <- acep_rst(datos, fecha, n_palabras, conflictos)
```

**DESPUÉS**:
```r
# Limpieza de texto
texto_limpio <- acep_cleaning(texto, rm_stopwords = TRUE)

# Conteo de menciones
menciones <- acep_count(texto, diccionario)

# Serie temporal
serie <- acep_sst(datos)
```

## Paso 10: Actualizar vignettes

Edita los vignettes que usan funciones deprecated:

### `vignettes/limpieza_de_texto_con_acep.Rmd`

Busca y reemplaza:
- `acep_clean` → `acep_cleaning`

### Otros vignettes

Busca en todos los vignettes menciones a:
- `acep_men` → `acep_count`
- `acep_rst` → `acep_sst`

Puedes buscar con:

```r
library(here)
archivos_rmd <- list.files(here("vignettes"), pattern = "\\.Rmd$", full.names = TRUE)

for (archivo in archivos_rmd) {
  contenido <- readLines(archivo)
  if (any(grepl("acep_clean|acep_men|acep_rst", contenido))) {
    cat("Revisar:", basename(archivo), "\n")
  }
}
```

## Paso 11: Compilar vignettes

Después de actualizar los vignettes, compílalos:

```r
library(devtools)
build_vignettes()
```

## Paso 12: Instalar localmente y probar

Instala la versión actualizada del paquete:

```r
library(devtools)
install()
```

Luego prueba las funciones deprecated para verificar que muestran warnings:

```r
library(ACEP)

# Esto debería mostrar un warning
acep_clean("texto de prueba")

# Esto debería mostrar un warning
acep_men("texto", c("palabra"))

# Esto debería mostrar un warning
datos <- acep_bases$rp_procesada
acep_rst(datos, datos$fecha, datos$n_palabras, datos$conflictos)
```

## Paso 13: Actualizar NEWS.md

Agrega una entrada al archivo `NEWS.md`:

```markdown
# ACEP 0.0.4.0000 (En desarrollo)

## Mejoras importantes

* **FASE 1 completada**: Limpieza y consolidación de código
  - Agregadas funciones helper de validación en `utils_validation.R`
  - Reducción de ~100 líneas de código duplicado
  - Manejo de errores estandarizado y mejorado

## Funciones deprecated

Las siguientes funciones están deprecadas y serán eliminadas en una futura versión:

* `acep_clean()` → Use `acep_cleaning()` (significativamente más rápida)
* `acep_men()` → Use `acep_count()` (mejor nombre y vectorizada)
* `acep_rst()` → Use `acep_sst()` (parámetros simplificados)

## Cambios internos

* Refactorización de validaciones en:
  - `acep_count()`: Usa `validate_character()`
  - `acep_detect()`: Usa `validate_character()`, `validate_logical()`, `validate_numeric()`
  - `acep_int()`: Usa `validate_numeric()`
  - `acep_sst()`: Usa `validate_dataframe()`, `validate_choice()`

## Documentación

* Actualizado README.md con funciones no-deprecated
* Vignettes actualizadas para usar nuevas funciones
* Agregada documentación de deprecación en funciones obsoletas
```

## Paso 14: Commit de cambios

Si usas git, haz commit de todos los cambios:

```bash
cd e:/GoogleDriveWD/R/PROYECTOS/R_LIBRERIAS/ACEP
git add .
git commit -m "FASE 1: Limpieza y consolidación

- Agregadas funciones helper de validación (utils_validation.R)
- Deprecadas acep_clean, acep_men, acep_rst
- Refactorizadas acep_count, acep_detect, acep_int, acep_sst con helpers
- Agregados tests de deprecación
- Actualizada documentación

Ver FASE1_REFACTORIZACION.md y OPTIMIZACION_COMPLETA.md para detalles."
```

---

## VERIFICACIÓN FINAL

Antes de considerar FASE 1 completada, verifica:

- [ ] `devtools::document()` ejecutado sin errores
- [ ] `devtools::test()` ejecutado con todos los tests pasando
- [ ] `devtools::check()` ejecutado con 0 errors (warnings de deprecación son OK)
- [ ] Tests de deprecación creados y pasando
- [ ] Tests de validación creados y pasando
- [ ] README.md actualizado
- [ ] Vignettes actualizadas
- [ ] NEWS.md actualizado
- [ ] Cambios commiteados en git

---

## RESTAURAR BACKUP (Si algo sale mal)

Si necesitas revertir los cambios:

```r
# Copiar archivos del backup a la carpeta R/
archivos_backup <- list.files("backup_fase1", full.names = TRUE)

for (archivo in archivos_backup) {
  file.copy(
    archivo,
    file.path("R", basename(archivo)),
    overwrite = TRUE
  )
}

# Regenerar documentación
devtools::document()
```

---

## SOPORTE

Si encuentras problemas durante la implementación:

1. Revisa los documentos:
   - `FASE1_REFACTORIZACION.md` - Detalles técnicos
   - `OPTIMIZACION_COMPLETA.md` - Plan general

2. Verifica que los archivos backup estén en `backup_fase1/`

3. Ejecuta `devtools::check()` para diagnóstico detallado

4. Revisa los logs de error y busca el patrón específico

---

**¡Buena suerte con la implementación de FASE 1!** 🚀
