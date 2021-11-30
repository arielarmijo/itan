test_that("pBis", {

  respuestas <- datos[,-1]
  alternativas <- c(LETTERS[1:5], "*")
  i01 <- respuestas$i01
  i01.A <- dicotomize(i01, "A")
  i01.B <- dicotomize(i01, "B")
  i01.C <- dicotomize(i01, "C")
  i01.D <- dicotomize(i01, "D")
  i01.E <- dicotomize(i01, "E")
  i01.O <- dicotomize(i01, "*")
  puntajes <- calcularPuntajes(corregirRespuestas(respuestas, clave))

  actual <- pBis(respuestas, clave, alternativas, F, 7)

  expect_equal(actual$A[1], rpb(i01.A, puntajes), tolerance = 0.000001)
  expect_equal(actual$B[1], rpb(i01.B, puntajes), tolerance = 0.000001)
  expect_equal(actual$C[1], rpb(i01.C, puntajes), tolerance = 0.000001)
  expect_equal(actual$D[1], rpb(i01.D, puntajes), tolerance = 0.000001)
  expect_equal(actual$E[1], rpb(i01.E, puntajes), tolerance = 0.000001)

  expect_equal(actual$A[1], cor.test(i01.A, puntajes)$estimate[[1]], tolerance = 0.000001)
  expect_equal(actual$B[1], cor.test(i01.B, puntajes)$estimate[[1]], tolerance = 0.000001)
  expect_equal(actual$C[1], cor.test(i01.C, puntajes)$estimate[[1]], tolerance = 0.000001)
  expect_equal(actual$D[1], cor.test(i01.D, puntajes)$estimate[[1]], tolerance = 0.000001)
  expect_equal(actual$E[1], cor.test(i01.E, puntajes)$estimate[[1]], tolerance = 0.000001)

})


