library(readr)
library(dplyr)
library(lubridate)

# Fonction pour appliquer la correction à tous les fichiers
correction_year_obs <- function(folder_path) {
  message("\n Correction des valeurs dans 'year_obs' avant l'assemblage...\n")
  
  # Lister tous les fichiers CSV sauf taxonomie.csv
  file_list <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  file_list <- file_list[!grepl("taxonomie\\.csv$", file_list)]  # Exclure taxonomie.csv
  
  # Appliquer la correction à chaque fichier
  for (file in file_list) {
    df <- read_csv(file, show_col_types = FALSE)
    
    if ("year_obs" %in% names(df)) {
      df <- df %>%
        mutate(year_obs = as.character(year_obs),  # S'assurer que c'est du texte
               year_obs = sapply(year_obs, corriger_annee))  # Appliquer la correction, pour les différentes correction aller voir le script : corriger_annee
      
      # Sauvegarder le fichier corrigé
      write_csv(df, file)
      message("Correction appliquée dans : ", basename(file))
    } else {
      message("️ Le fichier ", basename(file), " ne contient pas la colonne 'year_obs'.")
    }
  }
  
  message("\n Correction des années terminée.")
}
