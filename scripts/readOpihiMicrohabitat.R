#### Setup stuff ####
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#### User Defined Variables ####
data_path_opihi = "../data/DataOpihiMorphologyMicrohabitat.csv"
data_path_decode = "../data/sample_name_decode.tsv"

#### PACKAGES ####
packages_used <- 
  c("tidyverse",
    "janitor",
    "cubature",
    "rlang",
    "readxl")

packages_to_install <- 
  packages_used[!packages_used %in% installed.packages()[,1]]

if (length(packages_to_install) > 0) {
  install.packages(packages_to_install, 
                   Ncpus = Sys.getenv("NUMBER_OF_PROCESSORS") - 1)
}

lapply(packages_used, 
       require, 
       character.only = TRUE)

#### Functions ####
SurfArea <- function(A,B,H) {
  #Function caluclates the Lateral est_surface area of an elliptical cone
  require(cubature)
  integrand<-function(t,a,b,h) {
    #https://rechneronline.de/pi/elliptic-cone.php
    sqrt(a^2*b^2 + h^2*(a^2*sin(t)^2 + b^2 * cos(t)^2))
  }
  
  pmap_dbl(.l=list(A,B,H),
           .f=function(x,y,z) adaptIntegrate(integrand, 
                                             lowerLimit=c(0),
                                             upperLimit=c(2*pi), 
                                             a=x,b=y,h=z)$integral/2)
}

normalizeCharacter <-
  function(data,
           character = "width_cm",
           normalize_by = "length_cm",
           # a_start = 0.5,
           # b_start = 1,
           new_col_name = str_c(character,
                                "_normalized")){
    
    # estimate a and b values
    # https://www.statology.org/power-regression-in-r/
    # nls was throwing errors and this uses lm + transforms to solve
    # answers are slightly diff between lm and nls, so lm produces starting vals for nls
    allometric_formula_lm <- 
      as.formula(str_c("log(",
                       character,
                       ") ~ log(",
                       normalize_by,
                       ")"))
    model_lm <-
      lm(allometric_formula_lm,
         data = data)
    
    a_start <- exp(model_lm$coefficients[1])
    b_start <- model_lm$coefficients[2]
    
    # need to use variables to dynamically set formula 
    # https://stackoverflow.com/questions/55877110/pass-dynamically-variable-names-in-lm-formula-inside-a-function
    allometric_formula_nls <-
      as.formula(str_c(character,
                       " ~ a * ",
                       normalize_by,
                       "^b"))
    
    
    # # use non linear model to estimate coefficient b
    model_nls <-
      nls(allometric_formula_nls,
          start = list(a = a_start,
                       b = b_start),
          data = data)
    
    b <- summary(model_nls)$parameters["b", "Estimate"]
    
    # add column with normalized measure
    # can set column name from variable as long as it's a quosure and we use :=   
    # https://stackoverflow.com/questions/26003574/use-dynamic-name-for-new-column-variable-in-dplyr
    # use sym() to coerce a character variable to a quosure 
    # https://github.com/r-lib/rlang/issues/116
    data %>%
      dplyr::mutate(
        !!sym(new_col_name) := 
          !!sym(character) * 
          (mean(!!sym(normalize_by),
                na.rm = TRUE) / 
             !!sym(normalize_by)) ^
          b,
        
      ) #%>%
    #for trouleshooting
    # pull(!!sym(new_col_name))
  }

#### Read Data ####
data_name_decode <-
  read_tsv(data_path_decode) %>%
  clean_names() %>%
  dplyr::rename(genetic_pop_sample_id = sample_id_detailed)

