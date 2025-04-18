library(dplyr)
library(sf)  # Pour conversion UTM -> GPS

# Fonction pour corriger les erreurs de coordonnées
correction_coordonnees <- function(df) {
  message("🔧 Début de la correction des coordonnées...")
  
  # 1. Identifier les coordonnées suspectes (probables UTM)
  utm_rows <- df %>%
    filter(abs(lat) > 10000 | abs(lon) > 10000)  # Seuil pour détecter UTM
  
  if (nrow(utm_rows) > 0) {
    message("🔄 Conversion des coordonnées UTM en GPS...")
    
    # Définir le CRS UTM probable (ex: zone 18N pour le Québec)
    crs_utm <- st_crs(32618)  # UTM zone 18N
    crs_wgs84 <- st_crs(4326)  # Système GPS (WGS84)
    
    # Convertir uniquement les points UTM en Latitude/Longitude
    utm_sf <- st_as_sf(utm_rows, coords = c("lon", "lat"), crs = crs_utm)
    utm_points <- st_transform(utm_sf, crs_wgs84) %>% st_coordinates()
    
    # Vérifier que le nombre de lignes correspond
    if (nrow(utm_points) == nrow(utm_rows)) {
      df[df$lat > 10000 | df$lon > 10000, c("lon", "lat")] <- utm_points
    } else {
      warning("❌ Erreur dans la conversion UTM : tailles non correspondantes.")
    }
  }
  
  # 2. Correction des inversions lat/lon après la conversion UTM
  df <- df %>%
    mutate(
      corrected = ifelse(lat < -90 & lon >= -180 & lon <= 180, TRUE, FALSE),
      temp = ifelse(corrected, lat, NA),
      lat = ifelse(corrected, lon, lat),
      lon = ifelse(corrected, temp, lon)
    ) %>%
    select(-temp, -corrected)
  
  # 3. Correction des latitudes supérieures à 90
  df <- df %>%
    mutate(lat = ifelse(lat > 90, -lat, lat))
  
  message("✅ Correction des coordonnées terminée.")
  return(df)
}
