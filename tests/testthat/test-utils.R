test_that("obtenerNGrupo", {

  even <- cbind(c(1:10))
  odd <- cbind(c(1:9))

  expect_error(
    obtenerNGrupo(even, 0.51),
    "El parámetro proporcion no puede ser mayor a 0.5."
  )

  expect_equal(obtenerNGrupo(even, 0.25), 2)
  expect_equal(obtenerNGrupo(odd, 0.25), 2)

})

test_that("obtenerGrupoInferior", {

  even <- cbind(c(1:10))
  odd <- cbind(c(1:9))

  expect_setequal(obtenerGrupoInferior(even, 0.25), even[1:2,])
  expect_setequal(obtenerGrupoInferior(odd, 0.25), odd[1:2,])

})

test_that("obtenerGrupoSuperior", {

  even <- cbind(c(1:10))
  odd <- cbind(c(1:9))

  expect_setequal(obtenerGrupoSuperior(even, 0.25), even[9:10,])
  expect_setequal(obtenerGrupoSuperior(odd, 0.25), odd[8:9,])

})

test_that("factorizarRespuestas", {

  respuestas <- datos[,-1]
  alternativas <- LETTERS[1:5]

  actual <- factorizarRespuestas(respuestas, alternativas)

  for (i in 1:ncol(actual)) {
    expect_true(is.factor(actual[,i]))
  }

})

test_that("dicotomize", {

  x <- datos$i01
  x[x=="A"] <- 1
  x[x!="1"] <- 0

  expected <- as.integer(x)
  actual <- dicotomize(datos$i01, "A")

  expect_equal(actual, expected)

})

test_that("sigma", {

  x <- c(20,25,35,32,34,41,31,30,24,38)
  expect_equal(sigma(x), 6.18061485614498)

})

test_that("rpb", {

  x <- c(1,1,0,1,0,0,1,0,1,0)
  y <- c(20,25,35,32,34,41,31,30,24,38)
  expect_equal(rpb(x,y), -0.7442625, tolerance = 0.0000001)

  x <- c(0, 1, 0, 0, 1, 1, 1, 1, 1, 1)
  y <- c(1, 1, 2, 2, 3, 4, 6, 6, 8, 10)
  expect_equal(rpb(x,y), 0.587510818533328, tolerance = 0.0000001)
  expect_equal(rpb(x,y), cor.test(x,y)$estimate[[1]], tolerance = 0.0000001)

  x <- c(1, 1, 0, 0, 1, 1)
  y <- c(7, 9, 6, 2, 4, 5)
  expect_equal(rpb(x, y, T), rpb(x, y-x, F))
  expect_equal(rpb(x,y, F), cor.test(x, y)$estimate[[1]], tolerance = 0.0000001)
  expect_equal(rpb(x,y, T), cor.test(x, y-x)$estimate[[1]], tolerance = 0.0000001)

})
