% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotViolin.R
\docType{methods}
\name{plotViolin}
\alias{plotViolin}
\alias{plotViolin,cellSpecificityValues-method}
\alias{plotViolin,cellSpecificityValues,cellSpecificityValues-method}
\title{Plot Violins}
\usage{
plotViolin(x, ...)

\S4method{plotViolin}{cellSpecificityValues}(x, assays = colnames(x))
}
\arguments{
\item{x}{fractions for each gene}

\item{...}{other arguments}

\item{assays}{array of assays to plot}
}
\value{
Violin plot
}
\description{
Plot Violins
}
\examples{
library(muscat)
library(SingleCellExperiment)

data(example_sce)

# create pseudobulk for each sample and cell cluster
pb <- aggregateToPseudoBulk(example_sce,
  assay = "counts",
  cluster_id = "cluster_id",
  sample_id = "sample_id",
  verbose = FALSE
)

# Compute cell type specificity of each gene
df <- cellTypeSpecificity(pb)

# Violin plot of specificity scores for each cell type
# Dashed line indicates genes that are equally expressed
# across all cell types.  For K cell types, this is 1/K
plotViolin(df)
}
