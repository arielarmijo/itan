#' itan: Paquete para el análisis de ítems de pruebas objetivas
#'
#' El paquete itan incluye funciones que permiten calcular el puntaje y calificación
#' obtenido por estudiantes en una prueba objetiva. Además, incorpora funciones para
#' analizar los ítems del test y sus distractores. Entre estos últimos destaca el
#' \href{http://www.educacionbc.edu.mx/departamentos/evaluacion/eacademicos/archivos/jornadasBC/MANUAL_PAGI.pdf}{análisis gráfico de ítems}
#' que permite visualizar las características técnicas del ítem y determinar
#' rápidamente su calidad.
#'
#' El paquete itan incluye datos para probar las funciones del paquete.
#' El data frame \code{\link{datos}} contiene las respuestas seleccionadas
#' por 39 estudiantes en una prueba objetiva de 50 ítems de selección múltiple.
#' Las alternativas posibles a cada ítem son 'A', 'B', 'C', 'D' y 'E', mientras
#' que las respuestas omitidas se indican mediante un '*'.
#' Cada estudiante tiene asociado un id único que figura en la columna 1 del data
#' frame. Las columnas que representan los ítems están rotuladas como 'i01',
#' 'i02', ..., 'i50'.
#' Por otro lado, el data frame \code{\link{clave}} contiene las alternativas
#' correctas para cada ítem de la prueba.
#'
#'
#' @section Funciones del paquete itan:
#'
#' La función \code{\link{corregirRespuestas}} permite determinar si las alternativas
#' seleccionadas por los estudiantes son correctas o incorrectas. Se asigna un 1
#' si la respuesta es correcta y un 0 si es incorrecta. El data frame con valores
#' binarios devuelto por esta función puede ser utilizado por la función
#' \code{\link{calcularPuntajes}} para determinar el puntaje obtenido en la prueba.
#'
#' A partir de los puntajes obtenidos en la prueba se puede calcular la calificación
#' de cada estudiante con la función \code{\link{calcularNotas}}. Esta última función
#' utiliza el \href{https://es.wikipedia.org/wiki/Calificaciones_escolares_en_Chile}{sistema de calificación usado en Chile}:
#' notas de 1.0 a 7.0, con nota de aprobación 4.0 y nivel de exigencia del 60\%.
#'
#' El data frame binario devuelto por la función \code{\link{corregirRespuestas}}
#' también puede ser usado para calcular el índice de dificultad y dos tipos de
#' índices de discriminación. Estas funciones son \code{\link{calcularIndiceDificultad}}
#' y \code{\link{calcularIndiceDiscriminacion}}, respectivamente.
#'
#' Las respuestas de los estudiantes sin procesar, junto con la clave de corrección,
#' pueden utilizarse para hacer dos tipos de análisis de distractores con las funciones
#' \code{\link{calcularFrecuenciaAlternativas}} y \code{\link{analizarAlternativas}}.
#' También se puede calcular la correlación biserial puntual de cada alternativa
#' con respecto al puntaje obtenido en la prueba con la función \code{\link{pBis}}.
#'
#' Por último, con la función \code{\link{agi}} se puede analizar gráficamente la
#' frecuencia de estudiantes que seleccionó cada alternativa en función de su
#' desempeño en la prueba. Esta función devuelve una lista con los datos y gráficos
#' generados para cada ítem. La inspección de las gráficas permite rápidamente determinar
#' la calidad del ítem.
#'
#' @references
#' Morales, P. (2009). Análisis de ítem en las pruebas objetivas. Madrid.
#' Recuperado de \href{https://educrea.cl/wp-content/uploads/2014/11/19-nov-analisis-de-items-en-las-pruebas-objetivas.pdf}{análisis de ítems}
#'
#' Guadalupe de los Santos (2010). Manual para el análisis gráfico de ítems. Universidad Autónoma de Baja California.
#' Recuperado de \href{http://www.educacionbc.edu.mx/departamentos/evaluacion/eacademicos/archivos/jornadasBC/MANUAL_PAGI.pdf}{manual_pagi.pdf}
#'
#' @docType package
#' @name itan
#'
NULL


