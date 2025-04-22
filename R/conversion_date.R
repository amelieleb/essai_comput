######################################################
# Ce script convertis dwc_event_date` en format Date (YYYY-MM-DD) après l'assemblage

# Créé par Mélina Chicoine
# Date : Création en avril 2025
######################################################


# Librairies nécessaires
library(dplyr)
library(lubridate)

# Fonction pour convertir `dwc_event_date` en format Date après l'assemblage
conversion_date <- function(df) {
  if (!"dwc_event_date" %in% colnames(df)) {
    stop("ATTENTION! Colonne 'dwc_event_date' non trouvée dans le dataset.")
  }
  
  # Convertir en `Date` (YYYY-MM-DD)
  df <- df %>%
    mutate(dwc_event_date = as.Date(dwc_event_date, format = "%Y-%m-%d"))
  
  message(" dwc_event_date est maintenant en format Date (YYYY-MM-DD).")
  return(df)
}
