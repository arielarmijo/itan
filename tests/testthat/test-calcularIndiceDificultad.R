test_that("calcularIndiceDificultad", {

  respuestas <- datos[,-1]
  respuestasCorregidas <- corregirRespuestas(respuestas, clave)

  actual <- calcularIndiceDificultad(respuestasCorregidas, 0.5)[1:10]
  expected <- c(0.54, 0.85, 0.67, 0.56, 0.44, 0.64, 0.51, 0.23, 0.36, 0.64)
  expect_setequal(actual, expected)

  actual <- calcularIndiceDificultad(respuestasCorregidas, 0.25)[1:10]
  expected <- c(0.75, 0.95, 0.60, 0.60, 0.55, 0.70, 0.55, 0.35, 0.35, 0.55)
  expect_setequal(actual, expected)

})