#' Corrección de respuestas
#'
#' La función corregir respuestas transforma las respuestas de los estudiantes
#' a puntaje. El puntaje puede ser un \code{1}, si la respuesta es correcta, o un
#' \code{0}, si la respuesta es incorrecta. Los valores \code{NA} reciben puntaje
#' \code{0}.
#'
#' @param respuestas Un data frame con las alternativas seleccionadas por los
#' estudiantes en cada ítem.
#' @param clave Una data frame con la alternativa correcta para cada ítem.
#'
#' @return Un data frame con los aciertos (1) o errores (0) de
#' cada estudiante en cada ítem.
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

  clave <- toupper(clave)
  #output[is.na(output)] <- 0
  for (i in 1:nrow(respuestas)){
    output[i,] <- ifelse(toupper(respuestas[i,]) == clave, 1, 0)
  }
  output[is.na(output)] <- 0
  return(as.data.frame(output))

}

#' Cálculo de puntajes
#'
#' Calcula el puntaje total obtenido en la prueba por cada estudiante.
#'
#' @param respuestasCorregidas Un data frame con el puntaje obtenido por los estudiantes
#' en cada ítem.
#'
#' @return Un vector con el puntaje total obtenido en la pruebas por cada estudiante.
#'
#' @seealso \code{\link{corregirRespuestas}}, \code{\link{datos}} y \code{\link{clave}}.
#'
#' @examples
#' respuestas <- datos[,-1]
#' respuestasCorregidas <- corregirRespuestas(respuestas, clave)
#' puntajes <- calcularPuntajes(respuestasCorregidas)
#' cbind(id=datos[1], puntaje=puntajes)
#'
#' @export
#'
calcularPuntajes <- function(respuestasCorregidas){
  return(apply(X = respuestasCorregidas, MARGIN = 1, FUN = sum))
}


#' Cálculo de notas
#'
#' Calcula la nota obtenida por cada estudiante en función de
#' su puntaje alcanzado en la prueba. Se utiliza el \href{https://es.wikipedia.org/wiki/Calificaciones_escolares_en_Chile}{sistema de calificación
#' utilizado en Chile}.
#'
#' @param puntajes Un data frame con los puntajes obtenidos por los estudiantes
#' en la prueba.
#' @param pjeMax El puntaje máximo posible de alcanzar en la prueba.
#' @param notaMin La nota mínima otorgada al estudiante sin puntaje.
#' @param notaMax La nota máxima otorgada al estudiante con mejor puntaje.
#' @param notaAprobacion La nota necesaria para aprobar la prueba.
#' @param prema Porcentaje de rendimiento mínimo aceptable. Corresponde
#' a la proporción del puntaje máximo necesario para obtener
#' la nota de aprobación en la prueba.
#'
#' @return Un data frame con las notas obtenidas por los estudiantes en la prueba.
#'
#' @references
#' Pumarino, J. Escala de notas: Explicación de fórmula general y cálculo específico.
#' Recuperado de \url{https://escaladenotas.cl/?nmin=1.0&nmax=7.0&napr=4.0&exig=60.0&pmax=100.0&explicacion=1}
#'
#' @seealso \code{\link{corregirRespuestas}}, \code{\link{calcularPuntajes}},
#' \code{\link{datos}} y \code{\link{clave}}.
#'
#' @examples
#' respuestas <- datos[,-1]
#' respuestasCorregidas <- corregirRespuestas(respuestas, clave)
#' puntaje <- calcularPuntajes(respuestasCorregidas)
#' nota <- calcularNotas(puntaje)
#' cbind(id=datos[1], puntaje, nota)
#'
#' @export
#'
calcularNotas <- function(puntajes, pjeMax=max(puntajes), notaMin=1.0, notaMax=7.0, notaAprobacion=4.0, prema=0.6){
  output <- c()
  reprobados <- puntajes[puntajes<prema*pjeMax] * (notaAprobacion-notaMin)/(prema*pjeMax) + notaMin
  aprobados <-  (puntajes[puntajes>=prema*pjeMax]-prema*pjeMax) * (notaMax-notaAprobacion)/(pjeMax-prema*pjeMax) + notaAprobacion
  output[puntajes<prema*pjeMax] <- reprobados
  output[puntajes>=prema*pjeMax] <- aprobados
  return(nota=round(output,1))
}


