######################################################
# Ce script énumère les erreurs possible dans les noms de colonnes et les corrections souhaitées
# Il est intégré dans la fonction corrections_des_noms

# Créé par Mélina Chicoine
# Date : Création en mars 2025
######################################################


# Librairies nécessaire
library(dplyr)
library(stringr)

# Fonction pour corriger les noms de colonnes incohérents dans un dataframe
liste_nom_colonne <- function(df) {
  noms <- colnames(df) %>%
    str_trim() %>%                  # Enlève les espaces superflus
    tolower() %>%                   # Passe en minuscules
    gsub("é|è|ê", "e", .) %>%       # Normalise accents
    gsub("â", "a", .) %>%
    gsub("î", "i", .) %>%
    gsub("ô", "o", .) %>%
    gsub("û", "u", .) %>%
    gsub("à", "a", .)
  
  # Remplacements avec variantes et pluriels
  noms <- noms %>%
    gsub("^titre(s)?$", "title", .) %>%
    gsub("^editeur(s)?$", "publisher", .) %>%
    gsub("^maison[ _-]?edition$", "publisher", .) %>%
    gsub("^licence(s)?$", "license", .) %>%
    gsub("^createur(s)?$", "creator", .) %>%
    gsub("^auteur(s)?$", "author", .) %>%
    gsub("^proprietaire(s)?$", "owner", .) %>%
    gsub("^propriete$", "owner", .) %>%
    gsub("^date[ _-]?de[ _-]?publication$", "publication_date", .) %>%
    gsub("^date[ _-]?de[ _-]?creation$", "creation_date", .) %>%
    gsub("^date$", "date", .) %>%
    gsub("^categorie(s)?$", "category", .)
  
  colnames(df) <- noms
  return(df)
}
