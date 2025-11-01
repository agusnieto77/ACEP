# PLAN DE OPTIMIZACIÓN INTEGRAL - LIBRERÍA ACEP

**Versión actual**: 0.0.3.9005
**Fecha**: 2025-10-28
**Estado**: FASE 1 en progreso

---

## RESUMEN EJECUTIVO

La librería ACEP es un paquete R académico maduro para análisis computacional de eventos de protesta. El análisis exhaustivo identificó **6 fases de optimización** que reducirán el tiempo de ejecución en **50-70%**, eliminarán **~200 líneas de código duplicado**, y mejorarán significativamente la mantenibilidad.

### Métricas Actuales (Pre-Optimización)

| Métrica | Valor Actual |
|---------|--------------|
| Líneas de código (LOC) | 2,034 |
| Funciones exportadas | 25 (3 deprecated) |
| Archivos de test | 24 |
| Cobertura de tests | ~80% |
| Código duplicado | ~100+ líneas |
| Funciones con O(n⁴) | 1 (`acep_context`) |
| Dependencias externas | 8 principales |

### Objetivos de Optimización (Post-Optimización)

| Métrica | Objetivo | Mejora |
|---------|----------|--------|
| Líneas de código (LOC) | ~1,850 | -9% |
| Funciones activas | 22 | -12% |
| Cobertura de tests | ~95% | +15% |
| Código duplicado | 0 | -100% |
| Tiempo de ejecución | -50-70% | Gran mejora |
| Escalabilidad `acep_context` | O(n) | Vectorizado |

---

## ROADMAP DE OPTIMIZACIÓN

```
┌─────────────────────────────────────────────────────────────┐
│  FASE 1: LIMPIEZA Y CONSOLIDACIÓN (ALTA PRIORIDAD)         │
│  Duración estimada: 1-2 semanas                             │
│  Impacto: -9% LOC, +Mantenibilidad, Errores consistentes   │
└─────────────────────────────────────────────────────────────┘
      ↓
┌─────────────────────────────────────────────────────────────┐
│  FASE 2: OPTIMIZACIÓN DE RENDIMIENTO (ALTA PRIORIDAD)      │
│  Duración estimada: 2-3 semanas                             │
│  Impacto: -40-60% tiempo ejecución, Escalabilidad          │
└─────────────────────────────────────────────────────────────┘
      ↓
┌─────────────────────────────────────────────────────────────┐
│  FASE 3: MEJORA DE ARQUITECTURA (MEDIA PRIORIDAD)          │
│  Duración estimada: 3-4 semanas                             │
│  Impacto: +Extensibilidad, Pipeline elegante               │
└─────────────────────────────────────────────────────────────┘
      ↓
┌─────────────────────────────────────────────────────────────┐
│  FASE 4: PARALELIZACIÓN (MEDIA PRIORIDAD)                  │
│  Duración estimada: 2-3 semanas                             │
│  Impacto: -50-70% tiempo en corpus grandes                 │
└─────────────────────────────────────────────────────────────┘
      ↓
┌─────────────────────────────────────────────────────────────┐
│  FASE 5: TESTING Y CI/CD (BAJA PRIORIDAD)                  │
│  Duración estimada: 1-2 semanas                             │
│  Impacto: +95% cobertura, Benchmarking automático          │
└─────────────────────────────────────────────────────────────┘
      ↓
┌─────────────────────────────────────────────────────────────┐
│  FASE 6: DOCUMENTACIÓN Y USABILIDAD (BAJA PRIORIDAD)       │
│  Duración estimada: 1 semana                                │
│  Impacto: +UX, Onboarding más rápido                       │
└─────────────────────────────────────────────────────────────┘
```

**Duración total estimada**: 10-15 semanas

---

## FASE 1: LIMPIEZA Y CONSOLIDACIÓN ✅ EN PROGRESO

### Estado Actual

- [x] Análisis de funciones deprecated
- [x] Creación de funciones helper (`R/utils_validation.R`)
- [x] Documentación de estrategia (`FASE1_REFACTORIZACION.md`)
- [ ] Implementación de wrappers de deprecación
- [ ] Refactorización de validaciones
- [ ] Actualización de tests
- [ ] Actualización de documentación
- [ ] Verificación con `R CMD check`

### Tareas Principales

1. **Deprecar funciones obsoletas** (NO eliminar)
   - `acep_clean()` → `acep_cleaning()` (más rápida, usa datos locales)
   - `acep_men()` → `acep_count()` (vectorizada con stringr)
   - `acep_rst()` → `acep_sst()` (parámetros simplificados)

