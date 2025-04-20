#Script qui permet d'obtenir les TSN des noms scientifiques et de les ajouter
#dans une nouvelle colonne du fichier excel taxonomie.csv

#Chargement des packages nécessaire
library(ritis)
library(readr)

# Fonction pour récupérer les TSN depuis taxonomie.csv dans un dossier donné
TSN_ajout <- function(folder_path = "lepidopteres") {
  file_path <- file.path(folder_path, "taxonomie.csv")
  
  if (!file.exists(file_path)) {
    stop("Le fichier taxonomie.csv n'existe pas dans le dossier ", folder_path)
  }
  
  taxonomie <- read_csv(file_path, show_col_types = FALSE)
  taxonomie$TSN <- NA
  
  for (i in seq_len(nrow(taxonomie))) {
    nom_scientifique <- taxonomie$valid_scientific_name[i]
    
    # Recherche sur ITIS
    result <- tryCatch({
      itis_search(nom_scientifique)
    }, error = function(e) return(NULL))
    
    # Ajout du TSN si résultat disponible
    if (!is.null(result) && "tsn" %in% names(result) && nrow(result) > 0) {
      taxonomie$TSN[i] <- result$tsn[1]
    }
  }
  
  output_path <- file.path(folder_path, "taxonomie_TSN.csv")
  write_csv(taxonomie, output_path)
  message(" Ajout des TSN terminé. Fichier sauvegardé : ", output_path)
}
