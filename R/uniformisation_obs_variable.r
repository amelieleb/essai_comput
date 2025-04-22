##########################################################
# Ce script permet de détecter et de changer les "presence"
# en "occurrence" et de tester pour des erreurs possible d'ortographes dans l'écriture des mots occurence, abundance et presence

# Créé par Jérémy Mainville-Gamache et Mélina Chicoine
# Date: 2025-04-21
##########################################################


# Librairies nécessaire
library(readr)
library(dplyr)
library(stringr)

uniformisation_obs_variable <- function(folder_path){
  message("Début de l'uniformisation des termes de obs_variable")
  
  # Lister tous les fichiers CSV sauf taxonomie
  file_list <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  file_list <- file_list[!grepl("taxonomie", file_list)]
  
  # Valeurs acceptées
  valeurs_valides <- c("presence", "abondance", "occurrence")
  
  for (file in file_list) {
    df <- read_csv(file, show_col_types = FALSE)
    
    if ("obs_variable" %in% names(df)) {
      # Nettoyer les valeurs
      df$obs_variable <- tolower(df$obs_variable)
      df$obs_variable <- str_trim(df$obs_variable)
      
      # Remplacement automatique de variantes fautives
      df$obs_variable <- case_when(
        str_detect(df$obs_variable, "présence|presence|présences|presences") ~ "presence",
        str_detect(df$obs_variable, "abondance|abundance|abundances|abondances") ~ "abundance",
        str_detect(df$obs_variable, "occurrence|occurence|occurences") ~ "occurrence",
        TRUE ~ df$obs_variable
      )
      
      # Détection des valeurs inattendues
      valeurs_inconnues <- setdiff(unique(df$obs_variable), valeurs_valides)
      if (length(valeurs_inconnues) > 0) {
        warning("Valeurs inattendues dans obs_variable dans ", basename(file), " : ", paste(valeurs_inconnues, collapse = ", "))
      }
      
      # Standardisation finale : on choisit ici de tout convertir en "occurrence"
      df$obs_variable[df$obs_variable == "presence"] <- "occurrence"
      
      # Écriture du fichier modifié
      write_csv(df, file)
      message("Correction appliquée dans : ", basename(file))
    }
  }
  
  message("Fin de l'uniformisation des termes de obs_variable")
}
