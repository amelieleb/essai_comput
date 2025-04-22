######################################################
# Ce script réalise le target de toutes les fonctions présentes dans R/

# Créé par Mélina Chicoine, Amélie LeBlanc, Amélie Ironman-Rochon et Jérémy Mainville-Gamache
# Date : Création en avril 2025
######################################################


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
  # 1.Création d'une sauvegarde des données
  tar_target(
    sauvegarde,
    sauvegarde_dossier("lepidopteres", "lepidopteres_sauvegarde"),
    cue = tar_cue(mode = "always")
  ),
  # 2.1 Vérifie les noms des colonnes avant la correction
  tar_target(verif1, verification_colonnes("lepidopteres")),
  # 2.2 Applique la correction des noms des colonnes
  tar_target(correction, correction_nom_colonne("lepidopteres")),
  # 2.3 Vérifie les noms des colonnes après la correction
  tar_target(verif2, verification_colonnes("lepidopteres")),
  
  # 3.1 Vérifie que "year_obs" contient uniquement des valeurs YYYY entre 1800 et 2050
  tar_target(verif_year1, verification_year_obs("lepidopteres")),
  # 3.2 Applique les corrections nécessaires des valeurs de "year_obs"
  tar_target(correction_year, correction_year_obs("lepidopteres")),
  # 3.3 Revérifie que "year_obs" contien que des valeurs valides
  tar_target(verif_year2, verification_year_obs("lepidopteres")),
  
  # 4. Applique la correction aux valeurs de "obs_time" dans un format différent
  tar_target(temps_corrige, uniformisation_time_obs("lepidopteres")),
  
  # 5. Applique les corrections nécessaires aux valeurs des coordonnées
  tar_target(coord_valide, verification_coordonnees("lepidopteres")),
  
  # 6. Détecte les différents termes utilisés et uniformise les termes utilisées
  #    dans "obs_variable"
  tar_target(variable_uniforme, uniformisation_obs_variable("lepidopteres")),
  
  # 7. Assemble les données en un seul tableau
  tar_target(donnees_assemblees, assemblage_csv("lepidopteres")),
  
  # 8. Uniformise le format des dates en YYYY-MM-DD
  tar_target(uniformise, uniformisation_dates(donnees_assemblees)),
  
  # 9. Conersion de dwc_event_date en une date
  tar_target(converti_date, conversion_date(uniformise)),
  
  # 10. Ajoute des TSN dans la base de données taxonomie
  tar_target(tsn, ajout_TSN("lepidopteres")),
  # 11. Cible ajouté pour utiliser taxonomie_TSN.csv
  tar_target(
    taxonomie_fichier,
    read_csv("lepidopteres/taxonomie_TSN.csv", show_col_types = FALSE)
  ),
  # 12. Production de la base de données
  # UTILISE LA CIBLE POUR ÉVITER LES ERREURS
  tar_target(
    db_finale,
    creer_base_lepidoptere(converti_date, taxonomie_fichier)
  )
)