#' Índice de dificultad
#'
#' Calcula el índice de dificultad para cada ítem.
#'
#' @param respuestasCorregidas Un data frame con los puntajes obtenidos por los estudiantes
#' en cada pregunta.
#' @param proporcion Proporción de estudiantes que forman parte de los grupos superior
#' e inferior. Valores habituales son 0.25, 0.27 y 0.33. Una proporción de 0.5 significa
#' que se toman todos los datos para calcular este índice.
#' @param digitos La cantidad de dígitos significativos que tendrá el resultado.
#'
#' @return Una vector con los índices de dificultad para cada ítem.
#'
#' @details El índice de dificultad p corresponde a la proporción de estudiantes
#' de los grupos superior e inferior que responden correctamente el ítem.
#' Puede tomar valores entre 0 y 1. A mayor valor, el ítem es más fácil y viceversa.
#'
#' @references Morales, P. (2009). Análisis de ítem en las pruebas objetivas.
#' Madrid. Recuperado de \url{https://educrea.cl/wp-content/uploads/2014/11/19-nov-analisis-de-items-en-las-pruebas-objetivas.pdf}
#'
#' @seealso \code{\link{corregirRespuestas}}, \code{\link{datos}} y \code{\link{clave}}.
#'
#' @examples
#' respuestas <- datos[,-1]
#' respuestasCorregidas <- corregirRespuestas(respuestas, clave)
#' p <- calcularIndiceDificultad(respuestasCorregidas)
#' item <- colnames(respuestas)
#' cbind(item, p)
#
#' @export
#'
calcularIndiceDificultad <- function(respuestasCorregidas, proporcion=0.5, digitos=2) {
  if (proporcion >= 0.5) {
    datos <- respuestasCorregidas
  } else {
    puntajes <- calcularPuntajes(respuestasCorregidas)
    datos <- cbind(respuestasCorregidas, puntajes)
    datos <- datos[order(datos[,ncol(datos)]), -ncol(datos)]
    datos <- rbind(obtenerGrupoInferior(datos, proporcion), obtenerGrupoSuperior(datos, proporcion))
  }
  return(round(apply(datos, 2, mean), 2))
}


#' Índice de discriminación
#'
#' Calcula el índice de discriminación para cada ítem.
#'
#' Los índices de discriminación permiten determinar
#' si un ítem diferencia entre estudiantes con alta o baja habilidad.
#' Se calculan a partir del grupo de estudiantes con mejor y peor puntuación
#' en el test.
#'
#' El índice de discriminación 1 (dc1) corresponde a la diferencia entre
#' la proporción de aciertos del grupo superior y la proporción
#' de aciertos del grupo inferior. Los valores extremos que puede alcanzar este
#' índice son 0 y +/-1. Los ítems con discriminación negativa favorecen a los
#' estudiantes con baja puntuación en el test y en principio deben ser revisados.
#' Este índice se ve influenciado por el índice de dificultad, por lo que a veces
#' es conveniente compararlo con el índice de discriminación 2 (dc2).
#'
#' El índice de discriminación 2 (dc2) corresponde a la proporción de aciertos del
#' grupo superior en relación al total de aciertos de ambos grupos. Los valores de
#' este índice van de 0 a 1. Pueden considerarse satisfactorios valores mayores a 0.5.
#' Este índice es independiente del nivel de dificultad de la pregunta.
#'
#' @param respuestasCorregidas Un data frame con los puntajes obtenidos por los
#' estudiantes en cada pregunta.
#' @param tipo Una cadena de texto que indica el tipo de índice de discriminación
#' a calcular. Valores posibles son: "dc1" o "dc2"
#' @param proporcion Proporción de estudiantes que forman parte de los grupos superior
#' e inferior. Valores habituales son 0.25, 0.27 y 0.33.
#' @param digitos La cantidad de dígitos significativos que tendrá el resultado.
#'
#' @return Un vector con el índice de discriminación para cada ítem.
#'
#' @references Morales, P. (2009). Análisis de ítem en las pruebas objetivas.
#' Madrid. Recuperado de \url{https://educrea.cl/wp-content/uploads/2014/11/19-nov-analisis-de-items-en-las-pruebas-objetivas.pdf}
#'
#' @seealso \code{\link{corregirRespuestas}}, \code{\link{calcularIndiceDificultad}}, \code{\link{datos}} y \code{\link{clave}}.
#'
#' @examples
#' respuestas <- datos[,-1]
#' respuestasCorregidas <- corregirRespuestas(respuestas, clave)
#' dc1 <- calcularIndiceDiscriminacion(respuestasCorregidas, tipo="dc1", proporcion=0.25)
#' dc2 <- calcularIndiceDiscriminacion(respuestasCorregidas, tipo="dc2", proporcion=0.25)
#' p <- calcularIndiceDificultad(respuestasCorregidas, proporcion=0.25)
#' cbind(p, dc1, dc2)
#'
#' @export
#'
calcularIndiceDiscriminacion <- function(respuestasCorregidas, tipo="dc1", proporcion=0.27, digitos=2) {

  puntajes <- calcularPuntajes(respuestasCorregidas)
  datos <- cbind(respuestasCorregidas, puntajes)
  datos <- datos[order(datos[,ncol(datos)]), -ncol(datos)]
  grupoInferior <- obtenerGrupoInferior(datos, proporcion)
  grupoSuperior <- obtenerGrupoSuperior(datos, proporcion)

  if (tipo == "dc1") {
    dc <- (apply(grupoSuperior, 2, mean) - apply(grupoInferior, 2, mean))
    return(round(dc, digitos))
  }

  if (tipo == "dc2") {
    dc <- apply(grupoSuperior, 2, sum) / (apply(grupoSuperior, 2, sum) + apply(grupoInferior, 2, sum))
    return(round(dc, digitos))
  }

  stop("Tipo de \u00edndice de discriminaci\u00f3n no existe. Valores v\u00e1lidos: 'dc1' o 'dc2'.")

}


