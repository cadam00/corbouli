\name{USgdp}
\alias{USgdp}
\title{USgdp}
\description{
Quarterly US GDP in billions of chained 2017 dollars (Seasonally adjusted)
series from 1947.1 to 2019.4.

\emph{number of observations} : 292

\emph{observation} : country

\emph{country} : United States
}
\usage{
data(USgdp)
}
\format{
A monthly time series, in billions of chained 2017 dollars.
}
\value{
A \code{ts} object.
}

\source{
Bureau of Economic Analysis.
\href{https://www.bea.gov/gdp/gross-domestic-product}{
https://www.bea.gov/gdp/gross-domestic-product}.
Accessed 2024-09-04.
}

\references{
U.S. Bureau of Economic Analysis. (2024). Current-dollar and “real” GDP.
Retrieved from BEA website. \href{https://www.bea.gov/}{https://www.bea.gov/}
}

\examples{
# Apply on vector
data(USgdp)
USgdp
}
