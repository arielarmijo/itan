datos <- read.csv("inst/extdata/datos.csv", na.strings = "*")
clave <- read.csv("inst/extdata/clave.csv")
usethis::use_data(datos, clave, overwrite = TRUE)
