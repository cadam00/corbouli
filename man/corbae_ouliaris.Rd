\name{corbae_ouliaris}
\alias{corbae_ouliaris}
\title{Corbae-Ouliaris}
\description{
Corbae-Ouliaris Frequency Domain Filter
}
\usage{
corbae_ouliaris(x, low_freq = NULL, high_freq = NULL)
}
\arguments{
\item{x}{
Vector, \code{data.frame} or \code{matrix} containing values for filtering.
}
\item{low_freq}{
Number indicating the lowest frequency of the period as fractions of \eqn{\pi}.
If \code{low_freq > 1}, indicating that the direct frequency of the data is
provided, this is transformed internally into \code{2 / high_freq}.
}
\item{high_freq}{
Number indicating the lowest frequency of the period as radians of \eqn{\pi}. If
\code{high_freq > 1}, indicating that the direct frequency of the data is
provided, this is transformed internally into \code{2 / low_freq}.
}
}
\details{
This is a pure R implementation of the filtering algorithm. \code{low_freq} and
\code{high_freq} are connected with characteristics of the series, for example
the business circle. \code{low_freq} and \code{high_freq} must be both either
between 0 and 1, meaning that they are frequencies of the period as radians, or
both >1, indicating that both are starting and ending periods of the cycle.
}

\value{
Filtered object with length/dimensions same with the input x.
}

\references{
Corbae, Dean, Sam Ouliaris and Peter C.B. Phillips (2002). "Band Spectral
Regression with Trending-Data", \emph{Econometrica} \bold{70}(3), pp.
1067-1109.

Corbae, D. and Ouliaris, S. (2006) ‘Extracting Cycles from Nonstationary Data’,
in D. Corbae, S.N. Durlauf, and B.E. Hansen (eds.) \emph{Econometric Theory and
Practice: Frontiers of Analysis and Applied Research}. Cambridge: Cambridge
University Press, pp. 167–177. \doi{10.1017/CBO9781139164863.008}
}

\seealso{
\code{\link[corbouli]{dftse}}
}

\examples{
# Apply on ts
data(USgdp)
corbae_ouliaris(USgdp, low_freq = 0.0625, high_freq = 0.3333)

# Apply on vector
data(USgdp)
corbae_ouliaris(USgdp, low_freq = 0.0625, high_freq = 0.3333)

# Apply on matrix per column
mat <- matrix(USgdp, ncol = 4)
corbae_ouliaris(mat, low_freq = 0.0625, high_freq = 0.3333)

# Apply on data.frame per column
dfmat <- as.data.frame(mat)
corbae_ouliaris(dfmat, low_freq = 0.0625, high_freq = 0.3333)
}
