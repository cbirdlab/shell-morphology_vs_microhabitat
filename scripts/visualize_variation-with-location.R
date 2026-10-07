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
           smooth = TRUE,
           panel = FALSE,
           overall_line = FALSE){
    
    x_var = enquo(x_var)
    y_var = enquo(y_var)
    color_var = enquo(color_var)
    
    if(panel == TRUE){
      data <- data %>%
        left_join(site_panels, by = "site")
    }
    
    # Create a separate dataset for the overall regression line
    # Removing the panel column allows ggplot to fit one
    # regression using ALL sites and display it in every panel
    
    if(panel == TRUE){
      overall_data <- data %>%
        dplyr::select(-panel)
    } else {
      overall_data <- data
    }
    
    p <- data %>%
      ggplot() +
      aes(x = !!x_var,
          y = !!y_var,
          color = !!color_var) +
      geom_point() +
      theme_classic()
    
    # Individual regression lines for each site
    if(smooth == TRUE){
      p <- p +
        geom_smooth(method = lm, se = FALSE)
    }
    
    # One overall regression line calculated across ALL sites
    if(overall_line == TRUE){
      p <- p +
        geom_smooth(
          aes(x = !!x_var,
              y = !!y_var,
              group = 1),
          inherit.aes = FALSE,
          data = overall_data,
          method = lm,
          se = FALSE,
          color = "black",
          linewidth = 1
        )
    }
    
    if(panel == TRUE){
      p <- p +
        facet_wrap(~panel)
    }
    
    return(p)
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

#### Normalized Character Box Plots N/S Shore ####

##height vs north/south shore
BoxPlot(y_var = height_ww_cm_normalized,
        fill_var = shore)
ggsave("../output/height_ww_cm_normalized-vs-north_south-boxplot.png",
       width = 4,
       height = 4)

#testing significance
wilcox.test(
  height_ww_cm_normalized ~ shore,
  data = data_opihi_microhabitat
) #p = 0.06363

#mixed effect model
#prep data for all 3 plots
shore_data <- data_opihi_microhabitat %>%
  dplyr::select(
    site,
    shore,
    height_ww_cm_normalized,
    est_surface_area_cm2_normalized,
    thermal_dissipation_index_normalized
  ) %>%
  filter(
    !is.na(site),
    !is.na(shore),
    !is.na(height_ww_cm_normalized),
    !is.na(est_surface_area_cm2_normalized),
    !is.na(thermal_dissipation_index_normalized)
  ) %>%
  mutate(
    site = factor(site),
    shore = factor(shore, levels = c("north", "south"))
  )

#check sample sizes and site distribution
shore_data %>%
  dplyr::count(shore, site)

#fit mixed-effects model
model_shore <- nlme::lme(
  height_ww_cm_normalized ~ shore,
  random = ~ 1 | site,
  data = shore_data,
  method = "REML"
)

summary(model_shore)

#test shore effect
anova(model_shore)

#estimated means and pairwise comparison
shore_means <- emmeans(model_shore, ~ shore)

summary(shore_means)
pairs(shore_means)
confint(pairs(shore_means))

#model diagnostics
plot(model_shore)

qqnorm(resid(model_shore, type = "normalized"))
qqline(resid(model_shore, type = "normalized"))

#site level random effects
site_effects <- nlme::ranef(model_shore)[, 1]
site_effects
qqnorm(site_effects)
qqline(site_effects)

##surface area vs north/south shore
BoxPlot(y_var = est_surface_area_cm2_normalized,
        fill_var = shore)
ggsave("../output/est_surface_area_cm2_normalized-vs-north_south-boxplot.png",
       width = 4,
       height = 4)

#testing significance
wilcox.test(
  est_surface_area_cm2_normalized ~ shore,
  data = data_opihi_microhabitat
) #p = 0.02876

#fit mixed-effects model
model_shore <- nlme::lme(
  est_surface_area_cm2_normalized ~ shore,
  random = ~ 1 | site,
  data = shore_data,
  method = "REML"
)

summary(model_shore)

#test shore effect
anova(model_shore)

#estimated means and pairwise comparison
shore_means <- emmeans(model_shore, ~ shore)

summary(shore_means)
pairs(shore_means)
confint(pairs(shore_means))

#model diagnostics
plot(model_shore)

qqnorm(resid(model_shore, type = "normalized"))
qqline(resid(model_shore, type = "normalized"))

#site level random effects
site_effects <- nlme::ranef(model_shore)[, 1]
site_effects
qqnorm(site_effects)
qqline(site_effects)

##thermal dissipation index vs n/s shore
BoxPlot(y_var = thermal_dissipation_index_normalized,
        fill_var = shore)
ggsave("../output/thermal_dissipation_index_normalized-vs-north_south-boxplot.png",
       width = 4,
       height = 4)

#testing significance
wilcox.test(
  thermal_dissipation_index_normalized ~ shore,
  data = data_opihi_microhabitat
) #p = 0.05258

#fit mixed-effects model
model_shore <- nlme::lme(
  thermal_dissipation_index_normalized ~ shore,
  random = ~ 1 | site,
  data = shore_data,
  method = "REML"
)

summary(model_shore)

#test shore effect
anova(model_shore)

#estimated means and pairwise comparison
shore_means <- emmeans(model_shore, ~ shore)

summary(shore_means)
pairs(shore_means)
confint(pairs(shore_means))

#model diagnostics
plot(model_shore)

qqnorm(resid(model_shore, type = "normalized"))
qqline(resid(model_shore, type = "normalized"))

#site level random effects
site_effects <- nlme::ranef(model_shore)[, 1]
site_effects
qqnorm(site_effects)
qqline(site_effects)

##cross sectional area vs n/s
BoxPlot(y_var = cross_sectional_area_cm2_normalized,
        fill_var = shore)
ggsave("../output/cross_sectional_area_normalized-vs-north_south-boxplot.png",
       width = 4,
       height = 4)

#testing significance
wilcox.test(
  cross_sectional_area_cm2_normalized ~ shore,
  data = data_opihi_microhabitat
) #p = 0.1685

#### Box Plot vs Transect Spot ####

##height vs transect spot
BoxPlot(y_var = height_ww_cm_normalized,
        fill_var = spot_on_transect)
ggsave("../output/height_ww_cm_normalized-vs-spot_on_transect-boxplot.png",
       width = 4,
       height = 4)

##surface area vs transect spot
BoxPlot(y_var = est_surface_area_cm2_normalized,
        fill_var = spot_on_transect)
ggsave("../output/est_surface_area_cm2_normalized-vs-spot_on_transect-boxplot.png",
       width = 4,
       height = 4)

##thermal dissipation index vs transect spot
BoxPlot(y_var = thermal_dissipation_index_normalized,
        fill_var = spot_on_transect)
ggsave("../output/thermal_dissipation_index_normalized-vs-spot_on_transect-boxplot.png",
       width = 4,
       height = 4)

#### Box Plot vs Site ####

#height vs site
BoxPlot(y_var = height_ww_cm_normalized,
        fill_var = site) 
ggsave("../output/height_ww_cm_normalized-vs-site-boxplot.png",
       width = 4,
       height = 4)

#height index vs site
BoxPlot(y_var = height_index_normalized,
        fill_var = site) 
ggsave("../output/height_index_normalized-vs-site-boxplot.png",
       width = 4,
       height = 4)

#surface area vs site
BoxPlot(y_var = est_surface_area_cm2_normalized,
        fill_var = site)
ggsave("../output/est_surface_area_cm2_normalized-vs-site-boxplots.png",
       width = 4,
       height = 4)

#thermal dissipation vs site
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
