
<!-- README.md is generated from README.Rmd. Please edit that file -->

# anpan <img src="man/figures/logo.png" align="right"/>

<!-- badges: start -->
<!-- badges: end -->

The goal of anpan is to consolidate statistical methods for strain
analysis. This includes automated filtering of metagenomic functional
profiles, testing genetic elements for association with outcomes, and
phylogenetic association testing.

## Dependencies

anpan depends on the following R packages, most of which are available
through CRAN (the exception being cmdstanr):

    install.packages(c("ape", 
                       "broom",
                       "data.table", 
                       "dplyr", 
                       "fastglm",
                       "furrr", 
                       "ggdendro",
                       "ggnewscale",
                       "ggplot2",
                       "loo",
                       "patchwork", 
                       "progressr",
                       "purrr", 
                       "R.utils",
                       "readr",
                       "stringr",
                       "tibble", 
                       "tidyr")) # add Ncpus = 4 to go faster

    install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))

If the `cmdstanr` installation doesn’t work you can find more detailed
instructions [at this link](https://mc-stan.org/cmdstanr/). Once you’ve
installed `cmdstanr`, you will need to use it to install CmdStan:

    library(cmdstanr)
    check_cmdstan_toolchain()
    install_cmdstan(cores = 2)

## Installation

Once you have the dependencies, you can install anpan from github with:

``` r
devtools::install("biobakery/anpan")
```

## Example - element testing

You can filter large uniref tables and look for associations with
outcomes (while controlling for covariates) with `anpan_batch`. Right
now this only works for glm-based models.

``` r
library(tidyverse)
library(data.table)

library(furrr) 
plan(multisession, workers = 2) # Run with two parallel R sessions on the local machine

library(progressr)
handlers(global=TRUE) # show progress bars for long computations

library(anpan)


anpan_batch(bug_dir = "/path/to/gene_families/",
            meta_file = "/path/to/metadata.tsv",
            out_dir = "/path/to/output",
            annotation_file = "/path/to/annotation.tsv", #optional, used for plots
            filtering_method = "kmeans",
            model_type = "fastglm",
            covariates = c("age", "gender"),
            outcome = "crc",
            plot_ext = "pdf",
            save_filter_stats = TRUE)
```

This will create the output directory with tables of regression
coefficients, top-results plots, and filter statistics.

## Example - phylogenetic generalized linear mixed model

You can run a PGLMM with the `anpan_pglmm` function. This fits a model
where the covariance matrix of outcomes is determined from the
phylogenetic tree. Right now there’s only gaussian outcomes, and no
regularization on the covariance matrix.

``` r
meta_file = "/path/to/metadata.tsv" 
tree_file = "/path/to/file.tre"

anpan_pglmm(meta_file,
            tree_file,
            trim_pattern = "_bowtie2",
            covariates = NULL,
            plot_cov_mat = TRUE,
            outcome = "age",
            verbose = TRUE,
            cores = 4)
```

## FAQ

> What’s with the name?

The name “anpan” was chosen to fit into the
[biobakery](https://huttenhower.sph.harvard.edu/tools/) bread theme and
because it’s short and easy to pronounce and remember. Also, [real
anpan](https://duckduckgo.com/?q=anpan&t=h_&iax=images&ia=images) are
delicious.

There’s no backronym, but if you think of a good one let me know.

Capitalization of the name follows [the xkcd
rule](https://xkcd.com/about/). All lowercase “anpan” is preferred, and
all uppercase “ANPAN” is acceptable in formal contexts or the start of a
sentence, but mixed-case “Anpan” should be avoided.
