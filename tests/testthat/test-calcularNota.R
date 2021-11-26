test_that("calcularNota", {
  puntajes <- c(1:100)
  actual <- calcularNotas(puntajes)
  reprobados <- puntajes[puntajes<60]*3/60 + 1
  aprobados <- (puntajes[puntajes>=60]-60)*3/40 + 4
  expected <- c(round(reprobados, 1), round(aprobados, 1))
  expect_equal(actual, expected)
})
