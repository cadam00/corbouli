dftse <- function(x, s, e)
{
  if (!is.null(dim(x))){
    stop("Currently implemented only for vectors.")
  }
  if (s < 0 || e < 0){
    stop("Frequencies must be positive.")
  }
  if (s > 1){
    s <- 2 / s
  }
  if (e > 1){
    e <- 2 / e
  }

  nrs <- length(x)
  datdf  <- fft(x) / length(x)
  m  <- (nrs+(nrs%%2))/2
  k <- 1 / m
  if (k<s|k>e){
    datdf[1] <- 0
  }
  k <- 2:m / m
  remove_pos <- which((k<s|k>e)) + 1
  remove_pos <- c(remove_pos, nrs - (remove_pos-2))
  datdf[remove_pos] <- 0

  if (s>0) {
    datdf[1] <- 0
  }
  if ((nrs%%2)==0 & e<1) {
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
