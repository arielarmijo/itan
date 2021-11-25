#' Correcci\enc{ó}{o}n de respuestas
#'
#' La funci\enc{ó}{o}n corregir respuestas transforma las respuestas de los estudiantes
#' a puntaje. El puntaje puede ser un \code{1}, si la respuesta es correcta, o un
#' \code{0}, si la respuesta es incorrecta. Los valores \code{NA} reciben puntaje
#' \code{0}.
#'
#' @param respuestas Un data frame con las alternativas seleccionadas por los
#' estudiantes en cada \enc{í}{i}tem.
#' @param clave Una data frame con la alternativa correcta para cada \enc{í}{i}tem.
#'
#' @return Un data frame con los aciertos (1) o errores (0) de
#' cada estudiante en cada \enc{í}{i}tem.
#'
#' @seealso \code{\link{datos}} y \code{\link{clave}}
#'
#' @examples
#' respuestas <- datos[, -1]
#' corregirRespuestas(respuestas, clave)
#'
#'@export
#'
corregirRespuestas <- function(respuestas, clave){

  if (nrow(clave) != 1){
    stop("clave debe tener una sola fila.")
  }

  if (ncol(respuestas) != ncol(clave)){
    stop("respuestas y clave no tienen el mismo n\u00famero de columnas.")
  }

  output <- matrix(data = NA, nrow = nrow(respuestas), ncol = ncol(respuestas),
                   dimnames = list(rownames(respuestas), colnames(respuestas)))

  for (i in 1:nrow(respuestas)){
    output[i,] <- ifelse(casefold(respuestas[i,], upper=T) == casefold(clave, upper=T), 1, 0)
  }
  output[is.na(output)] <- 0

  return(as.data.frame(output))

}
