######################################################
# Ce script corrige le format des valeurs de temps

# Créé par Jérémy Mainville-Gamache
# Date : Création en avril 2025
######################################################

#Librairies nécessaires
library(readr)
library(dplyr)

# Fonction qui corrige le format des valeurs de temps
uniformisation_time_obs <- function(folder_path) {
  message("\n Début de la correction des valeurs de temps...\n")
  
  # Lister les fichiers .csv sauf taxonomie.csv
  file_list <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  file_list <- file_list[!grepl("taxonomie", file_list)]
  
  for (file in file_list) {
    # Lire le fichier avec time_obs en tant que caractère
    df <- read_csv(file, show_col_types = FALSE, col_types = cols(time_obs = col_character()))
    
    # Appliquer la transformation
    df <- df %>%
      mutate(time_obs = if_else(
        !is.na(time_obs) & nchar(time_obs) == 6,
        paste0(substr(time_obs, 1, 2), ":", substr(time_obs, 3, 4), ":", substr(time_obs, 5, 6)),
        time_obs
      ))
    
    # Réécriture du fichier
    write_csv(df, file)
    message("Correction appliquée dans : ", basename(file))
  }
  
  message("\n Fin de la correction des valeurs de temps.\n")
}
