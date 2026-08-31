#### Setup stuff ####
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#### User Defined Variables ####


source("readOpihiMicrohabitat.R")


#### PACKAGES ####
packages_used <- 
  c("ggbiplot", # have to install from github, messes up tidyverse code, have to add dplyr:: to several commands
    "tidyverse",
    "gridExtra")

packages_to_install <- 
  packages_used[!packages_used %in% installed.packages()[,1]]

if (length(packages_to_install) > 0) {
  n_cores <- parallel::detectCores(logical = TRUE)
  n_cores <- max(1L, n_cores - 1L)
  
  install.packages(
    packages_to_install,
    Ncpus = n_cores
  )
}

invisible(
  lapply(
    packages_used,
    library,
    character.only = TRUE
  )
)

#if (length(packages_to_install) > 0) {
#  install.packages(packages_to_install, 
#                   Ncpus = Sys.getenv("NUMBER_OF_PROCESSORS") - 1)
#}

#lapply(packages_used, 
#       require, 
#       character.only = TRUE)

#### Functions ####

ScatterPlot <-
  function(data = data_opihi_microhabitat,
           x_var = length,
           y_var = width,
           color_var = site,
           smooth = TRUE){
    
    x_var = enquo(x_var)
    y_var = enquo(y_var)
    color_var = enquo(color_var)   
    
    if(smooth == TRUE){
      data %>%
        ggplot() +
        aes(x=!!x_var,
            y=!!y_var, 
            color=!!color_var) +
        geom_point() +
        geom_smooth(method=lm)+
        # geom_smooth(method= "nls",
        #             formula = y ~a * x^b,
        #             method.args = list(start=c(a=1,
        #                                        b=1))) +
        theme_classic()
    } else {
      data %>%
        ggplot() +
        aes(x=!!x_var,
            y=!!y_var, 
            color=!!color_var) +
        geom_point() +
        theme_classic()
    }
  }

BoxPlot <-
  function(data = data_opihi_microhabitat,
           x_var = site,
           y_var = est_surface_area_cm2_normalized,
           fill_var = shore_aspect){
    
    x_var = enquo(x_var)
    y_var = enquo(y_var)
    fill_var = enquo(fill_var)
    
    data %>%
      ggplot() +
      aes(x=!!x_var,
          y=!!y_var, 
          fill=!!fill_var) +
      geom_boxplot() +
      theme_classic() +
      theme(axis.text.x = element_text(angle=45,
                                       hjust = 1,
                                       vjust = 1))
    
  }

DensPlot <-
  function(data = data_opihi_microhabitat,
           # panel_var = sampling_site,
           x_var = est_surface_area_cm2_normalized,
           fill_var = shore_aspect){
    
    x_var = enquo(x_var)
    # panel_var = enquo(panel_var)
    fill_var = enquo(fill_var)
    
    data %>%
      ggplot() +
      aes(x=!!x_var,
          # y=!!y_var, 
          fill=!!fill_var) +
      geom_density(position = "identity",
                   alpha = 0.5) +
      theme_classic() 
    # theme(axis.text.x = element_text(angle=45,
    #                                  hjust = 1,
    #                                  vjust = 1))
    
  }

#### Plots Using IndivID or GPS for x ####

data_opihi_microhabitat %>%
  mutate(dist_to_shelter_ft = 
           case_when(!is.na(dist_to_shelter_ft) ~ dist_to_shelter_ft,
                     dist_to_crustose_ft < dist_to_underrock_ft ~ dist_to_crustose_ft,
                     dist_to_underrock_ft < dist_to_crustose_ft ~ dist_to_underrock_ft)) %>%
  ggplot() +
  aes(
    # x = surf_angle,
    # x = dist_to_littpint_ft,
    # x = dist_to_crustose_ft,
    # x = dist_to_shelter_ft,
    # x = dist_to_open_h2o_ft,
    x = individual_id,
    y = thermal_dissipation_index_normalized
    # y = height_index_normalized
    # y = est_surface_area_cm2_normalized
  ) +
  geom_point() +
  #geom_line() +
  geom_smooth(method = "lm") +
  theme_classic() +
  facet_grid(.~site,
             scales = "free_x")
