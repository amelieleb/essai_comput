library(dplyr)

# Fonction pour vérifier les valeurs dans `toutes_donnees`
verification_valeurs <- function(df) {
  if (!is.data.frame(df)) {
    stop(" ATTENTION! verification_valeurs()` attend un dataframe (ex: `toutes_donnees`).")
  }
  
  message(" Début de la vérification des valeurs...\n")
  
  # 1 Vérifier que `year_obs` contient uniquement des années valides (1800-2100)
  if ("year_obs" %in% names(df)) {
    erreurs_year <- df %>% filter(!year_obs %in% 1800:2100, !is.na(year_obs))
    if (nrow(erreurs_year) > 0) {
      message("⚠️ Erreur dans 'year_obs' : certaines valeurs ne sont pas des années valides.")
      print(erreurs_year %>% select(source_file, year_obs) %>% head(10))  # Affiche 10 exemples
    }
  }
  
  # 2️ Vérifier que `day_obs` est bien entre 1 et 31
  if ("day_obs" %in% names(df)) {
    erreurs_day <- df %>% filter(day_obs < 1 | day_obs > 31, !is.na(day_obs))
    if (nrow(erreurs_day) > 0) {
      message("⚠️ Erreur dans 'day_obs' : certaines valeurs sont hors de la plage [1-31].")
      print(erreurs_day %>% select(source_file, day_obs) %>% head(10))
    }
  }
  
  # 3️ Vérifier que `lat` est bien entre -90 et 90 et `lon` entre -180 et 180
  if ("lat" %in% names(df)) {
    erreurs_lat <- df %>% filter(lat < -90 | lat > 90, !is.na(lat))
    if (nrow(erreurs_lat) > 0) {
      message("⚠️ Erreur dans 'lat' : certaines valeurs sont hors de la plage [-90, 90].")
      print(erreurs_lat %>% select(source_file, lat) %>% head(10))
    }
  }
  if ("lon" %in% names(df)) {
    erreurs_lon <- df %>% filter(lon < -180 | lon > 180, !is.na(lon))
    if (nrow(erreurs_lon) > 0) {
      message("⚠️ Erreur dans 'lon' : certaines valeurs sont hors de la plage [-180, 180].")
      print(erreurs_lon %>% select(source_file, lon) %>% head(10))
    }
  }
  
  # 4️ Vérifier que `obs_value` est un nombre positif
  if ("obs_value" %in% names(df)) {
    erreurs_obs <- df %>% filter(obs_value < 0, !is.na(obs_value))
    if (nrow(erreurs_obs) > 0) {
      message("⚠️ Erreur dans 'obs_value' : certaines valeurs sont négatives alors qu'elles devraient être positives.")
      print(erreurs_obs %>% select(source_file, obs_value) %>% head(10))
    }
  }
  
  # 5 Vérifier que `dwc_event_date` est bien au format YYYY-MM-DD
  if ("dwc_event_date" %in% names(df)) {
    erreurs_date <- df %>% filter(!grepl("^\\d{4}-\\d{2}-\\d{2}$", dwc_event_date), !is.na(dwc_event_date))
    if (nrow(erreurs_date) > 0) {
      message("⚠️ Erreur dans 'dwc_event_date' : certaines valeurs ne respectent pas le format YYYY-MM-DD.")
      print(erreurs_date %>% select(source_file, dwc_event_date) %>% head(10))
    }
  }
  
  message("\n Vérification des valeurs terminée.")
}
