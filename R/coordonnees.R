library(dplyr)
library(readr)

# Fonction pour vérifier si les coordonnées sont valides
verification_coordonnees <- function(folder_path) {
  file_list <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  file_list <- file_list[!grepl("taxonomie\\.csv$", file_list)]
  
  for (file in file_list) {
    df <- read_csv(file, show_col_types = FALSE)
    
    # Vérifie que les colonnes lat et lon existent
    if (!("lat" %in% names(df) && "lon" %in% names(df))) {
      message("Le fichier ", basename(file), " ne contient pas les colonnes 'lat' et 'lon'. Ignoré.")
      next
    }
    
    # Ajout de la colonne valid_coords
    df <- df %>%
      mutate(valid_coords = lat >= 0 & lat <= 90 & lon <= 0 & lon >= -180)
    
    # Sauvegarde du fichier modifié
    write_csv(df, file)
    message("Coordonnées vérifiées pour : ", basename(file))
  }
}
