dftse <- function(x, low_freq = NULL, high_freq = NULL)
{
  if (is.null(low_freq) || is.null(high_freq)){
    if(is.ts(x)){
      freq <- frequency(x)
    } else {
      freq <- 1
    }
  }
  if (is.null(low_freq)){
    low_freq <- ifelse(freq > 1, trunc(freq * 1.5), 2)
  }
  if (is.null(high_freq)){
    high_freq <- trunc(freq * 8)
  }
  if (low_freq < 0 || high_freq < 0){
    stop("Frequencies must be positive.")
  }
  if ((low_freq > 1 && high_freq < 1) || (high_freq > 1 && low_freq < 1)){
    stop("Both low_freq and high_freq must be <1 or >1.")
  }
  if (low_freq >= high_freq){
    stop("It must be low_freq < high_freq.")
  }
  if (low_freq >= 1 && high_freq > 1){
    temp      <- low_freq
    low_freq  <- 2 / high_freq
    high_freq <- 2 / temp
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

corbae_ouliaris <- function(x, low_freq = NULL, high_freq = NULL){
  if (is.null(low_freq) || is.null(high_freq)){
    freq <- frequency(x)
  }
  if (is.null(low_freq)){
    low_freq <- ifelse(freq > 1, freq * 1.5, 2)
  }
  if (is.null(high_freq)){
    high_freq <- freq * 8
  }
  if (low_freq < 0 || high_freq < 0){
    stop("Frequencies must be positive.")
  }
  if ((low_freq > 1 && high_freq < 1) || (high_freq > 1 && low_freq < 1)){
    stop("Both low_freq and high_freq must be <1 or >1.")
  }
  if (low_freq >= high_freq){
    stop("It must be low_freq < high_freq.")
  }
  if (low_freq > 1 && high_freq > 1){
    temp      <- trunc(low_freq)
    low_freq  <- 2 / trunc(high_freq)
    high_freq <- 2 / temp
  }
  if (is.null(dim(x))){
    nrs <- length(x)

    dftse_time <- dftse(seq(nrs)/nrs, low_freq, high_freq)
    dftse_x    <- dftse(x, low_freq, high_freq)

    var_dftse_time <- var(dftse_time)

    res <- dftse_x - (cov(dftse_x, dftse_time) / var_dftse_time) * dftse_time

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
  }

  return(res)

}