#' Frecuencia de alternativas
#'
#' Calcula la frecuencia o proporcion de las alternativas seleccionadas en
#' cada ítem.
#'
#' @param respuestas Un data frame con las respuestas corregidas
#' de los estudiantes.
#' @param clave Un data frame con las respuestas correctas a cada pregunta.
#' @param alternativas Un vector con las alternativas posibles como respuestas.
#' @param frecuencia Un valor lógico que determina si la información
#' se presenta como frecuencia (\code{TRUE}) o proporción (\code{FALSE}).
#' Por defecto es \code{FALSE}
#' @param digitos La cantidad de dígitos significativos que tendrá el resultado.
#'
#' @return Un data frame con los ítems como filas y las frecuencias de las
#' alternativas como columnas. Si está presente la clave como parámetro, se
#' agrega la alternativa correcta como columna.
#'
#' @seealso \code{\link{corregirRespuestas}}, \code{\link{datos}} y
#' \code{\link{clave}}.
#'
#' @examples
#' alternativas <- c("A", "B", "C", "D", "E", "*")
#' respuestas <- datos[,-1]
#' calcularFrecuenciaAlternativas(respuestas, alternativas, clave, frecuencia=TRUE)
#'
#' @export
#'
calcularFrecuenciaAlternativas <- function(respuestas, alternativas, clave=NULL, frecuencia=FALSE, digitos=2){

  rows <- ncol(respuestas)
  cols <- length(alternativas) + 1
  resp <- factorizarRespuestas(respuestas, alternativas)

  output <- matrix(NA, rows, cols)
  colnames(output) <- c(alternativas, "NA")
  rownames(output) <- c(1:rows)

  for (i in 1:rows) {
    output[i,] <- table(resp[i], useNA="always")
    if (frecuencia) {
      output[i,] <- round(output[i,]/nrow(resp), digitos)
    }
  }

  if (!is.null(clave)){
    output <- cbind(as.data.frame(output), KEY=t(clave))
  }

  return(cbind(item=colnames(respuestas), as.data.frame(output)))

}