model <- lm(thermal_dissipation_index_normalized ~ dist_to_shelter_ft * 
              site,
            data = data_opihi_microhabitat %>%
              mutate(site = factor(site,
                                   levels = c(
                                     "HonoluaAdjacentInnerSide",
                                     "KahuluiBreakwaterBasaltInside",
                                     "KahuluiBreakwaterConcreteInside",
                                     "Honomanu",
                                     "HanaPalemoHanaBay",
                                     "EastMaui1-RA",
                                     "EastMaui2-RAB",
                                     "LaPerouseBayBench",
                                     "LaPerouseBayCliff",
                                     "MaaleaLighthouse"
                                   ))))
summary(model)

ScatterPlot(x_var = indiv_id,
            y_var = thermal_dissipation_index_normalized)
ggsave("../output/indiv_id-vs-thermal_dissipation_index_normalized-scatter.png")
ScatterPlot(x_var = gp_swpt,
            y_var = thermal_dissipation_index_normalized) 
BoxPlot(y_var = thermal_dissipation_index_normalized,
        fill_var = refuge_category) 

#### Morphological Characters vs Length ####

ScatterPlot(x_var = length_cm,
            y_var = height_ww_cm) 
ggsave("../output/height_ww-vs-length_scatter.png")

#### Normalized Character Box Plots ####

BoxPlot(y_var = height_ww_cm_normalized,
        fill_var = site) 
ggsave("../output/height_ww_normalized-vs-site-boxplot.png",
       width = 4,
       height = 4)
BoxPlot(y_var = height_index_normalized,
        fill_var = site) 
ggsave("../output/height_index_normalized-vs-site-boxplot.png",
       width = 4,
       height = 4)
BoxPlot(y_var = est_surface_area_cm2_normalized,
        fill_var = site)
ggsave("../output/est_surface_area_cm2_normalized-vs-site-boxplots.png")
BoxPlot(y_var = thermal_dissipation_index_normalized,
        fill_var = site)
ggsave("../output/thermal_dissipation_index_normalized-vs-site-boxplot.png",
       width = 4,
       height = 4)

ggplot(data = data_opihi_microhabitat) +
  aes(x = est_surface_area_cm2_normalized,
      fill = site) +
  geom_histogram(alpha = 0.2) +
  theme_classic() +
  theme(axis.text.x = element_text(angle=45,
                                   hjust = 1,
                                   vjust = 1)) +
  facet_wrap(vars(site))

#### PCA Shell Characters ####

# https://github.com/Ph-IRES/workshop_data-analysis/tree/main/tutorial_r_pca

# the size of the opihi will dominate this

#Habitat Variables grouped by Refuge Category
character_pca <-
  data_opihi_microhabitat %>%
  dplyr::select(site,
                length_cm:thermal_dissipation_index,
                -notes) %>%
  na.omit() %>%
  dplyr::select(length_cm:width_index,
                height_ww_cm:thermal_dissipation_index) %>%
  prcomp(center = TRUE,
         scale. = TRUE)

summary(character_pca)

ggbiplot(character_pca,
         # labels = data_opihi_shells %>%
         #   pull(shell_id),
         ellipse = TRUE,
         groups = data_opihi_microhabitat %>%
           dplyr::select(site,
                         length_cm:thermal_dissipation_index,
                         -notes) %>%
           na.omit() %>%
           pull(site),
         choices = c(1,
                     2)) +
  coord_fixed(ratio = .5) + # use this to adjust x vs y axis
  theme_classic() +
  labs(title = "PC1 x PC2",
       subtitle = "Grouped by Site, With Ellipses")

ggsave("../output/pca_1-2_shell_characters.png")

