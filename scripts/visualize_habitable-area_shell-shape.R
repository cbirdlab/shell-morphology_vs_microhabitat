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

#### Normalized vs Refuge Category Plots ####

##vs thermal_dissipation
data_opihi_microhabitat %>%
  dplyr::filter(!is.na(limpet_location_solar_refuge_category)) %>%
  BoxPlot(
    y_var = thermal_dissipation_index_normalized,
    fill_var = limpet_location_solar_refuge_category
  )
ggsave("../output/solar_refuge_category-vs-thermal_dissipation_index_normalized-box.png")

#testing significance
solar_refuge_data <- data_opihi_microhabitat %>%
  dplyr::filter(
    !is.na(limpet_location_solar_refuge_category),
    !is.na(thermal_dissipation_index_normalized)
  )

kruskal.test(
  thermal_dissipation_index_normalized ~ limpet_location_solar_refuge_category,
  data = solar_refuge_data
)

pairwise.wilcox.test(
  x = solar_refuge_data$thermal_dissipation_index_normalized,
  g = solar_refuge_data$limpet_location_solar_refuge_category,
  p.adjust.method = "holm"
)

#stuff is coming out just BARELY non-significant
solar_refuge_data %>%
  dplyr::group_by(limpet_location_solar_refuge_category) %>%
  dplyr::summarise(
    n = dplyr::n(),
    median = median(thermal_dissipation_index_normalized),
    Q1 = quantile(thermal_dissipation_index_normalized, 0.25),
    Q3 = quantile(thermal_dissipation_index_normalized, 0.75),
    IQR = IQR(thermal_dissipation_index_normalized)
  )

##vs height_index
data_opihi_microhabitat %>%
  dplyr::filter(!is.na(limpet_location_solar_refuge_category)) %>%
  BoxPlot(
    y_var = height_index_normalized,
    fill_var = limpet_location_solar_refuge_category
  )
ggsave("../output/solar_refuge_category-vs-height_index_normalized-box.png")

#testing significance
solar_refuge_data <- data_opihi_microhabitat %>%
  dplyr::filter(
    !is.na(limpet_location_solar_refuge_category),
    !is.na(height_index_normalized)
  )

kruskal.test(
  height_index_normalized ~ limpet_location_solar_refuge_category,
  data = solar_refuge_data
)

pairwise.wilcox.test(
  x = solar_refuge_data$height_index_normalized,
  g = solar_refuge_data$limpet_location_solar_refuge_category,
  p.adjust.method = "holm"
)

solar_refuge_data %>%
  dplyr::group_by(limpet_location_solar_refuge_category) %>%
  dplyr::summarise(
    n = dplyr::n(),
    median = median(height_index_normalized),
    Q1 = quantile(height_index_normalized, 0.25),
    Q3 = quantile(height_index_normalized, 0.75),
    IQR = IQR(height_index_normalized)
  )
