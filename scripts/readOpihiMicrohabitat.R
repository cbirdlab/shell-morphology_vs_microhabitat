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
  
  #omitting these until i can impute them properly, they're fixed now
  #filter(!individual_id %in% c(54, 108)) %>%
  
  dplyr::mutate(
    width_cm = if_else(
      dplyr::between(individual_id, 1, 50),
      width_in * 2.54,
      width_tenth_mm / 100),
    
    length_cm = if_else(
      dplyr::between(individual_id, 1, 50),
      length_in * 2.54,
      length_tenth_mm / 100),
    
    height_ww_cm = if_else(
      dplyr::between(individual_id, 1, 50),
      height_ww_in * 2.54,
      height_ww_tenth_mm / 100),
    
  #record which values are imputed
    length_imputed = is.na(length_cm),
    width_imputed = is.na(width_cm),
    height_imputed = is.na(height_ww_cm)
  )

data_opihi_microhabitat <- data_opihi_microhabitat %>%
  mutate(
    length_invalid = !is.na(length_cm) &
      !is.na(width_cm) &
      length_cm < width_cm
  )

#imputation models, log-log used due to allometry
length_model <- lm(
  log(length_cm) ~ log(width_cm) + log(height_ww_cm),
  data = data_opihi_microhabitat %>%
    filter(
      !length_invalid,
      !is.na(length_cm),
      !is.na(width_cm),
      !is.na(height_ww_cm)
    )
)

width_model <- lm(
  log(width_cm) ~ log(length_cm) + log(height_ww_cm),
  data = data_opihi_microhabitat %>%
    filter(
      !length_invalid,
      !is.na(length_cm),
      !is.na(width_cm),
      !is.na(height_ww_cm)
    )
)

height_model <- lm(
  log(height_ww_cm) ~ log(length_cm) + log(width_cm),
  data = data_opihi_microhabitat %>%
    filter(
      !length_invalid,
      !is.na(length_cm),
      !is.na(width_cm),
      !is.na(height_ww_cm)
    )
)

#check imputation models
summary(length_model)
summary(width_model)
summary(height_model)

#make imputations without overwriting
data_opihi_microhabitat <- data_opihi_microhabitat %>%
  ungroup() %>%
  mutate(
    # Flag measurements that need imputation
    length_imputed = is.na(length_cm) | length_invalid,
    width_imputed  = is.na(width_cm),
    height_imputed = is.na(height_ww_cm),
    
    # Predict length only when length is bad/missing
    # and width + height are measured
    length_predicted_cm = if_else(
      length_imputed &
        !width_imputed &
        !height_imputed,
      
      exp(
        predict(
          length_model,
          newdata = data_opihi_microhabitat
        )
      ),
      
      NA_real_
    ),
    
    # Predict width only when width is missing
    # and valid length + height are measured
    width_predicted_cm = if_else(
      width_imputed &
        !length_imputed &
        !height_imputed,
      
      exp(
        predict(
          width_model,
          newdata = data_opihi_microhabitat
        )
      ),
      
      NA_real_
    ),
    
    # Predict height only when height is missing
    # and valid length + width are measured
    height_predicted_cm = if_else(
      height_imputed &
        !length_imputed &
        !width_imputed,
      
      exp(
        predict(
          height_model,
          newdata = data_opihi_microhabitat
        )
      ),
      
      NA_real_
    )
  )

#show only the shells needing imputation
data_opihi_microhabitat %>%
  filter(
    length_imputed |
      width_imputed |
      height_imputed
  ) %>%
  select(
    individual_id,
    length_cm,
    width_cm,
    height_ww_cm,
    length_invalid,
    length_imputed,
    width_imputed,
    height_imputed,
    length_predicted_cm,
    width_predicted_cm,
    height_predicted_cm
  )

#overwrite missing values with imputed ones
data_opihi_microhabitat <- data_opihi_microhabitat %>%
  mutate(
    length_cm = if_else(
      length_imputed & !is.na(length_predicted_cm),
      length_predicted_cm,
      length_cm
    ),
    
    width_cm = if_else(
      width_imputed & !is.na(width_predicted_cm),
      width_predicted_cm,
      width_cm
    ),
    
    height_ww_cm = if_else(
      height_imputed & !is.na(height_predicted_cm),
      height_predicted_cm,
      height_ww_cm
    )
  )

#### clean up limu and erosion ####

data_opihi_microhabitat <- data_opihi_microhabitat %>%
  ungroup() %>%
  mutate(
    limu_on_shell = case_when(
      limu_on_shell == "some crustose" ~ 2.5,
      limu_on_shell == "<5" ~ 2.5,
      TRUE ~ as.numeric(limu_on_shell)
    ),
    
    erosion = case_when(
      erosion == "<5" ~ 2.5,
      erosion == "<1" ~ 0.5,
      TRUE ~ as.numeric(erosion)
    ),
    
    dist_to_underrock_ft = as.numeric(
      as.character(dist_to_underrock_ft)
    )
  )

#### correct dist to measures ####

data_opihi_microhabitat <- data_opihi_microhabitat %>%
  mutate(
    across(
      starts_with("dist_to") & ends_with("_ft"),
      ~ case_when(
        str_detect(notes, "all dist 0\\.15") &
          .x < 0 ~ .x + 0.15,
        
        str_detect(notes, "all dist 0\\.15") &
          .x > 0 ~ .x - 0.15,
        
        TRUE ~ .x
      )
    )
  )

#### calculate dist to shelter ####

