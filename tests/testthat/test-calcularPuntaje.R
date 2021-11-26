test_that("calcularPuntajes", {

  respuestas <- datos[,-1]
  respuestasCorregidas <- corregirRespuestas(respuestas, clave)

  actual <- sum(calcularPuntajes(respuestasCorregidas))
  expected <- 845
  expect_equal(actual, expected)

  actual <- sum(calcularPuntajes(corregirRespuestas(clave, clave)))
  expected <- 50
  expect_equal(actual, expected)

})