ggbiplot(character_pca,
         # labels = data_opihi_shells %>%
         #   pull(shell_id),
         ellipse = TRUE,
         groups = data_opihi_microhabitat %>%
           dplyr::select(site,
                         length_cm:est_surface_area_cm2) %>%
           na.omit() %>%
           pull(site),
         choices = c(1,
                     3)) +
  coord_fixed(ratio = .67) + # use this to adjust x vs y axis
  theme_classic() +
  labs(title = "PC1 x PC3",
       subtitle = "Grouped by Site, With Ellipses")

ggsave("../output/pca_1-3_shell_characters.png")

ggbiplot(character_pca,
         # labels = data_opihi_shells %>%
         #   pull(shell_id),
         ellipse = TRUE,
         groups = data_opihi_microhabitat %>%
           dplyr::select(site,
                         thermal_dissipation_index:est_surface_area_cm2,
                         -notes) %>%
           na.omit() %>%
           pull(site),
         choices = c(2,
                     3)) +
  coord_fixed(ratio = .75) + # use this to adjust x vs y axis
  theme_classic() +
  labs(title = "PC2 x PC3",
       subtitle = "Grouped by Site, With Ellipses")

ggsave("../output/pca_2-3_shell_characters.png")

#### PCA Normalized Shell Characters ####

normalized_character_pca <-
  data_opihi_microhabitat %>%
  dplyr::select(site,
                width_cm_normalized:thermal_dissipation_index_normalized,
                -notes) %>%
  na.omit() %>%
  dplyr::select(width_cm_normalized:thermal_dissipation_index_normalized,
                height_ww_cm_normalized:thermal_dissipation_index_normalized) %>%
  prcomp(center = TRUE,
         scale. = TRUE)

summary(normalized_character_pca)

###PC1 X PC2

##paneled

#make the same data used to define groups in the PCA plot
pca_groups <- data_opihi_microhabitat %>%
  dplyr::select(
    site,
    width_cm_normalized:thermal_dissipation_index,
    -notes
  ) %>%
  na.omit() %>%
  dplyr::pull(site)


#determine which panel each site belongs to
site_panels <- tibble::tribble(
  ~site,                                  ~panel,
  "KahuluiBreakwaterBasaltInside",        "Kahului",
  "KahuluiBreakwaterConcreteInside",      "Kahului",
  "KahuluiBreakwaterBasaltOutside",       "Kahului",
  
  "EastMaui1-RA",                         "East Maui",
  "EastMaui2-RAB",                        "East Maui",
  "Honomanu",                             "East Maui",
  "HanaPalemoHanaBay",                    "East Maui",
  
  "LaPerouseBayBench",                    "LaPerouse",
  "LaPerouseBayCliff",                    "LaPerouse",
  
  "MaaleaLighthouse",                     "West Maui",
  "HonoluaAdjacentInnerSide",             "West Maui"
)

site_panels

#make pca chart
p <- ggbiplot(
  normalized_character_pca,
  ellipse = TRUE,
  groups = pca_groups,
  choices = c(1, 2)
)

#add the panel assignment to the data stored in the plot
p$data <- p$data %>%
  dplyr::left_join(site_panels, by = c("groups" = "site"))

#plot
p +
  coord_fixed(ratio = 0.5) +
  facet_wrap(~ panel) +
  theme_classic() +
  theme(legend.position = "none") +
  labs(
    title = "PC1 x PC2",
    subtitle = "Grouped by Site, With Ellipses",
    color = "Site"
  )

ggsave("../output/pca_1-2_normalized_shell_characters.png")

##centroids

#make pca chart
p <- ggbiplot(
  normalized_character_pca,
  ellipse = FALSE,
  groups = pca_groups,
  choices = c(1, 2)
)

#centroid calculation
site_centroids <- p$data %>%
  dplyr::group_by(groups) %>%
  dplyr::summarise(
    xvar = mean(xvar),
    yvar = mean(yvar),
    .groups = "drop"
  )

