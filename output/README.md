# Output Directory Documentation

This directory contains figures generated from the opihi morphology and microhabitat analysis scripts. The PNG files are derived outputs and should be reproducible from `../scripts/visualizeOpihiMicrohabitat.R` after sourcing `../scripts/readOpihiMicrohabitat.R`.

## Results Summary

The figures summarize 123 individual observations across 10 site labels. Shell height increases with shell length, confirming strong size-related structure in the raw morphology data. After allometric normalization, sites still differ in height, surface area, and thermal dissipation indices, suggesting that shape variation remains after accounting for shell length. PCA plots show that raw shell-character PC1 is strongly dominated by overall shell size, while normalized shell-character PCA emphasizes shape and index differences. Microhabitat PCA shows broader overlap among sites and weaker separation than the shell-character PCA. Thermal dissipation plots suggest site-specific variation and noisy relationships with shelter distance, so these figures should be interpreted as exploratory unless paired with the model outputs and assumptions from the analysis script.

The directory also contains `thermal_index_2017-2023_comparison.pdf`, which is not rendered below because this README catalogs PNG figures only.

## Figure Catalog

### Figure 1. Shell Height Scales With Shell Length

<img src="height_ww-vs-length_scatter.png" alt="Figure 1. Shell height versus shell length scatterplot" width="650">

Scatterplot of shell height measured widest-way against shell length, colored by site, with linear smooths. The figure shows a positive relationship between length and height and highlights size differences among sampled sites.

### Figure 2. Width Index Versus Height Index

<img src="hindex_windex.png" alt="Figure 2. Width index versus height index" width="650">

Scatterplot comparing normalized width index and normalized height index for individual shells. This figure summarizes shell shape variation after normalization.

### Figure 3. Normalized Shell Height by Site

<img src="height_ww_normalized-vs-site-boxplot.png" alt="Figure 3. Normalized shell height by site" width="650">

Boxplots of normalized shell height by site. The plot shows site-level variation in shell height after accounting for shell length.

### Figure 4. Normalized Height Index by Site

<img src="height_index_normalized-vs-site-boxplot.png" alt="Figure 4. Normalized height index by site" width="650">

Boxplots of normalized height index by site. This figure compares relative shell height across sites rather than raw body size.

### Figure 5. Normalized Estimated Surface Area by Site

<img src="est_surface_area_cm2_normalized-vs-site-boxplots.png" alt="Figure 5. Normalized estimated surface area by site" width="650">

Boxplots of estimated normalized shell surface area by site. The figure is used to compare surface-area-related morphology among locations after length normalization.

### Figure 6. Normalized Thermal Dissipation Index by Site

<img src="thermal_dissipation_index_normalized-vs-site-boxplot.png" alt="Figure 6. Normalized thermal dissipation index by site" width="650">

Boxplots of normalized thermal dissipation index by site. Higher values indicate greater estimated surface area relative to cross-sectional area.

### Figure 7. Surface Area Deviation by Refuge Availability

<img src="normalized_mean_surface_area_deviation-site.png" alt="Figure 7. Surface area deviation by refuge availability" width="650">

Site-level boxplots of deviation from mean normalized surface area, grouped by the script-defined refuge availability category. The figure suggests higher positive deviations in the “less refuge” group.

### Figure 8. Raw Shell PCA, PC1 Versus PC2

<img src="pca_1-2_shell_characters.png" alt="Figure 8. Raw shell PCA PC1 versus PC2" width="650">

PCA biplot of raw shell morphology variables showing PC1 and PC2, grouped by site with ellipses. PC1 captures most raw morphological variation and appears strongly size-related.

### Figure 9. Raw Shell PCA, PC1 Versus PC3

<img src="pca_1-3_shell_characters.png" alt="Figure 9. Raw shell PCA PC1 versus PC3" width="650">

PCA biplot of raw shell morphology variables showing PC1 and PC3. This view helps evaluate secondary axes of variation after the dominant size axis.

### Figure 10. Raw Shell PCA, PC2 Versus PC3

<img src="pca_2-3_shell_characters.png" alt="Figure 10. Raw shell PCA PC2 versus PC3" width="650">

PCA biplot of raw shell morphology variables showing PC2 and PC3. This figure emphasizes non-PC1 variation and site overlap.

### Figure 11. Normalized Shell PCA, PC1 Versus PC2

<img src="pca_1-2_normalized_shell_characters.png" alt="Figure 11. Normalized shell PCA PC1 versus PC2" width="650">

PCA biplot of normalized shell traits and indices showing PC1 and PC2. This view focuses on shape and thermal-index variation after allometric adjustment.

### Figure 12. Normalized Shell PCA, PC1 Versus PC3

<img src="pca_1-3_normalized_shell_characters.png" alt="Figure 12. Normalized shell PCA PC1 versus PC3" width="650">

PCA biplot of normalized shell traits showing PC1 and PC3. The plot provides an alternate view of site clustering and outliers in normalized morphology.

### Figure 13. Normalized Shell PCA, PC2 Versus PC3

<img src="pca_2-3_normalized_shell_characters.png" alt="Figure 13. Normalized shell PCA PC2 versus PC3" width="650">

PCA biplot of normalized shell traits showing PC2 and PC3. This plot highlights secondary shape axes with substantial site overlap.

### Figure 14. Non-Morphological PCA, PC1 Versus PC2

<img src="pca_1-2_non_morphological.png" alt="Figure 14. Non-morphological PCA PC1 versus PC2" width="650">

PCA biplot of non-morphological microhabitat variables showing PC1 and PC2. The site ellipses overlap broadly, indicating that these variables do not separate sites as cleanly as raw shell morphology.

### Figure 15. Non-Morphological PCA, PC1 Versus PC3

<img src="pca_1-3_non_morphological.png" alt="Figure 15. Non-morphological PCA PC1 versus PC3" width="650">

PCA biplot of non-morphological microhabitat variables showing PC1 and PC3. This alternate component view shows variation associated with distance and compass-direction variables.

### Figure 16. Non-Morphological PCA, PC2 Versus PC3

<img src="pca_2-3_non_morphological.png" alt="Figure 16. Non-morphological PCA PC2 versus PC3" width="650">

PCA biplot of non-morphological microhabitat variables showing PC2 and PC3. The figure illustrates secondary microhabitat gradients and continued site overlap.

### Figure 17. Normalized Thermal Dissipation by Individual ID

<img src="indiv_id-vs-thermal_dissipation_index_normalized.png" alt="Figure 17. Normalized thermal dissipation by individual ID" width="650">

Faceted plot of normalized thermal dissipation index against individual ID by site. The figure is useful for identifying within-site patterns and potential outliers.

### Figure 18. Normalized Thermal Dissipation Scatterplot

<img src="indiv_id-vs-thermal_dissipation_index_normalized-scatter.png" alt="Figure 18. Normalized thermal dissipation scatterplot by individual ID" width="650">

Scatterplot version of normalized thermal dissipation index against individual ID. This output supports visual comparison of the same response variable across individuals and sites.

### Figure 19. Normalized Thermal Dissipation Versus Shelter Distance

<img src="thermal_dissipation_index_normalized-dist_to_shelter-lin_mod.png" alt="Figure 19. Normalized thermal dissipation versus distance to shelter" width="650">

Faceted linear-model plot of normalized thermal dissipation index against distance to shelter. The relationships appear site-specific and noisy, with wide uncertainty in sites with limited observations.
