# Bonjour
# Équipe : Mélina Chicoine, Jérémy, Amélie LeBlanc et Amélie Ironman-Rochon
# Ce travail est pour la base de données de lépidoptères

# Charger les scripts nécessaires
source("scripts/sauvegarde_dossier.R")      # Pour avoir une version du dossier sans modification
source("scripts/verification_colonnes.R")   # Vérification initiale des colonnes
source("scripts/correction_des_noms.R")     # Correction des noms de colonnes. appelle la fonction nom_colonne_correction
source("scripts/verification_year_obs.R")
source("scripts/corriger_annee.R")
source("scripts/correction_year_obs.R")  # Charger la correction de `year_obs`


source("scripts/type_colonne.R")            # Définit les types pour chaque colonne
source("scripts/assemblage_csv.R")          # Assemble les donnees. appelle la fonction type_colonne_csv
source("scripts/uniformisation_dates.R")    # met dwc_event_date en format YYYY-MM-DD
source("scripts/conversion_date.R")         # met dwc_event_date en format Date

source("scripts/verification_valeurs.R")



#source("scripts/correction_coordonnees.R")  
#source("scripts/erreur_detection.R")        

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

# Étape 7 : Exécuter l'assemblage des fichiers CSV
message("Chargement et assemblage des données...")
toutes_donnees <- assemblage_csv("lepidopteres")


# Étape 8 : Uniformisation_dates
message("Uniformisation des dates en YYYY-MM-DD...")
toutes_donnees <- uniformisation_dates(toutes_donnees)

# Étape 9 : Conversion de dwc_event_date en Date
message("Conversion de dwc_event_date en Date...")
toutes_donnees <- conversion_date(toutes_donnees)


# Étape 10 : Vérifier s'il y a des erreurs dans la saisie des données
message("Vérification des valeurs avant correction...")
verification_valeurs(toutes_donnees)


