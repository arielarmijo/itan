test_that("agi", {

  respuestas <- datos[,-1]
  alternativas <- LETTERS[1:5]
  item <- agi(respuestas, clave, alternativas)

  expect_equal(length(item), 50)
  expect_equal(length(item$i01), 2)
  expect_equal(class(item$i01$datos)[1], "data.frame")
  expect_equal(class(item$i01$plot)[2], "ggplot")

})
