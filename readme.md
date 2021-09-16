
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Development of an ensemble machine learning prognostic model for predicting 60-day risk of major adverse cardiac events in adults with chest pain

**Authors**: Chris J. Kennedy, Dustin G. Mark, Jie Huang, Mark J. van
der Laan, Alan E. Hubbard, Mary E. Reed

## Software requirements

This code is intended to run on R 4.0.4. Exact version numbers for all
software packages are listed in the renv.lock file.

## Installation guide

Open the repository as an RStudio project, which will activate `renv`.
Then run:

``` r
renv::restore()
```

This will install all necessary packages with the correct versions. It
will take about 30 minutes to run.

## Reproducing manuscript results

The following data files (EHR exports) need to be placed in the
`data-raw` directory:

-   data\_grace3.sas7bdat - main data file
-   \_outrace.sas7bdat - patient race
-   \_outgfr.sas7bdat - eGFR
-   \_outbmi.sas7bdat - BMI
-   \_lab\_vdw.sas7bdat - A1C, HDL, LDL, triglycerides
-   chestpaindata.sas7bdat - MACE+ supplemental outcome

Then knit the scripts in the following order:

1.  import-data.Rmd
2.  estimator-superlearner.Rmd - takes 3+ days to run, depending on CPU
    cores.
3.  variable-importance.Rmd
4.  interpretation.Rmd
5.  decision-analysis.Rmd

Note: in import-data.Rmd the GLRM grid search is disabled by default due
to its CPU-intensive nature. To re-enable it, go to the section
`glrm_grid_search` and set eval = TRUE the RMarkdown header (current
value is FALSE).

## ck37r package

Examples and demonstration results for the accompanying `ck37r` package
are provided in its [github repository](https://github.com/ck37/ck37r).

## License

The contents of this repository are distributed under the MIT license.

© Chris J. Kennedy, 2021
