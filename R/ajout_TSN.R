######################################################
# Ce script permet d'obtenir les TSN des noms scientifiques 
# et de les ajouter dans une nouvelle colonne du fichier taxonomie.csv, colonne = TSN
# il crée également un nouveau fichier avec les TSN : "taxonomie_TSN.csv"

# Créé par Amélie LeBlanc
# Date : Création en avril 2025
######################################################


# Chargement des packages nécessaires
library(ritis)
library(readr)

# Boucle pour récupérer le TSN pour chaque nom scientifique
ajout_TSN <- function(folder = "lepidopteres") {
  
  # Lire le fichier
  taxonomie <- read_csv(file.path(folder, "taxonomie.csv"), show_col_types = FALSE)
  
  # Ajouter une colonne TSN vide
  taxonomie$TSN <- NA
  
  for(i in 1:nrow(taxonomie)) {
    
    # Aller chercher le nom scientifique
    nom_scientifique <- gsub(" ", "\\\\ ", taxonomie$valid_scientific_name[i])
    
    # Recherche du TSN
    result <- itis_search(q = paste0("nameWOInd:", nom_scientifique))
    
    # Ajouter le TSN s'il y a un résultat
    if(length(result) > 0) {
      taxonomie$TSN[i] <- result$tsn[1]
    }
  }
  
  # Sauvegarder dans le bon dossier
  write_csv(taxonomie, file.path(folder, "taxonomie_TSN.csv"))
  
  message("Ajout des TSN trouvés. Fichier sauvegardé dans : ", file.path(folder, "taxonomie_TSN.csv"))
}
