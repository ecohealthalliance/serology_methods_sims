
#### Most recent note/work update

- September 26: Some reorganization to use cmdstanr, compile models only
  once, and save just samples instead of the full stan model in the
  hopes that this will resolve the issues I had with tar_make_future
  slowing to near 0 after some hours of running
- TO DO: Summary plots currently only dependent on a single coefficient
  that will vary among runs, but this won’t be how parameter exploration
  will actually work. Need to work on summary and plotting across a
  variety of parameters

### Simulations to compare alternative methods of analyzing serology data

#### Project Vision/Objectives

- Show under coverage of two-step cluster + regression
- Illustrate potential of Bayesian clustering models that simultaneously
  consider covariates that affect grouping and values within those
  groups

#### Repository Structure and Reproducibility

- `data/` contains data (empirical and/or saved simulated)
- `R/` contains functions used in this analysis.
- `stan_models/` contains stan model definitions
- `reports/` contains literate code for R Markdown reports generated in
  the analysis
- `outputs/` contains compiled reports and figures.
- This project uses the `targets` package to create its analysis
  pipeline. The steps are defined in the `_targets.R` file and the
  workflow can be executed by running `targets::tar_make()`.

#### A coverage plot from some initial simulations

<img src="outputs/examp_sims.png" width="75%" />
