\name{dftse}
\alias{dftse}
\title{DFT censoring}
\description{
Discrete Fourier Transform censoring
}
\usage{
dftse(x, low_freq = NULL, high_freq = NULL)
}
\arguments{
\item{x}{
Vector, \code{data.frame} or \code{matrix} containing values for filtering.
}
\item{low_freq}{
Number indicating the lowest period of oscillation as fractions of \eqn{\pi}.
If \code{low_freq > 1}, indicating that the direct frequency of the data is
provided, this is transformed internally into \code{2 / high_freq}. The default
is NULL, meaning that the \code{ifelse(freq > 1, trunc(freq * 1.5), 2)} will be
used.
}
\item{high_freq}{
Number indicating the highest period of oscillation as radians of \eqn{\pi}. If
\code{high_freq > 1}, indicating that the direct frequency of the data is
provided, this is transformed internally into \code{2 / low_freq}. The default
is NULL, meaning that the \code{trunc(freq * 8)} will be used.
}
}
\details{
This is a pure R implementation of the DFT censoring. First DFT is applied on
the data and this is filtered according to \code{low_freq} and \code{high_freq}.
\code{low_freq} and \code{high_freq} must be both either between 0 and 1,
meaning that they are frequencies of the period as radians, or both >1,
indicating that both are starting and ending periods of the cycle.
}

\value{
Filtered object with length/dimensions same with the input x. Note that for
inputs with dimensions a matrix will be returned.
}

\references{
Corbae, D., Ouliaris, S., and Phillips, P. (2002), Band Spectral Regression with
Trending-Data, \emph{Econometrica} \bold{70}(3), pp. 1067-1109.

Corbae, D. and Ouliaris, S. (2006),
Extracting Cycles from Nonstationary Data,</span>in Corbae D., Durlauf S.N.,
and Hansen B.E. (eds.) \emph{Econometric Theory and Practice: Frontiers of
Analysis and Applied Research}. Cambridge: Cambridge University Press, pp.
167–177.\doi{10.1017/CBO9781139164863.008}.
}

\seealso{
\code{\link[corbouli]{corbae_ouliaris}}
}

\examples{
# Apply on ts object
data(USgdp)
corbae_ouliaris(USgdp, low_freq = 0.0625, high_freq = 0.3333)

# Apply on vector
dftse(c(USgdp), low_freq = 0.0625, high_freq = 0.3333)

# Apply on matrix per column
mat <- matrix(USgdp, ncol = 12)
dftse(mat, low_freq = 0.0625, high_freq = 0.3333)

# Apply on data.frame per column
dfmat <- as.data.frame(mat)
dftse(dfmat, low_freq = 0.0625, high_freq = 0.3333)
}
