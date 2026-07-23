# Scripts Documentation

This directory contains the R scripts used to read, clean, analyze, and visualize the opihi morphology and microhabitat data. The current scripts are designed for interactive use in RStudio: each script sets its working directory with `rstudioapi::getActiveDocumentContext()`.

For reproducible manuscript workflows, preserve raw files in `../data/`, regenerate derived results from scripts, and record any changes to cleaning rules or figure generation in version control.

## `readOpihiMicrohabitat.R`

### Purpose

Loads the primary morphology and microhabitat data, cleans column names, standardizes shell measurements, derives morphology indices, and creates the main analysis object `data_opihi_microhabitat`.

### Inputs

- `../data/DataOpihiMorphologyMicrohabitat.csv`: individual morphology and microhabitat observations.
- `../data/sample_name_decode.tsv`: sample/site metadata lookup, loaded as `data_name_decode`.

### Main Operations

- Installs and loads `tidyverse`, `janitor`, `cubature`, `rlang`, and `readxl` if needed.
- Defines `SurfArea()` to estimate lateral surface area of an elliptical cone.
- Defines `normalizeCharacter()` to allometrically normalize shell traits by length.
- Converts raw `Length`, `Width`, and `HeightWW` values to centimeters.
- Cleans distance fields and applies a note-based `0.15` correction where indicated.
- Derives `dist_to_shelter`, shell shape indices, estimated surface area, cross-sectional area, thermal dissipation index, and normalized versions of those metrics.

### Outputs

This script does not write files. It creates R objects in the session:

- `data_name_decode`
- `data_opihi_microhabitat`
- helper functions `SurfArea()` and `normalizeCharacter()`

### Example Run

In RStudio, open `scripts/readOpihiMicrohabitat.R`, make it the active editor tab, then run:

```r
source("readOpihiMicrohabitat.R")
```

After sourcing, validate the result:

```r
dim(data_opihi_microhabitat)
names(data_opihi_microhabitat)
summary(data_opihi_microhabitat$thermal_dissipation_index_normalized)
```

## `visualizeOpihiMicrohabitat.R`

### Purpose

Generates exploratory plots, linear model summaries, PCA plots, and manuscript-relevant visualizations from `data_opihi_microhabitat`.

### Inputs

- `readOpihiMicrohabitat.R`, sourced at runtime.
- Indirectly uses `../data/DataOpihiMorphologyMicrohabitat.csv` and `../data/sample_name_decode.tsv` through the read script.

### Main Operations

- Loads the cleaned analysis data by sourcing `readOpihiMicrohabitat.R`.
- Defines plotting helpers `ScatterPlot()`, `BoxPlot()`, and `DensPlot()`.
- Fits exploratory linear models relating normalized thermal dissipation to shelter distance and site.
- Generates scatterplots and boxplots for shell morphology metrics.
- Runs PCA on raw shell characters, normalized shell characters, and non-morphological microhabitat parameters.
- Computes site-level deviation from mean normalized surface area and tests differences by refuge availability.

### Outputs

Writes figures to `../output/`, including:

- `indiv_id-vs-thermal_dissipation_index_normalized-scatter.png`
- `height_ww-vs-length_scatter.png`
- `height_ww_normalized-vs-site-boxplot.png`
- `height_index_normalized-vs-site-boxplot.png`
- `est_surface_area_cm2_normalized-vs-site-boxplots.png`
- `thermal_dissipation_index_normalized-vs-site-boxplot.png`
- `pca_1-2_shell_characters.png`, `pca_1-3_shell_characters.png`, `pca_2-3_shell_characters.png`
- `pca_1-2_normalized_shell_characters.png`, `pca_1-3_normalized_shell_characters.png`, `pca_2-3_normalized_shell_characters.png`
- `pca_1-2_non_morphological.png`, `pca_1-3_non_morphological.png`, `pca_2-3_non_morphological.png`
- `normalized_mean_surface_area_deviation-site.png`
- `hindex_windex.png`

### Example Run

In RStudio, open `scripts/visualizeOpihiMicrohabitat.R`, make it the active editor tab, then run:

```r
source("visualizeOpihiMicrohabitat.R")
```

Check that expected outputs were regenerated:

```r
list.files("../output", pattern = "\\.(png|pdf)$")
```

## Dependencies and Known Reproducibility Notes

- These scripts currently depend on RStudio path behavior. A future improvement would be to replace `setwd(dirname(rstudioapi::getActiveDocumentContext()$path))` with a project-root-aware path helper such as `here::here()`.
- `visualizeOpihiMicrohabitat.R` uses `ggbiplot`; depending on the R environment, this package may need to be installed from GitHub rather than CRAN.
- `visualizeOpihiMicrohabitat.R` calls `leveneTest()` but does not explicitly load the package that provides it, typically `car`. Load or add `car` before running that section.
- The scripts install missing packages during execution. For fully reproducible manuscript work, record exact R and package versions with `sessionInfo()` after successful runs.
- Figure files in `../output/` should be treated as derived artifacts that can be regenerated from scripts and raw data.
