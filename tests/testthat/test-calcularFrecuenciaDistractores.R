test_that("calcularFrecuenciaDistractores", {

  expected <- rbind(c(6, 4, 4, 2, 21, 2),
                    c(0, 1, 4, 33, 0, 1),
                    c(6, 4, 26, 1, 0, 2),
                    c(13, 22, 0, 2, 1, 1),
                    c(17, 8, 6, 0, 7, 1),
                    c(2, 6, 25, 3, 1, 2),
                    c(1, 13, 20, 3, 1, 1),
                    c(0, 3, 0, 26, 9, 1),
                    c(0, 14, 8, 10, 6, 1),
                    c(6, 6, 25, 0, 0, 2))


  # Data from csv files
  clave.csv <- system.file("extdata", "clave.csv", package = "itan", mustWork = TRUE)
  datos.csv <- system.file("extdata", "datos.csv", package = "itan", mustWork = TRUE)

  clave <- read.csv(clave.csv)

  # Sin NA
  datos <- read.csv(datos.csv)
  resultados <- datos[,-1]
  alternativas <- c("A", "B", "C", "D", "E", "*")

  actual <- calcularFrecuenciaDistractores(resultados, alternativas, clave = NULL, frecuencia = F)[1:10,]

  expect_setequal(actual, expected)

  # Con NA
  datos <- read.csv(datos.csv, na.strings = "*")
  alternativas <- c("A", "B", "C", "D", "E")
  resultados <- datos[,-1]

  actual <- calcularFrecuenciaDistractores(resultados, alternativas, clave = NULL, frecuencia = F)[1:10,]

  expect_setequal(actual, expected)


  # Data from xlsx files
  library(readxl)
  clave.xlsx <- system.file("extdata", "clave.xlsx", package = "itan", mustWork = TRUE)
  datos.xlsx <- system.file("extdata", "datos.xlsx", package = "itan", mustWork = TRUE)

  clave <- read_excel(clave.xlsx)

  # Sin NA
  datos <- read_excel(datos.xlsx)
  resultados <- datos[,-1]
  alternativas <- c("A", "B", "C", "D", "E", "*")

  actual <- calcularFrecuenciaDistractores(resultados, alternativas, clave = NULL, frecuencia = F)[1:10,]

  expect_setequal(actual, expected)

  # Con NA
  datos <- read_excel(datos.xlsx, na = c("*"))
  resultados <- datos[,-1]
  alternativas <- c("A", "B", "C", "D", "E")

  actual <- calcularFrecuenciaDistractores(resultados, alternativas, clave = NULL, frecuencia = F)[1:10,]

  expect_setequal(actual, expected)

})
