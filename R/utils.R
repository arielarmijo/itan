obtenerNGrupo <- function(datos, proporcion) {
  if (proporcion > 0.5) {
    stop("El par\u00e1metro proporcion no puede ser mayor a 0.5.")
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

factorizarRespuestas <- function(respuestas, alternativas) {
  for (i in 1:ncol(respuestas)) {
    respuestas[i] <- factor(respuestas[[i]], alternativas)
  }
  return(respuestas)
}

dicotomize <- function(x, choice) {
  output <- ifelse(x==choice, 1, 0)
  output[is.na(output)] <- 0
  return(output)
}

sigma <- function(x) {
  return(sqrt(sum((x-mean(x))^2)/length(x)))
}

rpb <- function(x, y, correccionPuntaje=FALSE) {
  if (correccionPuntaje) {
    y <- y -x
  }
  xp <- mean(y[x==1])
  xq <- mean(y[x==0])
  p <- length(x[x==1])/length(x)
  q <- 1-p
  return(((xp - xq)/sigma(y))*sqrt(p*q))
}
