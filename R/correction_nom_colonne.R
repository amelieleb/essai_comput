######################################################
# Ce script corrige les erreures possibles dans les noms de colonnes des fichiers csv présents dans le dossier définit ().
# Attention, ce script appelle une autre fonction : liste_nom_colonne, dans laquelle se trouve toutes les corrections possibles. 
# Ainsi le script ci-dessous applique les corrections selon ce qui est observé comme nom de colonne et ce qui est attendu selon les erreurs ex: pommes mais attendu pomme, donc corrige pommes --> pomme

# Créé par Mélina Chicoine
# Date : Création en mars 2025
######################################################

# Librairie nécessaire
library(readr)

# Charger la fonction de correction des noms de colonnes
source("R/liste_nom_colonne.R")

# Fonction pour appliquer la correction des noms de colonnes à tous les fichiers CSV. Applique les corrections selon les erreurs possibles décrites dans le script liste_nom_colonne.R
correction_nom_colonne <- function(folder_path) {
  message("Correction des noms de colonnes dans tous les fichiers CSV...")
  file_list <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  file_list <- file_list[!grepl("taxonomie\\.csv$", file_list)]
  
  for (file in file_list) {
    df <- read_csv(file, show_col_types = FALSE)  # Charger le fichier
    df <- liste_nom_colonne(df)  # Appliquer la correction (aller voir le script liste_nom_colonne pour voir les noms attendus et/ou les corrections)
    write_csv(df, file)  # Sauvegarder le fichier corrigé
  }
  
  # Message écrit une fois tout terminé
  message("Correction des noms de colonnes terminée.")
}