site_centroids

#plot
p_centroids <- ggbiplot(
  normalized_character_pca,
  groups = pca_groups,
  choices = c(1, 2),
  ellipse = FALSE,
  alpha = 0
) +
  geom_point(
    data = site_centroids,
    aes(
      x = xvar,
      y = yvar,
      color = groups
    ),
    size = 4
  ) +
  coord_fixed(ratio = 0.5) +
  theme_classic() +
  labs(
    title = "PC1 x PC2",
    subtitle = "Centroids Grouped by Site",
    color = "Site"
  )

p_centroids

ggsave("../output/pca_1-2_normalized_shell_characters_centroids.png")

###PC1 X PC3

ggbiplot(normalized_character_pca,
         # labels = data_opihi_shells %>%
         #   pull(shell_id),
         ellipse = TRUE,
         groups = data_opihi_microhabitat %>%
           dplyr::select(site,
                         width_cm_normalized:thermal_dissipation_index) %>%
           na.omit() %>%
           pull(site),
         choices = c(1,
                     3)) +
  coord_fixed(ratio = .67) + # use this to adjust x vs y axis
  theme_classic() +
  labs(title = "PC1 x PC3",
       subtitle = "Grouped by Site, With Ellipses")

ggsave("../output/pca_1-3_normalized_shell_characters.png")

ggbiplot(normalized_character_pca,
         # labels = data_opihi_shells %>%
         #   pull(shell_id),
         ellipse = TRUE,
         groups = data_opihi_microhabitat %>%
           dplyr::select(site,
                         width_cm_normalized:thermal_dissipation_index,
                         -notes) %>%
           na.omit() %>%
           pull(site),
         choices = c(2,
                     3)) +
  coord_fixed(ratio = .75) + # use this to adjust x vs y axis
  theme_classic() +
  labs(title = "PC2 x PC3",
       subtitle = "Grouped by Site, With Ellipses")

ggsave("../output/pca_2-3_normalized_shell_characters.png")

#### PCA Non-Morphological Parameters ####

non_morphological_pca <-
  data_opihi_microhabitat %>%
  dplyr::select(
    site,
    surf_angle:dist_to_underrock_ft,
    dist_to_littpint_ft:compass_ocean,
    -notes
  ) %>%
  na.omit() %>%
  dplyr::select(surf_angle:dist_to_underrock_ft,
                dist_to_littpint_ft:compass_ocean) %>%
  dplyr::select(where(~ all(!is.na(.)))) %>%
  dplyr::select(where(~ var(.) != 0)) %>%
  prcomp(center = TRUE,
         scale. = TRUE)

summary(non_morphological_pca)

ggbiplot(non_morphological_pca, 
         ellipse = TRUE,
         groups = data_opihi_microhabitat %>%
           dplyr::select(
             site,
             surf_angle:dist_to_underrock_ft,
             dist_to_littpint_ft:compass_ocean,
             -notes) %>%
           na.omit() %>%
           pull(
             site),
         choices = c(
           1,
           2)) +
  coord_fixed(
    ratio = .5) + # use this to adjust x vs y axis
  theme_classic(
    
  ) +
  labs(
    title = "PC1 X PC2",
    subtitle = "Grouped by Site, With Ellipses")

ggsave("../output/pca_1-2_non_morphological.png")

ggbiplot(non_morphological_pca, 
         ellipse = TRUE,
         groups = data_opihi_microhabitat %>%
           dplyr::select(
             site,
             surf_angle:dist_to_underrock_ft,
             dist_to_littpint_ft:compass_ocean,
             -notes) %>%
           na.omit() %>%
           pull(
             site),
         choices = c(
           1,
           3)) +
  coord_fixed(
    ratio = .5) + # use this to adjust x vs y axis
  theme_classic(
    
  ) +
  labs(
    title = "PC1 X PC3",
    subtitle = "Grouped by Site, With Ellipses")

