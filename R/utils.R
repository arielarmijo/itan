obtenerNGrupo <- function(datos, proporcion) {
  if (proporcion > 0.5) {
    stop("El parámetro proporcion no puede ser mayor a 0.5.")
  }
  return(round(nrow(datos)*proporcion))
}

obtenerGrupoInferior <- function(datos, proporcion) {
  nGrupo <- obtenerNGrupo(datos, proporcion)
  return(datos[1:nGrupo, ])
}

obtenerGrupoSuperior <- function(datos, proporcion) {
  nGrupos <- obtenerNGrupo(datos, proporcion)
  return(datos[(nrow(datos)-nGrupos+1):nrow(datos), ])
}
