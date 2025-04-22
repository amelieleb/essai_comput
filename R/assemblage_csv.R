######################################################
# Ce script assemble toutes les données donc ex: chaque fichier .csv dans lepidoptere dans un object 
# Il ajoute également la colonne source_file pour savoir d'où proviennent les fichiers une fois qu'ils sont combinés ensemble

# Créé par Mélina Chicoine
# Date : Création en mars 2025
######################################################


# Librairie nécessaire
library(dplyr)

# Fonction pour assembler tous les fichiers CSV sauf taxonomie.csv
assemblage_csv <- function(folder_path) {
  # Lister tous les fichiers CSV sauf taxonomie.csv
  file_list <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  file_list <- file_list[!grepl("taxonomie\\.csv$", file_list)]  # Exclure taxonomie.csv
  
  # Vérifier si des fichiers sont présents
  if (length(file_list) == 0) {
    stop("Aucun fichier CSV (hors taxonomie.csv) trouvé dans le dossier ", folder_path)
  }
  
  # Charger et fusionner tous les fichiers en ajoutant une colonne `source_file`
  data_list <- lapply(file_list, function(file) {
    df <- definition_type_colonne(file)  # Appliquer les types de colonnes
    df <- mutate(df, source_file = basename(file))  # Ajouter la colonne source
    return(df)
  })
  
  all_data <- bind_rows(data_list)
  
  # Message affiché à la fin 
  message("Assemblage terminé avec ajout de la colonne `source_file`.")
  return(all_data)
}
