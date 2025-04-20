# Script qui permet d'obtenir les TSN des noms scientifiques 
# et de les ajouter dans une nouvelle colonne du fichier taxonomie.csv

# Chargement des packages nécessaires
library(ritis)
library(readr)

# Boucle pour récupérer le TSN pour chaque nom scientifique
TSN_ajout <- function(folder = "lepidopteres") {
  
  # Chemin d'entrée
  input_file <- file.path(folder, "taxonomie.csv")
  
  # Lire le fichier
  taxonomie <- read_csv(input_file, show_col_types = FALSE)
  
  # Ajouter une colonne TSN vide
  taxonomie$TSN <- NA
  
  for(i in 1:nrow(taxonomie)) {
    
    # Préparer le nom scientifique
    nom_scientifique <- gsub(" ", "\\\\ ", taxonomie$valid_scientific_name[i])
    
    # Recherche du TSN
    result <- itis_search(q = paste0("nameWOInd:", nom_scientifique))
    
    # Ajouter le TSN s'il y a un résultat
    if(length(result) > 0) {
      taxonomie$TSN[i] <- result$tsn[1]
    }
  }
  
  # Chemin de sortie
  output_file <- file.path(folder, "taxonomie_TSN.csv")
  
  # Sauvegarder le fichier avec les TSN
  write_csv(taxonomie, output_file)
  
  message("Ajout des TSN trouvés. Fichier sauvegardé dans : ", output_file)
}
