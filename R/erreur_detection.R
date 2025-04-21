library(dplyr)

# Fonction pour détecter les erreurs courantes
erreur_detection <- function(df) {
  message("🔍 Début de la vérification des erreurs...")
  
  # 1. Vérification des coordonnées
  coords_invalides <- df %>%
    filter(lat < -90 | lat > 90 | lon < -180 | lon > 180)
  
  coords_suspectes_utm <- df %>%
    filter(lat > 90 | lon > 180)  # Probable UTM
  
  if (nrow(coords_invalides) > 0) {
    message("⚠️ Coordonnées invalides détectées (hors des limites latitude/longitude) :")
    print(coords_invalides[, c("lat", "lon")])
  } else {
    message("✅ Toutes les coordonnées sont dans les limites normales.")
  }
  
  if (nrow(coords_suspectes_utm) > 0) {
    message("⚠️ Données suspectes détectées (probables coordonnées UTM) :")
    print(coords_suspectes_utm[, c("lat", "lon")])
  }
  
  # 2. Vérification des valeurs négatives pour obs_value
  obs_value_neg <- df %>%
    filter(obs_value < 0)
  
  if (nrow(obs_value_neg) > 0) {
    message("⚠️ Valeurs négatives détectées dans obs_value :")
    print(obs_value_neg[, c("obs_value")])
  } else {
    message("✅ Aucune valeur négative dans obs_value.")
  }
  
  # 3. Vérification de la cohérence des dates
  date_mismatch <- df %>%
    filter(as.integer(format(dwc_event_date, "%Y")) != year_obs)
  
  if (nrow(date_mismatch) > 0) {
    message("⚠️ Incohérences entre dwc_event_date et year_obs :")
    print(date_mismatch[, c("dwc_event_date", "year_obs")])
  } else {
    message("✅ Toutes les dates sont cohérentes avec year_obs.")
  }
  
  message("🔍 Vérification terminée.")
}