data_opihi_microhabitat <-
  read_csv(data_path_opihi) %>% #read_excel wouldn't work so I converted excel sheet to a csv and used the read_csv command instead
  clean_names() %>%
  rowwise() %>%
  dplyr::mutate(
    width_cm = width * 2.54,
    length_cm = length * 2.54,
    height_ww_cm = height_ww * 2.54,
    # dist_to_open_h2o = case_when(str_detect(notes,
    #                                         "all dist 0.15") &
    #                                dist_to_open_h2o < 0 ~ dist_to_open_h2o + 0.15,
    #                              str_detect(notes,
    #                                         "all dist 0.15") &
    #                                dist_to_open_h2o > 0 ~ dist_to_open_h2o - 0.15,
    #                              TRUE ~ dist_to_open_h2o)
  ) %>%
  mutate(dist_to_underrock = as.numeric(as.character(dist_to_underrock))) %>%
  mutate(across(starts_with("dist_to"),
                ~ case_when(str_detect(notes,
                                       "all dist 0\\.15") &
                              . < 0 ~ . + 0.15,
                            str_detect(notes,
                                       "all dist 0\\.15") &
                              . > 0 ~ . - 0.15,
                            TRUE ~ .))
         #height_lw_cm = height_lw / 100,
         #height_cm = mean(c(height_lw_cm,
         #                   height_ww_cm),
         #                na.rm=TRUE)
  ) %>%
  dplyr::mutate(
    dist_to_shelter = 
      case_when(
        !is.na(dist_to_shelter) ~ dist_to_shelter,
        # abs(dist_to_underrock) <= abs(dist_to_open_h2o) & abs(dist_to_crustose) ~ dist_to_underrock,
        # abs(dist_to_crustose) <= abs(dist_to_open_h2o) & abs(dist_to_underrock) ~ dist_to_crustose,
        # abs(dist_to_open_h2o) <= abs(dist_to_underrock) & abs(dist_to_crustose) ~ dist_to_open_h2o,
        !is.na(dist_to_underrock) & (is.na(dist_to_crustose) | abs(dist_to_underrock) <= abs(dist_to_crustose)) & (is.na(dist_to_open_h2o) | abs(dist_to_underrock) <= abs(dist_to_open_h2o)) ~ dist_to_underrock,
        !is.na(dist_to_crustose) & (is.na(dist_to_underrock) | abs(dist_to_crustose) <= abs(dist_to_underrock)) & (is.na(dist_to_open_h2o) | abs(dist_to_crustose) <= abs(dist_to_open_h2o)) ~ dist_to_crustose,
        !is.na(dist_to_open_h2o) & (is.na(dist_to_underrock) | abs(dist_to_open_h2o) <= abs(dist_to_underrock)) & (is.na(dist_to_crustose) | abs(dist_to_open_h2o) <= abs(dist_to_crustose)) ~ dist_to_open_h2o,
        TRUE ~ NA_real_
      )
  ) %>%
  dplyr::mutate(height_index = height_ww_cm / length_cm,
                width_index = width_cm / length_cm,
                est_surface_area_cm2 = SurfArea(length_cm,
                                                width_cm,
                                                height_ww_cm),
                #massiveness_index = shell_mass_g/est_surface_area_cm2,
                cross_sectional_area_cm2 = pi*(width_cm/2)*(length_cm/2),
                thermal_dissipation_index = est_surface_area_cm2/cross_sectional_area_cm2) %>%
  dplyr::ungroup() %>%
  normalizeCharacter("width_cm") %>% 
  normalizeCharacter("height_ww_cm") %>%
  #normalizeCharacter("shell_mass_g",
  # normalize_by = "est_surface_area_cm2"
  
  dplyr::mutate(est_surface_area_cm2_normalized = 
                  SurfArea(mean(length_cm,
                                na.rm=TRUE),
                           width_cm_normalized,
                           height_ww_cm_normalized),
                cross_sectional_area_cm2_normalized = pi*(width_cm_normalized/2)*mean(length_cm,
                                                                                      na.rm=TRUE),
                thermal_dissipation_index_normalized = est_surface_area_cm2_normalized / cross_sectional_area_cm2_normalized,
                height_index_normalized = height_ww_cm_normalized / mean(length_cm,
                                                                         na.rm=TRUE),
                width_index_normalized = width_cm_normalized / mean(length_cm,
                                                                    na.rm=TRUE),
                # massiveness_index_normalized = shell_mass_g_normalized/est_surface_area_cm2_normalized,
                # shore = case_when(str_detect(site,
                #                              "^EastMaui") ~ "South",
                #                   TRUE ~ "North")
  ) #%>%
# dplyr::mutate(shore_class = case_when(str_detect(shore_type,
#                                                  "bench") ~ "bench",
#                                       shore_type == "boulder" ~ "boulder",
#                                       TRUE ~ "mix"),
#               shore_class = factor(shore_class,
#                                    levels = c("bench",
#                                               "mix",
#                                               "boulder"))) %>%
# # dplyr::select(indiv_id:location,
#               # location_name,
#               life_stage,
#               substratum:shore_aspect,
#               shore_class,
#               #measurer,
#               length_cm,
#               everything(),
#               -length:-height_ww,
#               -sample_id_bscan:-site_id_optimal,
#               -genetic_pop_sample_id,
#               -starts_with("x")) 