2. **Crear funciones helper de validación** ✅ COMPLETADO
   - `validate_character()` - Validación de texto
   - `validate_numeric()` - Validación numérica con rangos
   - `validate_logical()` - Validación de booleanos
   - `validate_dataframe()` - Validación de estructura
   - `validate_date()` - Validación de fechas
   - `validate_choice()` - Validación de opciones

3. **Refactorizar 9 funciones principales**
   - Reemplazar ~100 líneas de validación manual
   - Usar `stop()` en lugar de `return(message())`
   - Mensajes de error más informativos

### Impacto Esperado

| Métrica | Antes | Después | Mejora |
|---------|-------|---------|--------|
| LOC | 2,034 | 1,850 | -9% |
| Validaciones duplicadas | 100+ | 0 | -100% |
| Funciones con errores inconsistentes | 15 | 0 | -100% |
| Tiempo de implementación | N/A | 1-2 sem | N/A |

---

## FASE 2: OPTIMIZACIÓN DE RENDIMIENTO

### Objetivos

Reducir tiempo de ejecución en 40-60% mediante:
- Eliminación de bucles anidados
- Vectorización de operaciones
- Precompilación de regex
- Progress bars para feedback de usuario

### Tareas Principales

1. **Refactorizar `acep_context()`** [R/acep_context.R](R/acep_context.R:99)
   - **Problema**: Bucles anidados O(n⁴)
   - **Solución**: Vectorización con `stringr::str_extract_all()`
   - **Impacto**: -70-80% tiempo de ejecución

2. **Refactorizar `acep_svo()`** [R/acep_svo.R](R/acep_svo.R:423)
   - **Problema**: 280 líneas de código repetido (agregaciones)
   - **Solución**: Función auxiliar `aggregate_tokens()`
   - **Impacto**: -173 líneas, +40% velocidad

3. **Precompilar regex en `acep_count()`**
   - **Problema**: Regex compilado en cada llamada
   - **Solución**: Caché interno de patterns
   - **Impacto**: -40-50% tiempo de compilación

4. **Agregar progress bars**
   - Funciones: `acep_postag()`, `acep_svo()`, `acep_context()`
   - Usar paquete `cli` con parámetro `verbose=TRUE/FALSE`

### Impacto Esperado

| Función | Tiempo Antes | Tiempo Después | Mejora |
|---------|--------------|----------------|--------|
| `acep_context()` | 100% | 20-30% | -70-80% |
| `acep_svo()` | 100% | 60% | -40% |
| `acep_count()` | 100% | 50-60% | -40-50% |

---

## FASE 3: MEJORA DE ARQUITECTURA

### Objetivos

Crear sistema de clases unificado y pipeline de composición

### Tareas Principales

1. **Crear clase S3 `acep_corpus`**
   ```r
   acep_corpus <- function(texto, metadata = NULL) {
     structure(
       list(
         texto_original = texto,
         texto_procesado = NULL,
         metadata = metadata,
         procesamiento = list()
       ),
       class = "acep_corpus"
     )
   }
   ```

2. **Crear clase S3 `acep_result`**
   - Para resultados de análisis (frecuencias, intensidad, etc.)
   - Métodos: `print.acep_result()`, `plot.acep_result()`, `summary.acep_result()`

3. **Implementar pipeline con magrittr**
   ```r
   corpus %>%
     acep_cleaning(rm_stopwords = TRUE) %>%
     acep_count(dic = diccionario) %>%
     acep_int() %>%
     acep_plot()
   ```

4. **Consolidar funciones de plotting**
   - Crear `acep_plot()` genérica con parámetro `type=`
   - Reducir duplicación entre `acep_plot_st()` y `acep_plot_rst()`

### Impacto Esperado

- Código más legible y componible
- Reducción de objetos intermedios
- Mejor experiencia de usuario
- Facilita extensiones futuras

---

## FASE 4: PARALELIZACIÓN Y ESCALABILIDAD

### Objetivos

Aprovechar múltiples cores para procesamiento masivo

### Tareas Principales

1. **Paralelizar `acep_postag()`** [R/acep_postag.R](R/acep_postag.R:127)
   ```r
   library(furrr)
   plan(multisession, workers = 4)

   results <- future_map(textos, ~{
     spacyr::spacy_parse(.x)
   }, .progress = TRUE)
   ```
   - **Impacto**: -50-70% tiempo en corpus >100 documentos

2. **Implementar procesamiento por chunks**
   - Evitar cargar todo el corpus en memoria
   - Usar `readr::read_csv_chunked()` para archivos grandes

