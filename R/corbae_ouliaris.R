dftse <- function(x, low_freq, high_freq)
{
  if (!is.null(dim(x))){
    stop("Currently implemented only for vectors.")
  }
  if (low_freq < 0 || high_freq < 0){
    stop("Frequencies must be positive.")
  }
  if (low_freq > 1){
    low_freq <- 2 / low_freq
  }
  if (high_freq > 1){
    high_freq <- 2 / high_freq
  }

  nrs <- length(x)
  datdf  <- fft(x) / length(x)
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
}

corbae_ouliaris <- function(x, low_freq, high_freq){
  if (!is.null(dim(x))){
    stop("Currently implemented only for vectors.")
  }
  if (low_freq < 0 || high_freq < 0){
    stop("Frequencies must be positive.")
  }
  if (low_freq > 1){
    low_freq <- 2 / low_freq
  }
  if (high_freq > 1){
    high_freq <- 2 / high_freq
  }
  return(lm(y ~ x,
            data.frame(
              y = dftse(x, low_freq, high_freq),
              x = dftse(seq(x)/length(x), low_freq, high_freq))
         )$residuals
  )
}
