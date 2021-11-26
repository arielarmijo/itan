test_that("calcularFrecuenciaDistractores", {

  alternativas <- c("A", "B", "C", "D", "E")
  resultados <- datos[,-1]

  actual <- calcularFrecuenciaDistractores(resultados, NULL, alternativas, F)[1:10,]
  expected <- rbind(c(6, 4, 4, 2, 21, 2),
                    c(0, 1, 4, 33, 0, 1),
                    c(6, 4, 26, 1, 0, 2),
                    c(13, 22, 0, 2, 1, 1),
                    c(17, 8, 6, 0, 7, 1),
                    c(2, 6, 25, 3, 1, 2),
                    c(1, 13, 20, 3, 1, 1),
                    c(0, 3, 0, 26, 9, 1),
                    c(0, 14, 8, 10, 6, 1),
                    c(6, 6, 25, 0, 0, 2))
  expect_setequal(actual, expected)

})
