# Prompts

## Prompt 7: Plan

Given the data, the present analyses, and results, make a plan to improve the analysis of this data.  We are primarily interested in testing for a relationship between shell surface area and other morphological indicies of ability to dissipate thermal energy in relationship with the microhabitat characteristics where each limpet was found.  We hypothesize the more access to thermal refuges will result in shells with less surface area and less ability to dissipate thermal energy.  Document your plan in PLANS.md.  Update the AGENTS.md to note that all plans should be saved to PLANS.md.  They should be time and date stamped, in reverse chronological order so that the newest plan is at the top.  Each plan should have milestones with checkboxes that are updated to be checked when the mileston is achieved. 

### extra prompt after issuing prompt above:
let me know if you cannot access a file or view an image and I will install the software needed

### responses to questions: 

disttounderrock, the compass heading of the rock surface the limpet was on, the compass heading perpendicular to the shore    aspect (the compassocean), color ribs and erosion is important because 	-0.5	312	9if a shell is uneroded (0) and 100black on colorribs,    then it's whole dorsal shell surface is black, but if the erosion is 50, the 50% of the dorsal surface is a lighter caco3 color.    color interribs is also affected by erosion.  rockmove is to determine if the limpet might sense boulders and thereby exibit a    morphology that assumes temp refuge nearby.  substrate is also important because basalt is black and will heat up more in the    sun than concrete, etc.

exposed/refuge means the limpet was on the edge between exposed and refuge

negative values mean that the distances is downwards from where the limpet is.  Positive vals mean up.  for surf angle, 0 is    horizontal, 90 is vertical, past 90 means the limpet is under an overhang. I just noticed that I skipped some dist to's. Litt    pinn is littoraria pintado, a extremophile high shore snail so the closer to lit pinn presumably the more thermal stress.    disttocrustose refers to live crustose coralline algae which needs to be wetted to survive, so closer to crustose means less    thermal stress.  shelter type may also matter.  under rock is better shelter than crevice in most cases.
	
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

