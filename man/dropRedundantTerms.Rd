% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dropRedundantTerms.R
\name{dropRedundantTerms}
\alias{dropRedundantTerms}
\title{Drop redundant terms from the model}
\usage{
dropRedundantTerms(formula, data, tol = 0.001)
}
\arguments{
\item{formula}{original formula}

\item{data}{data.frame}

\item{tol}{tolerance to test difference of correlation from 1 or -1}
}
\value{
a formula, possibly with terms omitted.
}
\description{
Detect co-linear fixed effects and drop the last one
}
\examples{

# Valid formula
dropRedundantTerms(~ group + extra, sleep)

}
