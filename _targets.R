# _targets.R

# Charger les packages nécessaires
library(targets)
library(tarchetypes)

# Définir les options de la pipeline
tar_option_set(
  packages = c("dplyr", "readr", "stringr", "lubridate", "ritis", "DBI", "RSQLite"),
  format = "rds"
)

# Charger les fonctions dans R/
tar_source()

# Pipeline
list(
  tar_target(
    sauvegarde,
    sauvegarde_dossier("lepidopteres", "lepidopteres_sauvegarde"),
    cue = tar_cue(mode = "always")
  ),
  
  tar_target(verif1, verification_colonnes("lepidopteres")),
  tar_target(correction, correction_des_noms("lepidopteres")),
  tar_target(verif2, verification_colonnes("lepidopteres")),
  
  tar_target(verif_year1, verification_year_obs("lepidopteres")),
  tar_target(correction_year, correction_year_obs("lepidopteres")),
  tar_target(verif_year2, verification_year_obs("lepidopteres")),
  
  tar_target(temps_corrige, fct_temps("lepidopteres")),
  tar_target(coord_valide, verification_coordonnees("lepidopteres")),
  tar_target(donnees_assemblees, assemblage_csv("lepidopteres")),
  tar_target(uniformise, uniformisation_dates(donnees_assemblees)),
  tar_target(converti_date, conversion_date(uniformise)),
  tar_target(tsn, TSN_ajout("lepidopteres")),
  
  # Cible ajouté pour utiliser taxonomie_TSN.csv
  tar_target(
    taxonomie_fichier,
    read_csv("lepidopteres/taxonomie_TSN.csv", show_col_types = FALSE)
  ),
  
  # UTILISE LA CIBLE POUR ÉVITER LES ERREURS
  tar_target(
    db_finale,
    creer_base_lepidoptere(converti_date, taxonomie_fichier)
  )
)