#' Gráfico frecuencia alternativas
#'
#' Grafica la frecuencia con que cada alternativa fue seleccionada por los
#' estudiantes en cada ítem.
#'
#' @param respuestas Un data frame con las alternativas seleccionadas por los
#' estudiantes en cada ítem.
#' @param alternativas Un vector con las alternativas posibles como respuestas.
#' @param clave (opcional) Un data frame con las alternativas correctas para cada
#' ítem. Si se incluye este parámetro, se marcará la alternativa correcta en el eje x.
#'
#' @return Una lista en la que cada elemento corresponde al gráfico de cada ítem.
#'
#' @seealso \code{\link{datos}} y \code{\link{clave}}.
#'
#' @examples
#' alternativas <- c(LETTERS[1:5], "*")
#' respuestas <- datos[,-1]
#' grafico <- graficarFrecuenciaAlternativas(respuestas, alternativas, clave)
#' grafico$i01
#' grafico$i025
#' grafico$i025
#'
#' @export
#'
graficarFrecuenciaAlternativas <- function(respuestas, alternativas, clave=NULL) {

  item <- ncol(respuestas)
  fa <-calcularFrecuenciaAlternativas(respuestas, alternativas)
  names <- colnames(fa)

  output  <- c();

  for (i in 1:item) {
    colnames(fa) <- ifelse(colnames(fa) == clave[[i]],
                           paste(c("*"), colnames(fa), sep = ""),
                           colnames(fa))
    fam <- melt(fa[i,], id.vars = "item")
    output[[i]] <- ggplot2::ggplot(fam, aes_string(x="variable", y="value", fill="variable")) +
                   ggplot2::geom_col(show.legend = F) +
                   ggplot2::labs(title = paste("\u00CDtem ", i),
                                 x="Alternativa",
                                 y="Frecuencia") +
                   ggplot2::theme(plot.title = element_text(size=18, face="bold" ,hjust=0.5))
    colnames(fa) <- names
  }

  names(output) <- colnames(respuestas)

  return(output);

}


#' Análisis de alternativas
#'
#' Calcula la frecuencia o proporción de las alternativas seleccionadas por el
#' grupo superior e inferior de estudiantes en cada ítem.
#'
#' @param respuestas Un data frame con las alternativas seleccionadas por los
#' estudiantes en cada ítem.
#' @param clave  Un data frame con las alternativas correctas para cada ítem.
#' @param alternativas Un vector con las alternativas posibles para cada ítem.
#' @param proporcion Proporción del total de estudiantes que constituyen los
#' grupos superior e inferior.
#'
#' @return Una lista en la cual cada elemento corresponde a un ítem. Para cada
#' ítem se calcula la frecuencia o proporción de las alternativas seleccionadas
#' por el grupo superior y por el grupo inferior de estudiantes.
#'
#' @references Morales, P. (2009). Análisis de ítem en las pruebas objetivas.
#' Madrid. Recuperado de \url{https://educrea.cl/wp-content/uploads/2014/11/19-nov-analisis-de-items-en-las-pruebas-objetivas.pdf}
#'
#' @seealso \code{\link{calcularFrecuenciaAlternativas}}, \code{\link{datos}} y \code{\link{clave}}.
#'
#' @examples
#' respuestas <- datos[,-1]
#' alternativas <- LETTERS[1:5]
#' analizarAlternativas(respuestas, clave, alternativas)
#'
#' @export
#'
analizarAlternativas <- function(respuestas, clave, alternativas, proporcion=0.25) {
  respuestasCorregidas <- corregirRespuestas(respuestas, clave)
  puntajes <- calcularPuntajes(respuestasCorregidas)
  resp <- factorizarRespuestas(respuestas, alternativas)
  datos <- cbind(resp, puntajes)
  datos <- datos[order(datos[,ncol(datos)]), -ncol(datos)]
  gInf <- obtenerGrupoInferior(datos, proporcion)
  gSup <- obtenerGrupoSuperior(datos, proporcion)
  output <- list()
  for (i in 1:ncol(respuestas)){
    output[[i]] <- rbind.data.frame(table(gSup[,i]), table(gInf[,i]))
    names <- alternativas
    names[names == clave[[i]]] <- paste("*", clave[[i]], sep = "")
    colnames(output[[i]]) <- names
    rownames(output[[i]]) <- c("gSup", "gInf")
  }
  names(output) <- colnames(respuestas)
  return(output)
}


