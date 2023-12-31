% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aggregateVar.R
\name{aggregateVar}
\alias{aggregateVar}
\title{Per-sample variance of single-cell counts}
\usage{
aggregateVar(
  sce,
  assay = NULL,
  cluster_id = NULL,
  sample_id = NULL,
  min.cells = 10,
  min.var = 0.01,
  min.samples = 4,
  min.prop = 0.4,
  verbose = TRUE,
  BPPARAM = SerialParam(progressbar = verbose)
)
}
\arguments{
\item{sce}{a \code{\link[SingleCellExperiment]{SingleCellExperiment}}.}

\item{assay}{character string specifying the assay slot to use as input data. Defaults to the 1st available (\code{assayNames(x)[1]}).}

\item{cluster_id}{character string specifying which variable to use as cluster id}

\item{sample_id}{character string specifying which variable to use as sample id}

\item{min.cells}{minimum number of observed cells for a sample to be included in the analysis}

\item{min.var}{minimum variance for a gene to be considered expressed in a sample}

\item{min.samples}{minimum number of samples passing cutoffs for cell cluster to be retained}

\item{min.prop}{minimum proportion of retained samples with non-zero counts for a gene to be}

\item{verbose}{logical. Should information on progress be reported?}

\item{BPPARAM}{a \code{\link[BiocParallel]{BiocParallelParam}}
object specifying how aggregation should be parallelized.}
}
\value{
a \code{dreamletProcessedData} object
}
\description{
Aggregation function for single-cell log-normalized counts to calculate per-sample variance for dreamlet.
}
\details{
The \code{dreamlet} workflow can also be applied to model gene expression variance. In this case, a per-sample per-gene variance is calculated across all cells from a given sample and cell type. Here \code{aggregateVar()} performs the roles of \code{aggregateToPseudoBulk()} followed by \code{processAssays()} but using log-normalized count data.

For each cell cluster, samples with at least min.cells are retained. Only clusters with at least min.samples retained samples are kept. Features are retained if they have at least min.var in at least min.prop fraction of the samples.

The precision of a measurement is the inverse of its sampling variance. The precision weights are computed as \code{1/sem^2}, where \code{sem = sd / sqrt(n)} and \code{n} is the number of cells.
}
\examples{
library(muscat)
library(SingleCellExperiment)

data(example_sce)

# Compute variance for each sample and cell cluster
pbVar <- aggregateVar(example_sce,
  assay = "counts",
  cluster_id = "cluster_id",
  sample_id = "sample_id",
  verbose = FALSE
)
}