ggsave("../output/pca_1-3_non_morphological.png")

ggbiplot(non_morphological_pca, 
         ellipse = TRUE,
         groups = data_opihi_microhabitat %>%
           dplyr::select(
             site,
             surf_angle:dist_to_underrock_ft,
             dist_to_littpint_ft:compass_ocean,
             -notes) %>%
           na.omit() %>%
           pull(
             site),
         choices = c(
           2,
           3)) +
  coord_fixed(
    ratio = .5) + # use this to adjust x vs y axis
  theme_classic(
    
  ) +
  labs(
    title = "PC2 X PC3",
    subtitle = "Grouped by Site, With Ellipses")

ggsave("../output/pca_2-3_non_morphological.png")

#### BOX AND WHISKER PLOT - DEVIATION FROM AVERAGE (move this later)

# Compute deviation from the mean **within each site**

data_opihi_deviation <- data_opihi_microhabitat %>%
  mutate(
    refuge_availability = case_when(
      site %in% c(
        "KahuluiBreakwaterBasaltInside",
        "KahuluiBreakwaterConcreteInside",
        "Honomanu",
        "HanaPalemoHanaBay", 
        "EastMaui1-RA"
        ) ~ "More refuge",
        TRUE ~ "Less refuge"
    ),
    
    site = factor(
      site,
      levels = c(
        "KahuluiBreakwaterBasaltInside",
        "KahuluiBreakwaterConcreteInside",
        "Honomanu",
        "HanaPalemoHanaBay",
        "EastMaui1-RA",
        "EastMaui2-RAB",
        "LaPerouseBayBench",
        "LaPerouseBayCliff",
        "MaaleaLighthouse",
        "HonoluaAdjacentInnerSide"
      ),
      labels = c(
        "M1", "M2", "M3", "M4", "M5",
        "L1", "L2", "L3", "L4", "L5"
      )
    )
  ) %>%
  group_by(site) %>%
  mutate(
    deviation =
      est_surface_area_cm2_normalized -
      mean(est_surface_area_cm2_normalized, na.rm = TRUE)
  ) %>%
  ungroup()
    
shapiro.test(data_opihi_deviation$deviation[data_opihi_deviation$refuge_availability == "More refuge"])
shapiro.test(data_opihi_deviation$deviation[data_opihi_deviation$refuge_availability == "Less refuge"])

leveneTest(deviation ~ site, data = data_opihi_deviation)
leveneTest(deviation ~ refuge_availability, data = data_opihi_deviation)

wilcox.test(deviation ~ refuge_availability, data = data_opihi_deviation)

# Create the boxplot with site-specific colors
ggplot(data_opihi_deviation, aes(x = site, y = deviation, fill = refuge_availability)) +
  geom_boxplot(outlier.shape = NA, color = "black") +  # Boxplot with black borders
  geom_jitter(width = 0.2, alpha = 0.5, color = "black") +  # Add jittered points for visibility
  theme_classic() +
  labs(
    #title = "Surface Area Differs by Refuge Availability",
    x = "Site",
    y = "Surface Area Index"
  ) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  coord_cartesian(ylim = c(-20, 20))

ggsave("../output/normalized_mean_surface_area_deviation-site.png"
       #width = 4,
       #height = 4
       )



ggplot(data = data_opihi_microhabitat) +
  aes(x = width_index_normalized, y = height_index_normalized) +
  geom_point(alpha = 1, color = "red") +  # Scatter points with transparency
  theme_classic() +
  labs(
    x = "Width Index",
    y = "Height Index"
  ) +
  theme(
    axis.title = element_text(size = 20),  # Change axis label size
    axis.text = element_text(size = 16)  # Change tick label size
  ) +
  coord_cartesian(xlim = c(0.5, 1), ylim = c(0.2, 0.7))

ggsave("../output/hindex_windex.png")
