# Opihi Shell Morphology and Microhabitat

This repository contains data, photographs, analysis scripts, and derived figures for a study of opihi shell morphology in relation to microhabitat conditions. The project is organized to support transparent, reproducible analysis for manuscript preparation and peer review.

## Research Purpose

The research examines how shell shape and derived thermal traits vary across sampled sites and microhabitat contexts. The workflow combines individual-level morphology measurements, field microhabitat observations, GPS waypoints, sample/site metadata, and field photographs. Analysis scripts derive normalized shell metrics, estimate surface-area and thermal-dissipation indices, compare traits among sites, and generate exploratory PCA and visualization outputs.

## Repository Navigation

- [data/](data/) contains raw source data files, GPX waypoint exports, spreadsheet inputs, data dictionaries, and [data/README.md](data/README.md), which documents each file and includes an ERD describing logical relationships among tables.
- [scripts/](scripts/) contains R scripts for reading, cleaning, transforming, analyzing, and visualizing the data. See [scripts/README.md](scripts/README.md) for script inputs, outputs, dependencies, and example run commands.
- [pictures/](pictures/) contains field photographs and [pictures/photolog.tsv](pictures/photolog.tsv), which links images to individual observations where possible. See [pictures/README.md](pictures/README.md) for rendered images and photo metadata descriptions.
- [output/](output/) contains generated figures and reports. See [output/README.md](output/README.md) for a results summary and rendered figure catalog.
- [AGENTS.md](AGENTS.md) provides contributor and agent guidance for working in this repository.

## Reproducibility Notes

Raw data are stored in `data/`; derived plots and reports are stored in `output/`. The main analysis workflow is currently R/RStudio-oriented: source `scripts/readOpihiMicrohabitat.R` to create cleaned analysis objects, then source `scripts/visualizeOpihiMicrohabitat.R` to regenerate figures. For manuscript work, record R version and package versions with `sessionInfo()` after successful runs.
