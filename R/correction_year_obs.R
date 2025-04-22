######################################################
# Ce script mets les valeurs de la colonne years_obs en caractère pour appliquer une correction pour uniformisé le format d'affichage 
# Attention, le script appelle une autre fonction : liste_correction_year_obs, présente dans liste_correction_year_obs.R. Cette fonction contient les corrections nécessaire selon le format d'affichage des années initiales

# Créé par Mélina Chicoine et Amélie Ironman-Rochon
# Date : Création en mars 2025
######################################################

#Librairies nécessaires
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
               year_obs = sapply(year_obs, liste_correction_year_obs))  # Appliquer la correction, pour les différentes correction aller voir le script : liste_correction_year_obs
      
      # Sauvegarder le fichier corrigé
      write_csv(df, file)
      message("Correction appliquée dans : ", basename(file))
    } else {
      message("️ Le fichier ", basename(file), " ne contient pas la colonne 'year_obs'.")
    }
  }
  
  # Message affiché quand tout est terminé 
  message("\n Correction des années terminée.")
}
