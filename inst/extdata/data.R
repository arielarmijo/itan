clave <- read.csv("inst/extdata/clave.csv")
datos <- read.csv("inst/extdata/datos.csv", na.strings = c("*"))
usethis::use_data(clave, datos, overwrite = TRUE)
