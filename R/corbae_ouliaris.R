dftse <- function(x, low_freq, high_freq)
{
  if (low_freq < 0 || high_freq < 0){
    stop("Frequencies must be positive.")
  }
  if ((low_freq > 1 && high_freq < 1) || (high_freq > 1 && low_freq < 1)){
    stop("Both low_freq and high_freq must be <1 or >1.")
  }
  if (low_freq >= high_freq){
    stop("It must be low_freq < high_freq.")
  }
  if (low_freq > 1){
    low_freq <- 2 / high_freq
  }
  if (high_freq > 1){
    high_freq <- 2 / low_freq
  }

  if (is.null(dim(x))){
    # Vector case

    nrs <- length(x)
    datdf  <- fft(x) / nrs
    m  <- (nrs+(nrs%%2))/2
    k <- 1 / m
    if (k<low_freq|k>high_freq){
      datdf[1] <- 0
    }
    k <- 2:m / m
    remove_pos <- which((k<low_freq|k>high_freq)) + 1
    remove_pos <- c(remove_pos, nrs - (remove_pos-2))
    datdf[remove_pos] <- 0

    if (low_freq>0) {
      datdf[1] <- 0
    }
    if ((nrs%%2)==0 & high_freq<1) {
      datdf[m+1] <- 0
    }

    return(Re(fft(datdf, inverse = TRUE)))

  } else {
    # Matrix case

    nrs <- nrow(x)
    if (!is.matrix(x)){
      x <- as.matrix(x)
    }
    datdf  <- mvfft(x) / nrs
    m  <- (nrs+(nrs%%2))/2
    k <- 1 / m
    if (k<low_freq|k>high_freq){
      datdf[1,] <- 0
    }
    k <- 2:m / m
    remove_pos <- which((k<low_freq|k>high_freq)) + 1
    remove_pos <- c(remove_pos, nrs - (remove_pos-2))
    datdf[remove_pos,] <- 0

    if (low_freq>0) {
      datdf[1,] <- 0
    }
    if ((nrs%%2)==0 & high_freq<1) {
      datdf[m+1,] <- 0
    }

    return(Re(mvfft(datdf, inverse = TRUE)))

  }

}

corbae_ouliaris <- function(x, low_freq, high_freq){
  if (low_freq < 0 || high_freq < 0){
    stop("Frequencies must be positive.")
  }
  if ((low_freq > 1 && high_freq < 1) || (high_freq > 1 && low_freq < 1)){
    stop("Both low_freq and high_freq must be <1 or >1.")
  }
  if (low_freq >= high_freq){
    stop("It must be low_freq < high_freq.")
  }
  if (low_freq > 1){
    low_freq <- 2 / low_freq
  }
  if (high_freq > 1){
    high_freq <- 2 / high_freq
  }
  if (is.null(dim(x))){
    nrs <- length(x)

    return(lm(y ~ -1 + x,
              data.frame(
                y = dftse(x, low_freq, high_freq),
                x = dftse(seq(nrs)/nrs, low_freq, high_freq)
              )
           )$residuals
    )

  } else {
    nrs <- nrow(x)
    dftse_time <- dftse(seq(nrs)/nrs, low_freq, high_freq)
    dftse_x    <- dftse(x, low_freq, high_freq)

    var_dftse_time <- var(dftse_time)

    res <- x * 1 # make a copy and make sure for it by multiplying by one

    # Manual regression without constant per column
    for (i in seq(ncol(x))){
      res[,i] <- dftse_x[,i] -
                 (cov(dftse_x[,i], dftse_time) / var_dftse_time) * dftse_time
    }

    return(res)

  }
}