data_opihi_microhabitat <- data_opihi_microhabitat %>%
  mutate(
    dist_to_shelter_ft = case_when(
      
      # Keep existing shelter distances.
      !is.na(dist_to_shelter_ft) ~
        dist_to_shelter_ft,
      
      # Use underrock if it is the closest available shelter.
      !is.na(dist_to_underrock_ft) &
        (is.na(dist_to_crustose_ft) |
           abs(dist_to_underrock_ft) <= abs(dist_to_crustose_ft)) &
        (is.na(dist_to_open_h2o_ft) |
           abs(dist_to_underrock_ft) <= abs(dist_to_open_h2o_ft)) ~
        dist_to_underrock_ft,
      
      # Otherwise, use crustose if it is closest.
      !is.na(dist_to_crustose_ft) &
        (is.na(dist_to_underrock_ft) |
           abs(dist_to_crustose_ft) <= abs(dist_to_underrock_ft)) &
        (is.na(dist_to_open_h2o_ft) |
           abs(dist_to_crustose_ft) <= abs(dist_to_open_h2o_ft)) ~
        dist_to_crustose_ft,
      
      # Otherwise, use open water if it is closest.
      !is.na(dist_to_open_h2o_ft) &
        (is.na(dist_to_underrock_ft) |
           abs(dist_to_open_h2o_ft) <= abs(dist_to_underrock_ft)) &
        (is.na(dist_to_crustose_ft) |
           abs(dist_to_open_h2o_ft) <= abs(dist_to_crustose_ft)) ~
        dist_to_open_h2o_ft,
      
      TRUE ~ NA_real_
    )
  )

#### calc shell morphology variables ####

data_opihi_microhabitat <- data_opihi_microhabitat %>%
  rowwise() %>%
  mutate(
    height_index = height_ww_cm / length_cm,
    
    width_index = width_cm / length_cm,
    
    est_surface_area_cm2 = SurfArea(
      length_cm / 2,
      width_cm / 2,
      height_ww_cm
    ),
    
    cross_sectional_area_cm2 =
      pi * (width_cm / 2) * (length_cm / 2),
    
    thermal_dissipation_index =
      est_surface_area_cm2 / cross_sectional_area_cm2
    
    # massiveness_index =
    #   shell_mass_g / est_surface_area_cm2
  ) %>%
  ungroup()

#### normalize morphology ####

data_opihi_microhabitat <- data_opihi_microhabitat %>%
  normalizeCharacter("width_cm") %>%
  normalizeCharacter("height_ww_cm")

#### compass and trig stuff ####

data_opihi_microhabitat <- data_opihi_microhabitat %>%
  mutate(
    compass_surface_relative_ocean =
      abs((compass_surface - compass_ocean + 180) %% 360 - 180),
    
    altitude_est_opposite_ft =
      altitude_est_hypotenuse_ft *
      sin(altitude_est_angle_deg * pi / 180)
  )

#### assigns north and south shore ####

data_opihi_microhabitat <- data_opihi_microhabitat %>%
  mutate(
    shore = case_when(
      
      site %in% c(
        "KahuluiBreakwaterBasaltInside",
        "KahuluiBreakwaterConcreteInside",
        "HonoluaAdjacentInnerSide",
        "HanaPalemoHanaBay",
        "Honomanu",
        "KahuluiBreakwaterBasaltOutside"
      ) ~ "north",
      
      site %in% c(
        "EastMaui1-RA",
        "EastMaui2-RAB",
        "MaaleaLighthouse",
        "LaPerouseBayBench",
        "LaPerouseBayCliff"
      ) ~ "south",
      
      TRUE ~ NA_character_
    )
  )

#### makes substrate and substrate subtype ####

data_opihi_microhabitat <- data_opihi_microhabitat %>%
  mutate(
    substrate_subtype = stringr::word(substrate, 2),
    substrate = stringr::word(substrate, 1),
    .after = substrate
  )

#### normalized morphology indecies ####

#calculate mean shell length across all individuals.
mean_length_cm <- mean(
  data_opihi_microhabitat$length_cm,
  na.rm = TRUE
)

data_opihi_microhabitat <- data_opihi_microhabitat %>%
  rowwise() %>%
  mutate(
    est_surface_area_cm2_normalized = SurfArea(
      mean_length_cm / 2,
      width_cm_normalized / 2,
      height_ww_cm_normalized
    ),
    
    cross_sectional_area_cm2_normalized =
      pi * (width_cm_normalized / 2) * (mean_length_cm / 2),
    
    thermal_dissipation_index_normalized =
      est_surface_area_cm2_normalized /
      cross_sectional_area_cm2_normalized,
    
    height_index_normalized =
      height_ww_cm_normalized / mean_length_cm,
    
    width_index_normalized =
      width_cm_normalized / mean_length_cm
    
    # massiveness_index_normalized =
    #   shell_mass_g_normalized /
    #   est_surface_area_cm2_normalized
  ) %>%
  ungroup()

#### convert ft to cm ####

# Find all columns ending in _ft
ft_cols <- grep(
  "_ft$",
  names(data_opihi_microhabitat),
  value = TRUE
)

# Convert each column to centimeters
for (ft_col in ft_cols) {
  
  # Create the corresponding centimeter column name
  cm_col <- sub("_ft$", "_cm", ft_col)
  
  # Convert feet to centimeters
  data_opihi_microhabitat[[cm_col]] <-
    data_opihi_microhabitat[[ft_col]] * 30.48
  
}

#### output modified data ####

write_csv(
  data_opihi_microhabitat,
  "../data/data_opihi_microhabitat.csv"
)
