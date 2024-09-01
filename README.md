<!-- badges: start -->
  [![](https://img.shields.io/badge/devel%20version-0.1.0-blue.svg)](https://CRAN.R-project.org/package=CorbaeOuliaris)
  [![R-CMD-check](https://github.com/cadam00/CorbaeOuliaris/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/cadam00/CorbaeOuliaris/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Implementation of the [Corbae and Ouliaris (2006)](#ref-corbae2006) Frequency
Domain Filter.

# **Install**

Development version of the package can be installed via
``` r
if (!require(remotes)) install.packages("remotes")
remotes::install_github("cadam00/CorbaeOuliaris")
```

# **Example**

``` r
data(AirPassengers)
corbae_ouliaris(AirPassengers, low_freq = 0.1, high_freq = 0.9)
```

# **References**

Corbae, D. and Ouliaris, S. (2006)<span class="nocase" id="ref-corbae2006">
‘Extracting Cycles from Nonstationary Data’, in D. Corbae, S.N. Durlauf, and
B.E. Hansen (eds.) <em>Econometric Theory and
Practice: Frontiers of Analysis and Applied Research</em>. Cambridge: Cambridge
University Press, pp. 167–177. https://doi.org/10.1017/CBO9781139164863.008.
