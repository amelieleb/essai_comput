library(readr)
library(dplyr)
library(lubridate)

# Fonction pour corriger le format des dates et extraire l'année
corriger_annee <- function(x, ligne = NULL, fichier = NULL) {
  # Cas 1 : Si la valeur est au format YYYY-MM-DDTHH:MM:SS
  if (grepl("\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}", x)) {
    return(year(ymd_hms(x)))  # Extraire l'année avec lubridate
  }
  
  # Cas 2 : Si la valeur est au format YYYY-MM-DD
  if (grepl("\\d{4}-\\d{2}-\\d{2}", x)) {
    return(year(ymd(x)))  # Extraire l'année avec lubridate
  }
  
  # Cas 3 : Si la valeur est déjà une année seule (ex: 1985)
  if (grepl("^\\d{4}$", x)) {
    return(as.numeric(x))  # Retourner directement l'année
  }
  
  # Si aucun format valide n'est détecté, afficher un message et retourner NA
  msg <- paste0("Aucun format valide détecté pour la valeur : '", x, "'")
  if (!is.null(fichier)) msg <- paste0(msg, " dans le fichier ", fichier)
  if (!is.null(ligne)) msg <- paste0(msg, " (ligne ", ligne, ")")
  message(msg)
  
  return(NA)
}
