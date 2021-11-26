test_that("agi", {

  respuestas <- datos[,-1]
  alternativas <- LETTERS[1:5]
  plots <- agi(respuestas, clave, alternativas)

  expect_equal(length(plots$datos), 50)
  expect_equal(length(plots$plots), 50)
  expect_equal(class(plots$plots$i01)[2], "ggplot")
  expect_equal(class(plots$datos$i01)[1], "data.frame")

})
