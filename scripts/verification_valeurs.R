library(dplyr)

# Fonction pour vérifier les valeurs dans `toutes_donnees`
verification_valeurs <- function(df) {
  if (!is.data.frame(df)) {
    stop(" ATTENTION! verification_valeurs()` attend un dataframe (ex: `toutes_donnees`).")
  }
  
  message(" Début de la vérification des valeurs...\n")
  
  
  # ️1 Vérifier que `day_obs` est bien entre 1 et 31
  if ("day_obs" %in% names(df)) {
    erreurs_day <- df %>% filter(day_obs < 1 | day_obs > 31, !is.na(day_obs))
    if (nrow(erreurs_day) > 0) {
      message(" Erreur dans 'day_obs' : certaines valeurs sont hors de la plage [1-31].")
      print(erreurs_day %>% select(source_file, day_obs) %>% head(10))
    }
  }
  
  # ️2 Vérifier que `obs_value` est un nombre positif
  if ("obs_value" %in% names(df)) {
    erreurs_obs <- df %>% filter(obs_value < 0, !is.na(obs_value))
    if (nrow(erreurs_obs) > 0) {
      message(" Erreur dans 'obs_value' : certaines valeurs sont négatives alors qu'elles devraient être positives.")
      print(erreurs_obs %>% select(source_file, obs_value) %>% head(10))
    }
  }
  
  message("\n Vérification des valeurs terminée.")
}
