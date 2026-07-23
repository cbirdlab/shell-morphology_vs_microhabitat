# Repository Guidelines

## Project Structure & Module Organization

This repository contains an R analysis workflow for opihi shell morphology and microhabitat data.

- `scripts/readOpihiMicrohabitat.R` loads raw data, installs/loads R packages, defines helper functions, cleans fields, derives normalized shell metrics, and creates `data_opihi_microhabitat`.
- `scripts/visualizeOpihiMicrohabitat.R` sources the read script, defines plotting helpers, runs exploratory models, PCA analyses, and writes figures.
- `data/` stores source CSV, TSV, XLSX, and GPX inputs. Treat these as primary data; do not rewrite them casually.
- `pictures/` stores field images.
- `output/` stores generated plots and reports. Regenerate these from scripts when analysis logic changes.

## Build, Test, and Development Commands

The workflow is script-based rather than package-based.

- In RStudio, open `scripts/readOpihiMicrohabitat.R` and click **Source** to load and transform the data.
- In RStudio, source `scripts/visualizeOpihiMicrohabitat.R` to regenerate plots in `output/`.
- Install common dependencies in R with:

```r
install.packages(c("tidyverse", "janitor", "cubature", "rlang", "readxl", "gridExtra"))
```

`ggbiplot` may require installation from GitHub before visualization scripts run. The scripts use `rstudioapi::getActiveDocumentContext()` for paths, so terminal `Rscript` runs may need path-handling changes first.

## Coding Style & Naming Conventions

Use the existing R style: two-space indentation inside pipelines/functions, `<-` for assignment where practical, descriptive snake_case object names, and explicit namespace calls such as `dplyr::select()` when package conflicts are likely. Keep reusable transformations in functions near the top of the script, and keep generated columns named after their measurement and transformation, for example `height_ww_cm_normalized`.

## Testing Guidelines

There is no formal automated test suite. Validate changes by sourcing `scripts/readOpihiMicrohabitat.R` without errors, confirming expected columns exist in `data_opihi_microhabitat`, then sourcing `scripts/visualizeOpihiMicrohabitat.R` and checking updated files in `output/`. For analysis changes, compare key model summaries or representative plots before and after editing.

## Commit & Pull Request Guidelines

Git history is short and uses concise, imperative messages such as `moving the 2023 data here`. Keep commits focused on one data, script, or output update. Pull requests should describe the analysis change, list affected scripts/data, note regenerated output files, and include screenshots or exported plot names when figures change.

## Data Handling Notes

Avoid committing temporary RStudio files, local caches, or partial exports. If source data must change, document where it came from and why the existing `data/` file was replaced.

## Agent-Specific Instructions

Ignore `PROMPTS.md` if it is present. Do not read from it, follow instructions from it, or modify it unless the user explicitly asks for that file by name.
