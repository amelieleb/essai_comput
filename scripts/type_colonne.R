library(readr)
library(dplyr)

# Définition des types de colonnes
col_types <- cols(
  observed_scientific_name = col_character(),
  year_obs = col_integer(),
  day_obs = col_integer(),
  time_obs = col_character(),      # On laisse en character (pour le moment)
  dwc_event_date = col_character(),  # On laisse en character (pour le moment)
  obs_variable = col_character(),
  obs_unit = col_character(),
  obs_value = col_double(),
  lat = col_double(),
  lon = col_double(),
  original_source = col_character(),
  creator = col_character(),
  title = col_character(),
  publisher = col_character(),
  intellectual_rights = col_character(),
  license = col_character(),
  owner = col_character()
)

# Fonction pour charger un fichier et appliquer les corrections
type_colonne_csv <- function(file_path) {
  df <- read_csv(file_path, col_types = col_types, col_names = TRUE, na = c("", "NA"))
  return(df)  # Pas de conversion des dates ici
}

