test_that("calcularIndiceDiscriminacon", {

  respuestas <- datos[,-1]
  respuestasCorregidas <- corregirRespuestas(respuestas, clave)

  actual <- calcularIndiceDiscriminacion(respuestasCorregidas, "dc1", 0.25)[1:10]
  expected <- c(0.30, -0.10, 0.00, 0.60, 0.70, 0.20, 0.50, 0.50, 0.30, 0.50)
  expect_setequal(actual, expected)

  actual <- calcularIndiceDiscriminacion(respuestasCorregidas, "dc2", 0.25)[1:10]
  expected <- c(0.60, 0.47, 0.50, 0.75, 0.82, 0.57, 0.73, 0.86, 0.71, 0.73)
  expect_setequal(actual, expected)

})
