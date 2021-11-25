test_that("corregirRespuestas", {

  expect_error(
    corregirRespuestas(datos, clave[-1,]),
    "clave debe tener una sola fila."
  )

  expect_error(
    corregirRespuestas(datos, clave),
    "respuestas y clave no tienen el mismo número de columnas."
  )

  actual <- as.list(corregirRespuestas(clave, clave))
  expected <- lapply(clave, function(x){1})
  expect_mapequal(actual, expected)

  # Caso normal
  respuestas <- clave
  for (i in 1:9) {
    respuestas <- rbind(respuestas, clave)
  }
  actual <- corregirRespuestas(respuestas, clave)
  expected <- as.data.frame(matrix(data=1, nrow= 10, ncol = ncol(clave),
                                   dimnames = list(rownames(actual), colnames(clave))))
  expect_mapequal(actual, expected)

  # Alternativas en  mayúsculas y claves en minúsculas
  respuestas <- rbind(casefold(clave, upper=T))
  clave <- respuestas <- rbind(casefold(clave, upper=T))
  actual <- corregirRespuestas(respuestas, clave)
  expected <- lapply(clave, function(x){1})
  expect_setequal(actual, expected)

})
