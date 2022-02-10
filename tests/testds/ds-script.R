library(readr)
library(readxl)
library(itan)

clave.csv <- system.file("extdata", "clave.csv", package = "itan")
datos.csv <- system.file("extdata", "datos.csv", package = "itan")

clave.xlsx <- system.file("extdata", "clave.xlsx", package = "itan")
datos.xlsx <- system.file("extdata", "datos.xlsx", package = "itan")

clave <- read_csv(clave.csv)
datos <- read_csv(datos.csv, na=c("*"))

clave <- read_excel(clave.xlsx)
datos <- read_excel(datos.xlsx, na = c("*"))

#clave <- read_excel("~/Proyectos/R/tmp/ds1-key.xlsx")
#datos <- read_excel("~/Proyectos/R/tmp/ds1-data.xlsx")

#clave <- read_csv("~/Proyectos/R/tmp/ds2-key.csv", delim = ";", trim_ws = TRUE,
#                    show_col_types = FALSE)
#datos <- read_csv("~/Proyectos/R/tmp/ds2-data.csv", delim = ";", trim_ws = TRUE,
#                    show_col_types = FALSE)

#clave <- read_excel("~/Proyectos/R/tmp/ds3-key.xlsx")
#datos <- read_excel("~/Proyectos/R/tmp/ds3-data.xlsx")

alternativas <- LETTERS[1:5]
id <- datos[1]
respuestas <- datos[,-1]

respuestasCorregidas <- corregirRespuestas(respuestas, clave)
puntaje <- calcularPuntajes(respuestasCorregidas)
nota <- calcularNotas(puntaje)

resultados <- cbind(id, puntaje, nota)
resultados <- resultados[order(resultados[,3], decreasing = TRUE),]
head(resultados)

p <- calcularIndiceDificultad(respuestasCorregidas, proporcion = 0.25)
dc1 <- calcularIndiceDiscriminacion(respuestasCorregidas, tipo = "dc1", proporcion = 0.25)
dc2 <- calcularIndiceDiscriminacion(respuestasCorregidas,tipo = "dc2", proporcion = 0.25)
indices <- cbind(p, dc1, dc2)
head(indices)

pb <- pBis(respuestas, clave, alternativas)
head(pb)


fa <- calcularFrecuenciaAlternativas(respuestas, alternativas, clave)
head(fa)

gfa <- graficarFrecuenciaAlternativas(respuestas, alternativas, clave)
gfa[1]

g <- agi(respuestas, clave, alternativas)
g[[1]]$datos
g[[1]]$plot

