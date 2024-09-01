\name{dftse}
\alias{dftse}
\title{Coherence metrics}
\description{
DFT censoring
}
\usage{
dftse(x, s, e)
}
\arguments{
\item{x}{
Vector containing values for filtering
}
\item{s}{
Number indicating the lowest frequency of the period as radians of \eqn{\pi}. If
\code{s > 1}, indicating that the direct frequency of the data is
provided, this is transformed internally into \code{2 / s}.
}
\item{e}{
Number indicating the lowest frequency of the period as radians of \eqn{\pi}. If
\code{e > 1}, indicating that the direct frequency of the data is
provided, this is transformed internally into \code{2 / e}.
}
}
\details{
This is a pure R implementation of the DFT censoring. First DFT is applied on
the data and this is filtered according to \code{s} and \code{e}
}

\value{
Filtered vector with the same length as the input.
}

\references{
Corbae, D. and Ouliaris, S. (2006) ‘Extracting Cycles from Nonstationary Data’,
in D. Corbae, S.N. Durlauf, and B.E. Hansen (eds.) \emph{Econometric Theory and
Practice: Frontiers of Analysis and Applied Research}. Cambridge: Cambridge
University Press, pp. 167–177. \doi{10.1017/CBO9781139164863.008}
}

\seealso{
\code{\link[CorbaeOuliaris]{corbae_ouliaris}}
}

\examples{
# Apply on vector
data(AirPassengers)
dftse(c(AirPassengers), 0.1, 0.9)
}

