test_that("pBis", {

  respuestas <- datos[,-1]
  alternativas <- LETTERS[1:5]

  actual <- pBis(respuestas, clave, alternativas, F, 6)[1,1]

  i01.A <- ifelse(respuestas$i01=="A", 1, 0)
  i01.A[is.na(i01.A)] <- 0
  puntajes <- calcularPuntajes(corregirRespuestas(respuestas, clave))
  expected <- rpb(i01.A, puntajes)

  expect_equal(actual, expected, tolerance = 0.00001)
  expect_equal(actual, cor.test(i01.A, puntajes)$estimate[[1]], tolerance = 0.00001)

})
