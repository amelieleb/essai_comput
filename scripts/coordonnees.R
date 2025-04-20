#Version 2 ----
library(dplyr)
library(readr)

# Fonction pour vérifier si les coordonnées sont valide
verification_coordonnees <- function(folder_path) {
  file_list <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  
  for(file in file_list){
    
    #Chargement des fichiers
    df <- read_csv(file, show_col_types=FALSE)
    
    #Ajout d'une colonne valid_coords: TRUE si les coordonnées sont valides
    df <-  df %>%
      mutate(valid_coords = lat>= 0 & lat <= 90 & lon <= 0 & lon >= -180)

    #Sauvegarde le fichier modifié par dessus l'ancien
    write.csv(df, file)
    
    message("Vérification des coordonnées terminées")
  }
}
   