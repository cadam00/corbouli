## The current implementation is based on the following papers:
#
# - Corbae, D., Ouliaris, S., & Phillips, P. (2002), Band Spectral Regression
# with Trending-Data, Econometrica 70(3), pp. 1067-1109.
#
# - Corbae, D. & Ouliaris, S. (2006), Extracting Cycles from Nonstationary
# Data, in Corbae D., Durlauf S.N., & Hansen B.E. (eds.) Econometric Theory
# and Practice: Frontiers of Analysis and Applied Research. Cambridge: Cambridge
# University Press, pp. 167–177. https://doi.org/10.1017/CBO9781139164863.008.
#
# - Shaw, E.S. (1947), Burns and Mitchell on Business Cycles, Journal of
# Political # Economy, 55(4): pp. 281-298. https://doi.org/10.1086/256533
#
## Existing implementations of this algorithm in other programming languages:
#
# Eviews:
# - Ouliaris, S. (2009), Ideal Band Pass Filter For Stationary/Non-Stationary
# Series.
#
# Stata:
# - Pérez Pérez, J. (2011), COULIARI: Stata module to implement Corbae-Ouliaris
# frequency domain filter to time series data. Statistical Software Components,
# S457218, Boston College Department of Economics.

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
    # Shaw (1947)
    low_freq <- ifelse(freq > 1, trunc(freq * 1.5), 2)
  }
  if (is.null(high_freq)){
    # Shaw (1947)
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
  if (high_freq > 2 && low_freq < 2){
    stop("If high_freq is period, then it should be low_freq >= 2")
  }
  if (low_freq >= 1 && high_freq >= 2){
    temp      <- low_freq
    low_freq  <- 2 / high_freq
    high_freq <- 2 / temp
  }

  dim_x <- dim(x)
  if (is.null(dim_x)){
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

  } else if (length(dim_x) <= 2){
    # Matrix case

    nrs <- nrow(x)
    if (!is.matrix(x)){
      x <- as.matrix(x)
      dimnames(x) <- NULL
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

  } else {
    stop(paste0("Please provide at most a 2 dimensional object (e.g. matrix,",
                "data.frame)")
         )
  }

}

corbae_ouliaris <- function(x, low_freq = NULL, high_freq = NULL){
  if (is.null(low_freq) || is.null(high_freq)){
    freq <- frequency(x)
  }
  if (is.null(low_freq)){
    # Shaw (1947)
    low_freq <- ifelse(freq > 1, freq * 1.5, 2)
  }
  if (is.null(high_freq)){
    # Shaw (1947)
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
  if (high_freq > 1 && low_freq < 2){
    stop("If high_freq is period, then it should be low_freq >= 2")
  }
  if (low_freq >= 1 && high_freq >= 2){
    temp      <- trunc(low_freq)
    low_freq  <- 2 / trunc(high_freq)
    high_freq <- 2 / temp
  }

  dim_x <- dim(x)
  if (is.null(dim_x)){
    nrs <- length(x)

    dftse_time <- dftse(seq(nrs)/nrs, low_freq, high_freq)
    dftse_x    <- dftse(x, low_freq, high_freq)

    var_dftse_time <- var(dftse_time)

    res <- dftse_x - (cov(dftse_x, dftse_time) / var_dftse_time) * dftse_time

  } else if (length(dim_x) <= 2){
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
  } else {
    stop(paste0("Please provide at most a 2 dimensional object (e.g. matrix,",
                "data.frame)")
    )
  }

  return(res)

}
