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




# ---- Création des tableaux ---- 

# Lire le tableau de taxonomie
taxo <- read.csv("lepidopteres/taxonomie.csv", stringsAsFactors = FALSE)

# TABLEAU PRINCIPAL
principal <- toutes_donnees[, c("observed_scientific_name", "ID_principal", "year_obs", "day_obs", "time_obs", "dwc_event_date", 
                                "obs_variable", "obs_unit", "obs_value", "lat", "lon", "valid_coords", "ID_source")]
principal$ID_principal <- paste0(seq_len(nrow(principal)), "p")

# TABLEAU SOURCE : unique + ID_source
source <- unique(toutes_donnees[, c("ID_source", "creator", "original_source", "publisher", "intellectual_rights", "owner", "title", 
                                    "license", "source_file")])
source$ID_source <- paste0(seq_len(nrow(source)), "s")

# TABLEAU TAXONOMIE
taxo <- unique(taxo[, c("observed_scientific_name", "valid_scientific_name", "rank", "vernacular_fr", "kingdom", "phylum", "class", 
                        "order", "family", "genus", "species", "TSN")])

# Ajouter ID_source et taxo dans principal
principal <- merge(principal, source, by = c("ID_source"), all.x = TRUE)
principal <- merge(principal, taxo, by = c("observed_scientific_name"), all.x = TRUE)
principal <- principal[, c("observed_scientific_name", "ID_principal", "year_obs", "day_obs", "time_obs", "dwc_event_date", 
                           "obs_variable", "obs_unit", "obs_value", "lat", "lon", "valid_coords", "ID_source")]


library(DBI)
library(RSQLite)

# Connexion à la base SQLite
lepidoptere <- dbConnect(SQLite(), "lepidoptere.sqlite")



# === CRÉATION DES TABLES ===

# Table source
creer_source <- "
CREATE TABLE source (
  ID_source               VARCHAR(50) PRIMARY KEY,
  creator                 VARCHAR(100),
  originial_source        VARCHAR(100),
  publisher               VARCHAR(100),
  intellectual_rights     VARCHAR(100),
  owner                   VARCHAR(100),
  title                   VARCHAR(200),
  license                 VARCHAR(100),
  source_file             VARCHAR(100),
);"
res <- dbSendQuery(lepidoptere, creer_source)
dbClearResult(res)

# Table principal
creer_principal <- "
CREATE TABLE principal (
  observed_scientific_name VARCHAR(100) PRIMARY KEY,
  ID_principal             VARCHAR(50),
  ID_source                VARCHAR(50),
  year_obs                 INTEGER,
  day_obs                  INTEGER,
  time_obs                 VARCHAR(50),
  dwc_event_date           VARCHAR(50),
  obs_variable             VARCHAR(50),
  obs_unit                 INTEGER,
  obs_value                NUMERIC,
  lat                      REAL,
  lon                      REAL,
  valid_coords             BOLEAN,
  FOREIGN KEY (ID_source) REFERENCES source(ID_source)
);"
res <- dbSendQuery(lepidoptere, creer_principal)
dbClearResult(res)


# Table taxonomie
creer_taxo <- "
CREATE TABLE taxo (
  observed_scientific_name VARCHAR(100),
  valid_scientific_name    VARCHAR(100),
  rank                     VARCHAR(50),
  vernacular_fr            VARCHAR(100),
  kingdom                  VARCHAR(50),
  phylum                   VARCHAR(50),
  class                    VARCHAR(50),
  order                    VARCHAR(50),
  family                   VARCHAR(50),
  genus                    VARCHAR(50),
  species                  VARCHAR(100),
  TSN                      VARCHAR(100),
FOREIGN KEY (observed_scientific_name) REFERENCES principale(observed_scientific_name)
);"
res <- dbSendQuery(lepidoptere, creer_taxo)
dbClearResult(res)


# === INSERTION DES DONNÉES ===

dbWriteTable(lepidoptere, "source", source, append = TRUE, row.names = FALSE)
dbWriteTable(lepidoptere, "principal", principal, append = TRUE, row.names = FALSE)
dbWriteTable(lepidoptere, "taxo", source, append = TRUE, row.names = FALSE)


# Vérification (facultatif)
print(dbListTables(lepidoptere))

# Déconnexion
dbDisconnect(lepidoptere)