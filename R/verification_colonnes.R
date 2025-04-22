######################################################
# Ce script vérifie les colonnes présentes dans tous les fichiers .csv fournit. Cela est nécessaire pour avoir un assemblage fluide. 
# Attention, ce script de corrige pas les erreurs, il permet simplement de mentionner la détection de mauvaises colonnes. 
# Pour la correction des colonnes, il faut utiliser le script correction_des_noms.R et nom_colonne_correction.R

# Le script est roulé 2 fois, une fois avant et une fois après les corrections pour s'assurer que toutes les erreurs ont été corrigées

# Créé par Mélina Chicoine
# Date : Création en mars 2025
######################################################

# Librairie nécessaire
library(readr)

# Liste des colonnes attendues pour que la base de donnée soit uniforme
colonnes_attendues <- c(
  "observed_scientific_name", "year_obs", "day_obs", "time_obs",
  "dwc_event_date", "obs_variable", "obs_unit", "obs_value",
  "lat", "lon", "original_source", "creator", "title",
  "publisher", "intellectual_rights", "license", "owner"
)

# Fonction pour vérifier la structure des fichiers CSV, va indiquer les colonnes qui manquent et ou les colonnes en trop
verification_colonnes <- function(folder_path) {
  file_list <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  file_list <- file_list[!grepl("taxonomie\\.csv$", file_list)]
  
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
