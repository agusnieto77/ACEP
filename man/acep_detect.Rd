% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/acep_detect.R
\name{acep_detect}
\alias{acep_detect}
\title{Detección de menciones de palabras.}
\usage{
acep_detect(x, y, u = 1, tolower = TRUE)
}
\arguments{
\item{x}{vector de textos al que se le aplica la función de
detección de menciones de palabras del diccionario.}

\item{y}{vector de palabras del diccionario utilizado.}

\item{u}{umbral para atribuir valor positivo a la
detección de las menciones.}

\item{tolower}{convierte los textos a minúsculas.}
}
\value{
Si todas las entradas son correctas,
la salida sera un vector numérico.
}
\description{
Función que detecta de menciones de palabras que
refieren a conflictos en cada una de las notas/textos.
}
\examples{
df <- data.frame(texto = c("El SUTEBA fue al paro. Reclaman mejoras salariales.",
"El SOIP lleva adelante un plan de lucha con paros y piquetes."))
diccionario <- c("paro", "lucha", "piquetes")
df$detect <- acep_detect(df$texto, diccionario)
df
}
\keyword{frecuencia}
\keyword{indicadores}
\keyword{tokens}
