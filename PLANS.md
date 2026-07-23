# Project Plans

Save all project plans in this file. Prepend new plans so they appear in reverse
chronological order. Timestamp each plan with local date, time, and time zone.
Milestones begin unchecked and should be changed to `[x]` only after the stated
work has been completed and verified.

## 2026-07-23 12:19 CDT - Improve Thermal Refuge and Shell Morphology Analysis

### Objective

Replace the current primarily exploratory comparisons with a reproducible,
hierarchical analysis of the association between microhabitat access to thermal
refuges and shell traits related to heat exchange. The directional hypothesis
is that limpets with greater refuge access have lower size-adjusted shell
surface area and lower morphological capacity to dissipate thermal energy.
Because habitat and morphology were measured concurrently, results will be
described as associations rather than causal effects.

### Milestones

- [ ] **Define the confirmatory hypotheses and outcomes.** Use observed
  `refuge_category` as the confirmatory exposure. Compare `exposed` with
  `refuge`; exclude the eight `exposed/refuge` edge observations from the
  primary contrast and include them in an ordered sensitivity analysis. Treat
  corrected lateral shell surface area and exposed-area-to-footprint ratio as
  co-primary outcomes. State the expected direction before fitting models and
  apply Holm correction across the two primary tests.

- [ ] **Audit and freeze the analysis data.** Validate all 123 records and
  produce an analysis-flow table. Distinguish structural missingness, true
  absence, and unknown values; do not impute morphology or refuge class.
  Standardize distance units while preserving the raw fields. Record that
  negative distances point downward and positive distances point upward, use
  absolute distance for proximity, and retain direction as a separate
  descriptor. Correct the `LaPersouse`/`LaPerouse` naming mismatch, preserve
  `toofar` as flagged missing data, and define sampling blocks as
  `site + GPSwpt` because waypoint numbers are not globally unique.

- [ ] **Correct and validate the geometric traits.** Model the shell as an
  elliptical cone using `Length/2` and `Width/2` as semi-axes. Calculate lateral
  area, basal footprint area `pi(Length/2)(Width/2)`, cone volume, lateral
  area-to-footprint ratio, and surface-area-to-volume ratio. Replace the
  current full-diameter inputs and inconsistent normalized denominator. Test
  the area function against the closed-form circular-cone result and verify
  units, positivity, and plausible ranges. Use log shell length as an
  allometric covariate rather than relying only on pooled normalized traits.

- [ ] **Describe the sampling design and data quality.** Summarize sites,
  waypoint blocks, refuge classes, missingness, predictor correlations, and
  outcome distributions. Plot raw observations and size-adjusted outcomes,
  including connected observations within exposed/refuge waypoint blocks.
  Investigate influential values against field notes and retain valid extreme
  observations. The current data imply a primary complete-case cohort of 57
  individuals across four sites and 33 blocks, with a paired sensitivity
  subset of 35 individuals in 16 blocks; recompute and report these counts from
  the finalized data.

- [ ] **Fit the primary hierarchical models.** For each co-primary outcome, fit
  `log(outcome) ~ refuge_status + log(length_cm) + site + (1 | site_waypoint)`.
  Report exponentiated effect estimates as percent differences with 95%
  confidence intervals, adjusted tests, and sample sizes. If the waypoint
  random effect is singular, use a site-fixed linear model with CR2
  waypoint-clustered standard errors. Repeat the analysis with waypoint fixed
  effects in the paired subset and assess whether the refuge association varies
  materially among the four represented sites.

- [ ] **Analyze continuous thermal-refuge mechanisms.** Fit pre-specified
  secondary models for absolute distance to open water, distance to
  *Littoraria pintado*, surface angle with a change in slope at 90 degrees, and
  relative seaward orientation calculated as
  `cos((CompassSurf - CompassOcean) * pi/180)`. Interpret proximity to
  *L. pintado* as a high-shore thermal-stress proxy. Use distance to living
  crustose coralline algae as an alternate wetting proxy rather than placing it
  in the same model as open-water distance when collinearity is high. Label
  analyses of shelter distance, under-rock distance, shelter type, path to
  ocean, overhang, and movable rock as secondary or sparse-data analyses.

- [ ] **Evaluate substrate and shell solar absorption.** Treat substrate
  primarily as site context because substrate categories are largely
  confounded with site; make the adjacent Kahului basalt-versus-concrete
  comparison exploratory. Parse rib black percentage and erosion into an
  effective dark-surface proxy:
  `black_fraction * (1 - erosion_fraction)`. Use bounded sensitivity analyses
  for erosion values recorded as `<1` and `<5`. Analyze this proxy as a
  separate thermal phenotype or exploratory effect modifier, not as a routine
  adjustment in the primary morphology models. Keep inter-rib color
  descriptive until a reproducible color-to-absorptivity classification is
  documented.

- [ ] **Replace the site-level refuge comparison.** Do not test a site-level
  exposure using individual deviations from site means. Treat the existing
  five-site `More refuge` versus five-site `Less refuge` grouping as
  descriptive unless its biological provenance is documented. If validated,
  compare equal-weighted site summaries with an exact site-level permutation
  test and clearly state that the independent sample size is ten sites.

- [ ] **Assess model validity, robustness, and precision.** Check residual
  distributions, heteroscedasticity, influential observations, random-effect
  stability, and leave-one-site-out estimates. Use false-discovery-rate
  correction for families of secondary tests. Quantify precision or minimum
  detectable effects with simulation instead of reporting post-hoc observed
  power. Clearly distinguish confirmatory, sensitivity, and exploratory
  results.

- [ ] **Make the workflow fully reproducible.** Refactor data preparation,
  model fitting, and figure generation into root-runnable scripts. Remove
  package installation from analysis runs, use project-relative paths, record
  package versions in a lockfile, set random seeds, and capture
  `sessionInfo()`. Export the finalized derived dataset, coefficient tables,
  diagnostics, and manuscript-ready figures. Add automated tests for geometry,
  units, identifiers, categories, analysis counts, and expected output files.
  Update the relevant directory documentation with methods, results, and exact
  reproduction commands.

### Completion Criteria

The plan is complete when a fresh R environment can reproduce the cleaned
analysis data, model tables, diagnostics, and figures from repository-root
commands; all primary estimates include uncertainty and account for site and
waypoint structure; sensitivity results are clearly separated from primary
inference; raw data remain unchanged; and every milestone above is checked.
