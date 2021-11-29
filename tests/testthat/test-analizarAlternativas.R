test_that("analizarAlternativas", {

  respuestas <- datos[,-1]
  alternativas <- LETTERS[1:5]

  actual <- analizarAlternativas(respuestas, clave, alternativas)
  gSup <- list(c(0, 0, 0, 1, 9),
               c(0, 0, 1, 9, 0),
               c(2, 1, 6, 0, 0),
               c(1, 9, 0, 0, 0),
               c(9, 0, 0, 0, 1)
          )
  gInf <- list(c(1, 0, 1, 1, 6),
               c(0, 0, 0, 10, 0),
               c(1, 2, 6, 1, 0),
               c(6, 3, 0, 0, 1),
               c(2, 3, 3, 0, 3)
          )

  for (i in 1:5) {
    expect_setequal(actual[[i]][1,], gSup[[i]])
    expect_setequal(actual[[i]][2,], gInf[[i]])
  }

})
