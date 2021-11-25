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
