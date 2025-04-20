# Équipe : Mélina Chicoine, Jérémy Mainville-Gamache, Amélie LeBlanc et Amélie Ironman-Rochon

# Ce travail est pour la base de données de lépidoptères

# Charger les libraries suivantes : dplyr, lubridate, readr, stringr, hms, chron, ritis

# ---- Charger les scripts nécessaires ----
source("scripts/sauvegarde_dossier.R")      # Pour avoir une version du dossier sans modification
source("scripts/verification_colonnes.R")   # Vérification initiale des colonnes
source("scripts/correction_des_noms.R")     # Correction des noms de colonnes. appelle la fonction nom_colonne_correction
source("scripts/verification_year_obs.R")   # Vérification du format de la date
source("scripts/corriger_annee.R")          # Correction du format de la date
source("scripts/correction_year_obs.R")     # Charger la correction de `year_obs`
source("scripts/Fct_time.R")                # Correction du format du temps
source("scripts/type_colonne.R")            # Définit les types pour chaque colonne
source("scripts/assemblage_csv.R")          # Assemble les donnees. appelle la fonction type_colonne_csv
source("scripts/uniformisation_dates.R")    # met dwc_event_date en format YYYY-MM-DD
source("scripts/conversion_date.R")         # met dwc_event_date en format Date
source("scripts/coordonnees.R")             # Vérification de la validité des coordonnées
source("scripts/TSN.R")                     # Ajout des TSN
source("scripts/verification_valeurs.R")    # Vérification de d'autres erreurs possibles (date et obs_value)
source("scripts/creer_base_lepidoptere.R")  # Création des tables et SQL


# ---- Fonctions de nettoyage des bases de données ----

# Étape 0 : Créer une copie du dossier avant modifications
sauvegarde_dossier("lepidopteres", "lepidopteres_sauvegarde")

# Étape 1 : Vérifier les colonnes avant correction
message(" Vérification initiale des colonnes des fichiers CSV...")
verification_colonnes("lepidopteres")

# Étape 2 : Appliquer la correction des noms de colonnes
message("Application de la correction des noms de colonnes...")
correction_des_noms("lepidopteres")  # Appelle la correction

# Étape 3 : Vérifier les colonnes après correction
message("Vérification des colonnes après correction...")
verification_colonnes("lepidopteres")

# Étape 4: Vérifier que `year_obs` contient uniquement des valeurs YYYY entre 1800 et 2050
verification_year_obs("lepidopteres")

# Étape 5 : Applique la correction nécessaire
correction_year_obs("lepidopteres")

# Étape 6: Revérifier que `year_obs` contient uniquement des valeurs YYYY entre 1800 et 2050
verification_year_obs("lepidopteres")

# Étape 7 : On écrit correctement les valeurs de temps
message("Écriture des valeurs de temps...")
fct_temps("lepidopteres")

# Étape 8 : On ajoute une colonne pour décrire si les coordonnées sont valides ou non
message("Vérification de la validité des coordonnées...")
verification_coordonnees("lepidopteres")

# Étape 9 : Exécuter l'assemblage des fichiers CSV
message("Chargement et assemblage des données...")
toutes_donnees <- assemblage_csv("lepidopteres")

# Étape 10 : Uniformisation_dates
message("Uniformisation des dates en YYYY-MM-DD...")
toutes_donnees <- uniformisation_dates(toutes_donnees)

# Étape 11 : Conversion de dwc_event_date en Date
message("Conversion de dwc_event_date en Date...")
toutes_donnees <- conversion_date(toutes_donnees)

# Étape 12 : Vérification de d'autres erreurs possible
message("Autres erreurs possibles")
verification_valeurs(toutes_donnees)

# Étape 13 : Ajout des TSN dans la base de données taxonomie
message("Ajout des TSN...")
TSN_ajout()

# Étape 14 : Création des tableaux et SQL
message("Création base de données dans SQL")
creer_base_lepidoptere(toutes_donnees)