#' Correlación biserial puntual.
#'
#' Calcula la correlación biserial puntual para cada alternativa en cada ítem con
#' respecto al puntaje obtenido en la prueba.
#'
#' Para su cálculo se utiliza la siguiente ecuación:
#' \deqn{
#'     r_{bp} = \frac{\overline{X_{p}}-\overline{X_{q}}}{\sigma_{X}}\sqrt{p \cdot q}
#' }
#'
#' @param respuestas Un data frame con las alternativas seleccionadas por los
#' estudiantes a cada ítem de la prueba.
#' @param clave Un data frame con la alternativa correcta para cada ítem.
#' @param alternativas Un vector con las alternativas posibles para cada ítem.
#' @param correccionPje Un valor lógico para usar o no la corrección de puntaje.
#' La corrección de puntaje consiste en restar del puntaje total el punto obtenido
#' por el ítem analizado.
#' @param digitos La cantidad de dígitos significativos que tendrá el resultado.
#'
#' @return Un data frame con la correlación biserial puntual para cada alternativa
#' en cada ítem.
#'
#' @references Attorresi, H, Galibert, M. y Aguerri, M. (1999). Valoración de los
#' ejercicios en las pruebas de rendimiento escolar. Educación Matemática. Vol. 11 No. 3, pp. 104-119.
#' Recuperado de \url{http://www.revista-educacion-matematica.org.mx/descargas/Vol11/3/10Attorresi.pdf}
#'
#' @seealso \code{\link{analizarAlternativas}}, \code{\link{calcularFrecuenciaAlternativas}}
#' \code{\link{datos}} y \code{\link{clave}}.
#'
#' @examples
#' respuestas <- datos[, -1]
#' alternativas <- LETTERS[1:5]
#' pBis(respuestas, clave, alternativas)
#'
#' @export
#'
pBis <- function(respuestas, clave, alternativas, correccionPje=TRUE, digitos=2) {

  nItem <- ncol(respuestas)
  nChoice <- length(alternativas)
  names <- list(1:nItem, alternativas)
  item <- colnames(respuestas)
  respCorregidas <- corregirRespuestas(respuestas, clave)
  puntajes <- calcularPuntajes(respCorregidas)

  output <- matrix(data = NA, nrow = nItem, ncol = nChoice, dimnames = names)

  for (i in 1:nItem){
    for (j in 1:nChoice) {
      choice <- ifelse(respuestas[,i]==alternativas[j], 1, 0)
      choice[is.na(choice)] <- 0
      output[i,j] = round(rpb(choice, puntajes, correccionPje), digitos)
    }
  }

  output <- cbind(item, as.data.frame(output), KEY=t(clave))

  return(output)

}


