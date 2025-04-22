######################################################
# Ce script vérifie que `year_obs` est au format YYYY et entre 1800 et 2050
# Attention, une fois les annéee 2050 dépassées il faudra changer la limite

# Créé par Mélina Chicoine
# Date : Création en mars 2025
######################################################


# Librairies nécessaires
library(readr)
library(dplyr)

# Fonction pour vérifier que `year_obs` est au format YYYY et entre 1800 et 2050
verification_year_obs <- function(folder_path) {
  message("\n Vérification des valeurs dans 'year_obs' avant l'assemblage...\n")
  
  # Lister tous les fichiers CSV sauf taxonomie.csv
  file_list <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  file_list <- file_list[!grepl("taxonomie\\.csv$", file_list)]  # Exclure taxonomie.csv
  
  # Vérifier si `year_obs` contient uniquement des années valides (YYYY et 1800-2050)
  for (file in file_list) {
    df <- read_csv(file, show_col_types = FALSE)
    
    if ("year_obs" %in% names(df)) {
      erreurs_year <- df %>%
        filter(!grepl("^\\d{4}$", as.character(year_obs)) | as.numeric(year_obs) < 1800 | as.numeric(year_obs) > 2050, 
               !is.na(year_obs))  # Vérifie format YYYY et limite 1800-2050
      
      if (nrow(erreurs_year) > 0) {
        message("Erreur dans 'year_obs' du fichier ", basename(file), " : certaines valeurs ne respectent pas le format YYYY ou sont hors de la plage 1800-2050.")
        print(erreurs_year %>% select(year_obs) %>% head(10))  # Affiche les 10 premières lignes si erreurs présentes
      }
    } else {
      message("Le fichier ", basename(file), " ne contient pas la colonne 'year_obs'.")
    }
  }
  
  message("\n Vérification des années terminée.")
}
