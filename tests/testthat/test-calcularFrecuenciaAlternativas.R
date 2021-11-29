test_that("calcularFrecuenciaAlternativas", {

  expected <- data.frame(c("i01", "i02", "i03", "i04", "i05", "i06", "i07", "i08", "i09", "i10"),
                         c(6, 0, 6, 13, 17, 2, 1, 0, 0, 6),
                         c(4, 1, 4, 22, 8, 6, 13, 3, 14, 6),
                         c(4, 4, 26, 0, 6, 25, 20, 0, 8, 25),
                         c(2, 33, 1, 2, 0, 3, 3, 26, 10, 0),
                         c(21, 0, 0, 1, 7, 1, 1, 9, 6, 0),
                         c(2, 1, 2, 1, 1, 2, 1, 1, 1, 2))
  rownames(expected) <- as.character(1:10)

# Data from csv files
  clave.csv <- system.file("extdata", "clave.csv", package = "itan", mustWork = TRUE)
  datos.csv <- system.file("extdata", "datos.csv", package = "itan", mustWork = TRUE)
  clave <- read.csv(clave.csv)

  # Sin NA
  datos <- read.csv(datos.csv)
  resultados <- datos[,-1]
  alternativas <- c("A", "B", "C", "D", "E", "*")
  actual <- calcularFrecuenciaAlternativas(resultados, alternativas, clave = NULL, frecuencia = F)[1:10,]
  colnames(expected) <- c("item", c(LETTERS[1:5], "*"))
  expect_mapequal(actual, expected)

  # Con NA
  datos <- read.csv(datos.csv, na.strings = "*")
  resultados <- datos[,-1]
  alternativas <- c("A", "B", "C", "D", "E", NA)
  actual <- calcularFrecuenciaAlternativas(resultados, alternativas, clave = NULL, frecuencia = F)[1:10,]
  colnames(expected) <- c("item", c(LETTERS[1:5], "NA"))
  expect_mapequal(actual, expected)


# Data from xlsx files
  library(readxl)
  clave.xlsx <- system.file("extdata", "clave.xlsx", package = "itan", mustWork = TRUE)
  datos.xlsx <- system.file("extdata", "datos.xlsx", package = "itan", mustWork = TRUE)
  clave <- read_excel(clave.xlsx)

  # Sin NA
  datos <- read_excel(datos.xlsx)
  resultados <- datos[,-1]
  alternativas <- c("A", "B", "C", "D", "E", "*")
  actual <- calcularFrecuenciaAlternativas(resultados, alternativas, clave = NULL, frecuencia = F)[1:10,]
  colnames(expected) <- c("item", c(LETTERS[1:5], "*"))
  expect_mapequal(actual, expected)

  # Con NA
  datos <- read_excel(datos.xlsx, na = "*")
  resultados <- datos[,-1]
  alternativas <- c("A", "B", "C", "D", "E", NA)
  actual <- calcularFrecuenciaAlternativas(resultados, alternativas, clave = NULL, frecuencia = F)[1:10,]
  colnames(expected) <- c("item", c(LETTERS[1:5], "NA"))
  expect_mapequal(actual, expected)

})