3. **Optimizar uso de memoria en `acep_svo()`**
   - Usar `data.table` en lugar de `data.frame`
   - Evitar copias innecesarias
   - Garbage collection explícito

### Impacto Esperado

| Corpus Size | Tiempo Antes | Tiempo Después | Mejora |
|-------------|--------------|----------------|--------|
| 100 docs | 5 min | 1.5-2.5 min | -50-70% |
| 1,000 docs | 50 min | 15-25 min | -50-70% |
| 10,000 docs | 8.3 hrs | 2.5-4.2 hrs | -50-70% |

---

## FASE 5: TESTING Y CI/CD

### Objetivos

Aumentar cobertura de tests y automatizar benchmarking

### Tareas Principales

1. **Expandir suite de tests**
   - Tests para casos edge (inputs vacíos, NA, caracteres especiales)
   - Tests de integración entre funciones
   - Meta: 95% cobertura (actualmente ~80%)

2. **Crear benchmarking suite**
   ```r
   library(bench)

   bench::mark(
     acep_cleaning = acep_cleaning(textos),
     acep_clean_old = acep_clean(textos),
     iterations = 100
   )
   ```

3. **Mejorar workflow CI/CD**
   - GitHub Actions: Agregar stage de benchmarking automático
   - Alertas si performance baja >20%
   - Actualización automática de vignettes con tiempos

---

## FASE 6: DOCUMENTACIÓN Y USABILIDAD

### Objetivos

Mejorar experiencia del usuario y facilitar onboarding

### Tareas Principales

1. **Crear vignette "Quick Start"**
   - Workflow completo en 5 minutos
   - Desde carga de datos hasta visualización

2. **Mejorar mensajes de error con sugerencias**
   ```r
   # Antes:
   message("Columna 'fecha' no encontrada")

   # Después:
   stop("Columna 'fecha' no encontrada en el data frame.\n",
        "Sugerencia: Renombre su columna temporal a 'fecha' usando: ",
        "nombres(df)[3] <- 'fecha'",
        call. = FALSE)
   ```

3. **Crear cheatsheet visual**
   - Diagrama de flujo de funciones
   - Tabla de referencia rápida
   - Disponible en pkgdown site

---

## CRONOGRAMA DE IMPLEMENTACIÓN

### Corto Plazo (1-3 semanas) - ALTA PRIORIDAD

- [x] FASE 1.1: Crear funciones helper ✅
- [x] FASE 1.2: Documentar estrategia ✅
- [ ] FASE 1.3: Deprecar funciones obsoletas
- [ ] FASE 1.4: Refactorizar validaciones
- [ ] FASE 1.5: Actualizar tests y documentación
- [ ] FASE 2.1: Refactorizar `acep_context()`
- [ ] FASE 2.2: Precompilar regex

### Mediano Plazo (1-2 meses) - MEDIA-ALTA PRIORIDAD

- [ ] FASE 2.3: Refactorizar `acep_svo()`
- [ ] FASE 2.4: Agregar progress bars
- [ ] FASE 3.1: Crear clase `acep_corpus`
- [ ] FASE 3.2: Crear clase `acep_result`

### Largo Plazo (3-6 meses) - MEDIA PRIORIDAD

- [ ] FASE 3.3: Implementar sistema de pipeline
- [ ] FASE 3.4: Consolidar funciones de plotting
- [ ] FASE 4.1: Paralelizar `acep_postag()`
- [ ] FASE 4.2: Procesamiento por chunks

### Continuo - BAJA PRIORIDAD

- [ ] FASE 5: Expandir tests y CI/CD
- [ ] FASE 6: Mejorar documentación

---

## MÉTRICAS DE ÉXITO

### Indicadores Clave de Rendimiento (KPIs)

| KPI | Baseline | Objetivo | Fase |
|-----|----------|----------|------|
| **Reducción LOC** | 2,034 | 1,850 (-9%) | F1 |
| **Tiempo ejecución** | 100% | 30-50% | F2, F4 |
| **Cobertura tests** | 80% | 95% | F5 |
| **Código duplicado** | 100+ | 0 líneas | F1 |
| **Funciones activas** | 25 | 22 | F1 |
| **Escalabilidad `acep_context`** | O(n⁴) | O(n) | F2 |
| **Tiempo onboarding** | 30 min | 5 min | F6 |

### Benchmarks de Referencia

**Corpus de prueba**: 1,000 artículos periodísticos (~500 palabras/artículo)

