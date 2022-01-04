
<!-- README.md is generated from README.Rmd. Please edit that file -->

# anpan

<!-- badges: start -->
<!-- badges: end -->

The goal of anpan is to consolidate statistical methods for strain
analysis. This includes testing genetic elements for association with
outcomes, phylogenetic association testing, and ….

## Requirements

anpan requires the following R packages, most of which which can be
installed from CRAN:

    install.packages(c("brms", 
                       "data.table", 
                       "dplyr", 
                       "purrr", 
                       "tibble", 
                       "tidyr", 
                       "furrr", 
                       "ggnewscale",
                       "patchwork", 
                       "progressr"))

    install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))

If the `cmdstanr` installation doesn’t work you can find more detailed
instructions [at this link](https://mc-stan.org/cmdstanr/).

## Installation

You can install anpan from github with:

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
library(furrr); plan(multisession, workers = 2) # Run on two cores
library(progressr); handlers(global=TRUE) # show progress bars for long computations
library(anpan)


anpan_batch(bug_dir = "/path/to/gene_families/",
            meta_file = "/path/to/metadata.tsv",
            out_dir = "/path/to/output",
            annotation_file = "/path/to/annotation.tsv", #optional, used for plots
            filtering_method = "kmeans",
            model_type = "glm",
            covariates = c("age", "gender"),
            plot_ext = "pdf",
            save_filter_stats = TRUE)
```

This will create the output directory with tables of regression
coefficients, top-results plots, and filter statistics.
