library(readr)

# Charger la fonction de correction des noms de colonnes
source("scripts/nom_colonne_correction.R")

# Fonction pour appliquer la correction des noms de colonnes à tous les fichiers CSV
correction_des_noms <- function(folder_path) {
  message("Correction des noms de colonnes dans tous les fichiers CSV...")
  file_list <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  
  for (file in file_list) {
    df <- read_csv(file, show_col_types = FALSE)  # Charger le fichier
    df <- nom_colonne_correction(df)  # Appliquer la correction
    write_csv(df, file)  # Sauvegarder le fichier corrigé
  }
  
  message("Correction des noms de colonnes terminée.")
}
