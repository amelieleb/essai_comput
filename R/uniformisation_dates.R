library(dplyr)
library(stringr)

# Fonction pour convertir `dwc_event_date` en YYYY-MM-DD après l'assemblage
uniformisation_dates <- function(df) {
  if (!"dwc_event_date" %in% colnames(df)) {
    stop("Colonne 'dwc_event_date' non trouvée dans le dataset.")
  }
  
  # S'assurer que `dwc_event_date` est bien en `character`
  df <- df %>%
    mutate(dwc_event_date = as.character(dwc_event_date)) %>%
    mutate(dwc_event_date = case_when(
      str_detect(dwc_event_date, "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z?$") ~ substr(dwc_event_date, 1, 10), # Supprime T00:00:00Z
      str_detect(dwc_event_date, "^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}$") ~ substr(dwc_event_date, 1, 10), # Supprime HH:MM:SS
      TRUE ~ dwc_event_date # Conserver les dates déjà correctes
    ))
  
  message("Toutes les dates sont maintenant au format YYYY-MM-DD dans `toutes_donnees`.")
  return(df)
}
