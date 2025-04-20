library(dplyr)
library(readr)

# Fonction pour vérifier si les coordonnées sont valides
verification_coordonnees <- function(folder_path) {
  file_list <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  
  for (file in file_list) {
    df <- read_csv(file, show_col_types = FALSE)
    
    # Ajout de la colonne valid_coords
    df <- df %>%
      mutate(valid_coords = lat >= 0 & lat <= 90 & lon <= 0 & lon >= -180)
    
    # Sauvegarde sans ligne de noms
    write_csv(df, file)
    
    message("Vérification des coordonnées terminée dans ", basename(file))
  }
}
