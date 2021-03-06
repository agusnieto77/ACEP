% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/acep_men.R
\name{acep_men}
\alias{acep_men}
\title{Frecuencia de menciones de palabras.}
\usage{
acep_men(x, y, tolower = TRUE)
}
\arguments{
\item{x}{vector de textos al que se le aplica la función de conteo de la frecuencia de menciones de palabras del diccionario.}

\item{y}{vector de palabras del diccionario utilizado.}

\item{tolower}{convierte los textos a minúsculas.}
}
\value{
Si todas las entradas son correctas, la salida será un vector con una frecuencia de palabras de un diccionario.
}
\description{
Función que cuenta la frecuencia de menciones de palabras que refieren a conflictos en cada una de las notas/textos.
}
\examples{
rev_puerto <- acep_bases$rev_puerto
dicc_violencia <- acep_diccionarios$dicc_viol_gp
rev_puerto$conflictos <- acep_men(rev_puerto$nota, dicc_violencia)
rev_puerto |> head()
}
\keyword{indicadores}