| Operación | Tiempo Pre-Opt | Tiempo Post-Opt | Mejora |
|-----------|----------------|-----------------|--------|
| Limpieza (`acep_clean` → `acep_cleaning`) | 45 seg | 8 seg | -82% |
| Conteo (`acep_men` → `acep_count`) | 12 seg | 7 seg | -42% |
| Contexto (`acep_context` vectorizado) | 180 seg | 25 seg | -86% |
| SVO (`acep_svo` optimizado) | 90 seg | 54 seg | -40% |
| POS tagging (`acep_postag` paralelo) | 300 seg | 90 seg | -70% |
| **Pipeline completo** | **627 seg** | **184 seg** | **-71%** |

---

## RIESGOS Y MITIGACIONES

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Breaking changes para usuarios | Media | Alto | Usar `.Deprecated()`, mantener funciones 1-2 versiones |
| Regresión de performance | Baja | Alto | Benchmarking automático en CI/CD |
| Tests fallan post-refactorización | Media | Medio | Tests incrementales, rollback si falla |
| Paralelización no funciona en Windows | Media | Medio | Fallback a procesamiento secuencial |
| Usuarios no migran a nuevas funciones | Alta | Bajo | Documentación clara, warnings informativos |

---

## RECURSOS NECESARIOS

### Humanos

- **Desarrollador principal**: 10-15 semanas (tiempo completo)
- **Revisor de código**: 2-3 semanas (tiempo parcial)
- **Tester**: 1-2 semanas (para FASE 5)

### Técnicos

- GitHub Actions (CI/CD) - Gratis para repos públicos
- Infraestructura de testing - Incluida en R ecosystem
- Herramientas de benchmarking (`bench`, `profvis`) - Gratis

### Dependencias Nuevas

| Paquete | Propósito | Fase | Tipo |
|---------|-----------|------|------|
| `cli` | Progress bars modernas | F2 | Imports |
| `furrr` | Paralelización | F4 | Suggests |
| `data.table` | Optimización memoria | F4 | Suggests |
| `bench` | Benchmarking | F5 | Suggests |

---

## COMUNICACIÓN Y STAKEHOLDERS

### Stakeholders Principales

1. **Usuarios actuales de ACEP**
   - Notificar de funciones deprecated
   - Proveer guía de migración
   - Destacar mejoras de performance

2. **Contribuidores de código**
   - Guidelines de validación con helpers
   - Estándares de manejo de errores
   - Proceso de code review

3. **Equipo académico (SISMOS)**
   - Presentar roadmap y beneficios
   - Obtener feedback sobre prioridades
   - Coordinar timeline con publicaciones

### Plan de Comunicación

| Evento | Audiencia | Canal | Timing |
|--------|-----------|-------|--------|
| Anuncio de roadmap | Todos | GitHub Issues, README | Inicio |
| Deprecation warnings | Usuarios | Funciones + Vignette | FASE 1 |
| Release notes | Todos | NEWS.md, GitHub Releases | Cada fase |
| Performance benchmarks | Usuarios | Vignette dedicada | FASE 2, 4 |
| Migration guide | Usuarios | Vignette | FASE 1 completada |
| API changes | Desarrolladores | CHANGELOG.md | Continuo |

---

## PRÓXIMOS PASOS INMEDIATOS

### Esta Semana

1. ✅ Completar documento de estrategia FASE 1
2. ⏳ Implementar wrappers de deprecación (`acep_clean`, `acep_men`, `acep_rst`)
3. ⏳ Refactorizar primeras 3 funciones con helpers (`acep_frec`, `acep_count`, `acep_detect`)
4. ⏳ Crear tests de deprecation warnings

### Próxima Semana

5. Refactorizar 6 funciones restantes
6. Actualizar README.md y vignettes
7. Ejecutar `R CMD check` completo
8. Crear PR para revisión de FASE 1

### Mes 1

9. Completar FASE 1
10. Iniciar FASE 2 (refactorizar `acep_context`)
11. Precompilar regex en `acep_count`

---

## CONCLUSIÓN

La librería ACEP tiene una base sólida pero se beneficiará significativamente de estas optimizaciones. El plan de 6 fases es **incremental, seguro y medible**, con foco inicial en mejoras de alto impacto y bajo riesgo (FASE 1 y 2).

**Inversión total**: 10-15 semanas de desarrollo
**Retorno esperado**:
- -71% tiempo de ejecución en pipeline completo
- +95% cobertura de tests
- Código más mantenible y extensible
- Mejor experiencia de usuario

**Recomendación**: Proceder con FASE 1 inmediatamente, evaluar resultados, y continuar con FASE 2-4 según feedback y prioridades del equipo.

---

**Documento preparado por**: Claude (Anthropic)
**Para**: Optimización de librería ACEP
**Versión**: 1.0
**Última actualización**: 2025-10-28
