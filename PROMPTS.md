# Prompts

## Prompt 6: Make `README.md`

Make `README.md`.  Provide a summary of this repo, the purpose of the research and provide the reader with the ability to navigate throught the repo with links to each of the dirs

## Prompt 5: Make `output/README.md`

Make `output/README.md`.  Provide a summary of the results.  Render each `*.png` in the readme, and include a figure label and description for each.  e.g.  Figure 1.  ...

## Prompt 4: Make `pictures/README.md`

Make `pictures/README.md` . In this file, render each image in the dir, and label it with the Individual, location, date and time.  Also describe the contents of  `pictures/photolog.tsv`

## Prompt 3: Make `pictures/photolog.tsv`

Make the file `pictures/photolog.tsv`.  I want you to use the information stored in the photos to associate them with particular individuals in `data/OpihiMorpholoygMicrohabitat.csv`

	-0.78	96	110	15-16	100black	0	tan	n	basalt	all dist 0.15ft longer than should be	n	boulder	NA	NA	NA	bb---
	-0.78	96	110	15-16	100black	0	tan	n	basalt	all dist 0.15ft longer than should be	n	boulder	NA	NA	NA	bb
## Prompt 2: Make scripts/README.md`

Make the file `scripts/README.md`.   We need to follow best practices in data science, transparency, and reproducability. I want you to describe each script, what it does, the inputs and outputs, and give an example of how to run it.

---

## Prompt 1: Make a readme

Make the file `data/README.md`. In this file, I want you to document each of the data files in the `data` dir.  I want you to create an ERD, where appropriate, to demonstrate how the data files fit together in a relational database framework.  If a data dictionary does not exist for a file, then please create a `data/*tsv` with 3 columns, one for the "column name", one for the "data description" and one for your level of confidence in the data description.  This is repo contains data and analyses that will be used in a manuscript submitted to a peer reviewed scientific journal.  We need to follow best practices in data science, transparency, and reproducability. Our goal here is to help others understand our data and how it is organized.

