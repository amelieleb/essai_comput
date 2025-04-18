library(readr)

# Liste des colonnes attendues
colonnes_attendues <- c(
  "observed_scientific_name", "year_obs", "day_obs", "time_obs",
  "dwc_event_date", "obs_variable", "obs_unit", "obs_value",
  "lat", "lon", "original_source", "creator", "title",
  "publisher", "intellectual_rights", "license", "owner"
)

# Fonction pour vérifier la structure des fichiers CSV
verification_colonnes <- function(folder_path) {
  file_list <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  
  for (file in file_list) {
    df <- read_csv(file, show_col_types = FALSE)
    
    # Vérifier les colonnes manquantes
    colonnes_manquantes <- setdiff(colonnes_attendues, colnames(df))
    if (length(colonnes_manquantes) > 0) {
      print(paste("Attention! Le fichier", file, "ne contient pas les colonnes :", paste(colonnes_manquantes, collapse = ", ")))
    }
    
    # Vérifier les colonnes en trop
    colonnes_inconnues <- setdiff(colnames(df), colonnes_attendues)
    if (length(colonnes_inconnues) > 0) {
      print(paste("Attention! Le fichier", file, "contient des colonnes inconnues :", paste(colonnes_inconnues, collapse = ", ")))
    }
  }
}