#' Análisis gráfico de ítems.
#'
#' El análisis gráfico de ítems (agi) permite visualizar las alternativas que eligen
#' los estudiantes según su desempeño general en la prueba. El agi proporciona
#' información esencial y fácilmente interpretable acerca de características técnicas
#' del ítem tales como su dificultad y poder de discriminación.
#'
#' Los estudiantes se clasifican habitualmente en 4 categorías según su puntaje
#' alcanzado en la prueba. La proporción de estudiantes de cada grupo que seleccionó
#' una alternativa determinada se muestra en el eje Y. Por ejemplo, en la siguiente
#' figura se puede observar que todos los estudiantes del grupo 4 (mejor desempeño)
#' seleccionaron la alternativa correcta D, mientras que el 25% de los estudiantes
#' del grupo 1 (peor desempeño) seleccionaron esta opción.
#'
#' \if{html}{\figure{i50.jpeg}{options: width=500 alt="Figura: Análisis gráfico ítem 01."}}
#'
#' @param respuestas Un data frame con las alternativas seleccionadas por los estudiantes
#' en cada ítem de la prueba.
#' @param clave Un data frame con las alternativas correctas para cada ítem.
#' @param alternativas Un vector con las alternativas posibles para cada ítem.
#' @param nGrupos Número de grupos en los que se categorizarán los estudiantes
#' según el puntaje obtenido en la prueba.
#' @param digitos La cantidad de dígitos significativos que tendrá el resultado.
#'
#' @return Una lista en la que cada elemento corresponde a un ítem de la prueba.
#' Cada elemento de la lista contiene a su vez una lista con dos elementos.
#' El primero de ellos corresponde a los datos; mientras que el segundo, al gráfico.
#'
#' @references Guadalupe de los Santos (2010). Manual para el análisis gráfico de ítems.
#' Universidad Autónoma de Baja California. Recuperado de
#' \href{http://www.educacionbc.edu.mx/departamentos/evaluacion/eacademicos/archivos/jornadasBC/MANUAL_PAGI.pdf}{manual_pagi.pdf}
#'
#' @examples
#' respuestas <- datos[,-1]
#' alternativas <- LETTERS[1:5]
#'
#' item <- agi(respuestas, clave, alternativas)
#'
#' item$i01$datos
#' item$i01$plot
#'
#' item$i25$datos
#' item$i25$plot
#'
#' item$i50$datos
#' item$i50$plot
#'
#' @import reshape ggplot2
#' @export
#'
agi <- function(respuestas, clave, alternativas, nGrupos=4, digitos=2) {

  item <- colnames(respuestas)
  nItems <- ncol(respuestas)
  nOpciones <- length(alternativas)

  respuestasCorregidas <- corregirRespuestas(respuestas, clave)
  puntajes <- calcularPuntajes(respuestasCorregidas)

  scoreGroups <- cut(puntajes, breaks=nGrupos)
  sgLevels <- levels(scoreGroups)

  lowerLimits <- as.numeric(sub("\\((.+),.*", "\\1", sgLevels))
  upperLimits <- as.numeric(sub("[^,]*,([^]]*)\\]","\\1",sgLevels))
  limites <- unique( c(lowerLimits, upperLimits) )

  sgMeans <- rowMeans(cbind(lowerLimits, upperLimits))

  sgIndexes <- vector("list", nGrupos)
  names(sgIndexes) <- levels(scoreGroups)
  for(j in 1:nGrupos){
    sgIndexes[[j]]=which(scoreGroups==sgLevels[j])
  }

  pBiserial <- pBis(respuestas, clave, alternativas)[, 2:(nOpciones+1)]

  output <- vector("list", nItems)
  names(output) <- item
  datos <- vector("list", nItems)
  names(datos) <- colnames(respuestas)
  plots <- vector("list", nItems)
  names(plots) <- colnames(respuestas)

  props <- matrix(nrow = nGrupos, ncol = nOpciones)
  rownames(props) <- c(1:nGrupos)

  for (i in 1:nItems){

    for(g in 1:nGrupos){
      for(o in 1:nOpciones){
        props[g,o] <- length(which(respuestas[sgIndexes[[g]],i] == alternativas[o])) / length(sgIndexes[[g]])
      }
    }

    props <- as.data.frame(props)
    colnames(props) <- ifelse(alternativas == clave[[i]],
                         paste(c("*"), alternativas, sep = ""),
                         alternativas)
    output[[i]] <- vector("list", 2)
    names(output[[i]]) <- c("datos", "plot")
    output[[i]][[1]] <- cbind(grupo=levels(scoreGroups), format(round(props, digitos), nsmall=digitos))

    colnames(props) <- alternativas
    colnames(props) <- ifelse(alternativas == clave[[i]],
                              paste(alternativas, c("* ("), format(pBiserial[i,], nsmall=2), c(")"), sep = ""),
                              paste(alternativas, c("  ("), format(pBiserial[i,], nsmall=2), c(")"), sep = ""))

    df <- reshape::melt(data = cbind(props, sgMeans), id.vars = "sgMeans")
    output[[i]][[2]] <- ggplot2::ggplot(df, aes_string(x="sgMeans", y="value", color="variable")) +
      ggplot2::geom_line() +
      ggplot2::geom_point(size=2) +
      ggplot2::labs(title = paste("\u00CDtem ", i),
                    x="Puntaje",
                    y="Proporci\u00F3n de estudiantes", colour="Alternativa (pBis)") +
      ggplot2::theme(plot.title = element_text(size=18, face="bold" ,hjust=0.5),
                     legend.position = "top",
                     legend.text = element_text(size=11, face="bold", hjust=0.5)) +
      ggplot2::scale_x_continuous(limits = c(min(limites),max(limites)), breaks=round(limites, 0)) +
      ggplot2::scale_y_continuous(limits = c(0,1))

  }


  #names(output) <- c("datos", "plots")

  return(output)

}





















