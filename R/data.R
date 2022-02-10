#' Datos de los estudiantes
#'
#' Un data frame con el id  y las respuestas de los estudiantes. Las respuestas
#' posibles pueden ser A, B, C, D o E. Las respuestas omitidas se representan
#' mediante valores NA.
#'
#' @format Data frame con 39 observaciones y 51 variables:
#' \describe{
#'   \item{id}{Id del estudiante.}
#'   \item{i01}{Alternativa seleccionada por el estudiante a la pregunta 1.}
#'   \item{i02}{Alternativa seleccionada por el estudiante a la pregunta 2.}
#'   ...
#'   \item{i50}{Alternativa seleccionada por el estudiante a la pregunta 50.}
#' }
#'
"datos"


#' Respuestas correctas a los \enc{í}{i}tems del test
#'
#' Un data frame con las respuestas correctas a los \enc{í}{i}tems del test.
#'
#' @format Data frame con 1 observación y 50 variables:
#' \describe{
#'   \item{i01}{Alternativa correcta para la pregunta 1.}
#'   \item{i02}{Alternativa correcta para la pregunta 2.}
#'   ...
#'   \item{i50}{Alternativa correcta para la pregunta 50.}
#' }
#'
"clave"
