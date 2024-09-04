test_that("corbae_ouliaris works", {
  ## To create corbae_ouliaris test data run:
  # data(USgdp)
  # corbae_ouliaris_USgdp <- corbae_ouliaris(USgdp,
  #                                          low_freq = 0.0625,
  #                                          high_freq = 0.3333)
  # save(corbae_ouliaris_USgdp,
  #      file="inst//testdata//corbae_ouliaris_USgdp.rda", version = 2)
  #
  # corbae_ouliaris_USgdp_nullfreq <- corbae_ouliaris(USgdp,
  #                                                   low_freq = NULL,
  #                                                   high_freq = NULL)
  # save(corbae_ouliaris_USgdp_nullfreq,
  #      file="inst//testdata//corbae_ouliaris_USgdp_nullfreq.rda", version = 2)

  library(corbouli)

  data(USgdp)
  corbae_ouliaris_USgdp_path <- system.file("testdata",
                                       "corbae_ouliaris_USgdp.rda",
                                       package = "corbouli")
  load(corbae_ouliaris_USgdp_path)

  corbae_ouliaris_USgdp_nullfreq_path <- system.file(
                                           "testdata",
                                           "corbae_ouliaris_USgdp_nullfreq.rda",
                                            package = "corbouli"
                                         )
  load(corbae_ouliaris_USgdp_nullfreq_path)

  expect_equal(
    corbae_ouliaris(USgdp, low_freq = 0.0625, high_freq = 0.3333),
    corbae_ouliaris_USgdp
  )

  expect_equal(
    corbae_ouliaris(USgdp, low_freq = NULL, high_freq = NULL),
    corbae_ouliaris_USgdp_nullfreq
  )

  expect_equal(
    corbae_ouliaris(as.matrix(USgdp), low_freq = 0.0625, high_freq = 0.3333),
    as.matrix(corbae_ouliaris_USgdp)
  )

  # if (low_freq < 0 || high_freq < 0)
  tryerror <- try(corbae_ouliaris(USgdp, low_freq = -1, high_freq = -1),
               silent = TRUE)

  expect_true(class(tryerror) == "try-error")

  # if ((low_freq > 1 && high_freq < 1) || (high_freq > 1 && low_freq < 1))
  tryerror <- try(corbae_ouliaris(USgdp, low_freq = 0.1, high_freq = 10),
                  silent = TRUE)

  expect_true(class(tryerror) == "try-error")

  # if (low_freq >= high_freq)
  tryerror <- try(corbae_ouliaris(USgdp, low_freq = 100, high_freq = 20),
                  silent = TRUE)

  expect_true(class(tryerror) == "try-error")

  #if (high_freq > 1 && low_freq < 2)
  tryerror <- try(corbae_ouliaris(c(USgdp), low_freq = 1, high_freq = 5),
                    silent = TRUE)

  expect_true(class(tryerror) == "try-error")

})

test_that("dftse works", {

  ## To create dftse test data run:
  # data(USgdp)
  # dftse_USgdp <- dftse(USgdp, low_freq = 0.0625, high_freq = 0.3333)
  # save(dftse_USgdp, file="inst//testdata//dftse_USgdp.rda", version = 2)
  #
  # dftse_nullfreq <- dftse(USgdp, low_freq = NULL, high_freq = NULL)
  # save(dftse_nullfreq,
  #      file="inst//testdata//dftse_USgdp_nullfreq.rda", version = 2)

  library(corbouli)

  data(USgdp)
  dftse_USgdp_path <- system.file("testdata",
                                  "dftse_USgdp.rda",
                                   package = "corbouli")
  load(dftse_USgdp_path)

  dftse_USgdp_nullfreq_path <- system.file("testdata",
                                           "dftse_USgdp_nullfreq.rda",
                                           package = "corbouli")
  load(dftse_USgdp_nullfreq_path)

  expect_equal(
    dftse(USgdp, low_freq = 0.0625, high_freq = 0.3333),
    dftse_USgdp
  )

  expect_equal(
    dftse(USgdp, low_freq = NULL, high_freq = NULL),
    dftse_USgdp_nullfreq
  )

  expect_equal(
    dftse(as.matrix(USgdp), low_freq = 0.0625, high_freq = 0.3333),
    as.matrix(dftse_USgdp)
  )

  expect_equal(
    dftse(as.data.frame(USgdp), low_freq = 0.0625, high_freq = 0.3333),
    as.matrix(dftse_USgdp)
  )

  expect_equal(
    dftse(c(USgdp), low_freq = NULL, high_freq = NULL),
    dftse(c(USgdp), low_freq = 0.25, high_freq = 1)
  )

  # if (low_freq < 0 || high_freq < 0)
  tryerror <- try(dftse(USgdp, low_freq = -1, high_freq = -1),
                  silent = TRUE)

  expect_true(class(tryerror) == "try-error")

  # if ((low_freq > 1 && high_freq < 1) || (high_freq > 1 && low_freq < 1))
  tryerror <- try(dftse(USgdp, low_freq = 0.1, high_freq = 10),
                  silent = TRUE)

  expect_true(class(tryerror) == "try-error")

  # if (low_freq >= high_freq)
  tryerror <- try(dftse(USgdp, low_freq = 100, high_freq = 20),
                  silent = TRUE)

  expect_true(class(tryerror) == "try-error")

  #if (high_freq > 1 && low_freq < 2)
  tryerror <- try(dftse(c(USgdp), low_freq = 1, high_freq = 5),
                  silent = TRUE)

  expect_true(class(tryerror) == "try-error")

})
