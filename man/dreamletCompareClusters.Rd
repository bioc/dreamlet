% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dreamletCompareClusters.R
\name{dreamletCompareClusters}
\alias{dreamletCompareClusters}
\title{Differential expression between pair of assays}
\usage{
dreamletCompareClusters(
  pb,
  assays,
  method = c("fixed", "random", "none"),
  formula = ~0,
  collapse = TRUE,
  min.cells = 10,
  min.count = 10,
  min.samples = 4,
  isCounts = TRUE,
  normalize.method = "TMM",
  robust = FALSE,
  quiet = FALSE,
  contrasts = c(compare = paste("cellClustertest - cellClusterbaseline")),
  BPPARAM = SerialParam(),
  errorsAsWarnings = FALSE,
  ...
)
}
\arguments{
\item{pb}{pseudobulk data as SingleCellExperiment object}

\item{assays}{array of two entries specifying assays (i.e. cell clusters) to compare, or a list of two sets of assays.}

\item{method}{account for repeated measures from donors using a "random" effect, a "fixed" effect, or "none"}

\item{formula}{covariates to include in the analysis.}

\item{collapse}{if TRUE (default), combine all cell clusters within the test set, and separately the baseline set. If FALSE, estimate coefficient for each cell cluster and then identify differential expression using linear contrasts with \code{variancePartition::makeContrastsDream()}}

\item{min.cells}{minimum number of observed cells for a sample to be included in the analysis}

\item{min.count}{minimum number of reads for a gene to be consider expressed in a sample.  Passed to \code{edgeR::filterByExpr}}

\item{min.samples}{minimum number of samples passing cutoffs for cell cluster to be retained}

\item{isCounts}{logical, indicating if data is raw counts}

\item{normalize.method}{normalization method to be used by \code{calcNormFactors}}

\item{robust}{logical, use eBayes method that is robust to outlier genes}

\item{quiet}{show messages}

\item{contrasts}{cell type is encoded in variable \code{cellCluster} with levels \code{test} and \code{baseline}. \code{contrasts} specifies contrasts passed to \code{variancePartition::makeContrastsDream()}.  Note, advanced users only.}

\item{BPPARAM}{parameters for parallel evaluation}

\item{errorsAsWarnings}{if \code{TRUE}, convert error to a warning and return \code{NULL}}

\item{...}{other arguments passed to \code{dream}}
}
\value{
Object of class \code{dreamletResult} storing results for each comparison
}
\description{
Perform differential expression between a pair of assays using linear (mixed) models
}
\details{
Analyze pseudobulk data to identify differential gene expression between two cell clusters or sets of clusters while modeling the cross-donor expression variation and other aspects of the study design.

\code{dreamletCompareClusters()} is useful for finding genes that are differentially expressed betweeen cell clusters and estimating their fold change.  However, the p-values and number of differentially expressed genes are problematic for two reasons, so users must be careful not to overinterpret them:

\enumerate{
\item{Cell clusters are typically identified with the same gene expression data used for this differential expression analysis between clusters. The same data is used both for discovery and testing, and this means that the p-values from the differential expression analysis will not be uniform under the null.  This will produce a lot of findings with small p-values even in the absence of true biological differences.}
\item{The \code{dreamlet} package is designed for large datasets with many subjects.  The sample sizes from cohort studies are an order of magnitude larger than typical single cell studies.  This means that these analyses have huge power to detect even subtle difference in expression between cell clusters.  While cluster-specific marker genes are often discovered from an handful of samples, the \code{dreamlet} package is applicable to 100s or 1000s of subjects.}
}

\code{method} indicates the regression method used to test differential expression between sets of cell clusters.  Since the same biosample will usually be represented in both sets of cell clusters, \code{method} determines how the paired design is modeled.   For \code{method = "mixed"}, the sample is modeled as a random effect: \code{~ (1|Sample) + ...}. For \code{method = "fixed"}, the sample is modeled as a fixed effect: \code{~ Sample + ...}. For \code{method = "none"}, the pairing is ignored.

When \code{collapse=TRUE} (default) combine all cell clusters within the test set, and separately the baseline set, and estimate a coefficient indicating the differential expression between sets for a given gene.  If \code{collapse=FALSE}, estimate a coefficient for each cell type and then identify differential expression using linear contrasts with \code{variancePartition::makeContrastsDream()}.
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

# Evaluate the specificity of each gene for each cluster
df_cts <- cellTypeSpecificity(pb)

# compare first two assays (i.e. cell types)
ct.pairs <- c("B cells", "CD14+ Monocytes")

# run comparison
# use method = 'fixed' here since it is faster
fit <- dreamletCompareClusters(pb, ct.pairs, method = "fixed")

# Extract top 10 differentially expressed genes
# The coefficient 'compare' is the value logFC between test and baseline:
# compare = cellClustertest - cellClusterbaseline
res <- topTable(fit, coef = "compare", number = 10)

# genes with highest logFC are most highly expressed in
# B cells compared to CD14+ Monocytes
head(res)

dreamlet::plotHeatmap(df_cts, genes = rownames(res)[1:5])

# compare B cells versus the rest of the cell types
# 'rest' is a keyword indicating all other assays
fit <- dreamletCompareClusters(pb, c("B cells", "rest"), method = "fixed")

res <- topTable(fit, coef = "compare", number = 10)

# genes with highest logFC are most highly expressed in
# B cells compared to all others
head(res)

# Get genes upregulated in B cells
idx <- with(res, which(logFC > 0))[1:5]
dreamlet::plotHeatmap(df_cts, genes = rownames(res)[idx])

lst <- list(
  test = c("CD14+ Monocytes", "FCGR3A+ Monocytes"),
  baseline = c("CD4 T cells", "CD8 T cells")
)

# compare 2 monocyte clusters to two T cell clusters
fit <- dreamletCompareClusters(pb, lst, method = "fixed")

res <- topTable(fit, coef = "compare", number = 10)

# genes with highest logFC are most highly expressed in
# monocytes compared to T cells
head(res)

# Get genes upregulated in monocytes
idx <- with(res, which(logFC > 0))[1:5]
dreamlet::plotHeatmap(df_cts, genes = rownames(res)[idx])

}
