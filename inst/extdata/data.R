datos <- read.csv("inst/extdata/datos.csv")
clave <- read.csv("inst/extdata/clave.csv")
usethis::use_data(datos, clave, overwrite = TRUE)
