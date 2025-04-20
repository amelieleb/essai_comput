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

# Étape 12 : Ajout des TSN dans la base de données taxonomie
message("Ajout des TSN...")
TSN_ajout()




# ---- Création des tableaux ---- 
# Créer ID_principale avec suffixe "p"
toutes_donnees$ID_principale <- paste0(seq_len(nrow(toutes_donnees)), "p")

# TABLEAU PRINCIPALE
principale <- toutes_donnees[, c("ID_principale", "observed_scientific_name", "title", "license", "source_file")]

# CREATOR : unique + ID_creator
creator <- unique(toutes_donnees[, c("creator", "original_source")])
creator$ID_creator <- paste0(seq_len(nrow(creator)), "c")

# OWNING : unique + ID_owning
owning <- unique(toutes_donnees[, c("publisher", "intellectual_rights", "owner")])
owning$ID_owning <- paste0(seq_len(nrow(owning)), "o")

# SOURCE : unique + ID_source
source <- unique(toutes_donnees[, c("creator", "original_source", "publisher", "intellectual_rights", "owner", "title", "license", "source_file")])
source <- merge(source, creator, by = c("creator", "original_source"), all.x = TRUE)
source <- merge(source, owning, by = c("publisher", "intellectual_rights", "owner"), all.x = TRUE)
source$ID_source <- paste0(seq_len(nrow(source)), "s")
source <- source[, c("ID_source", "ID_creator", "ID_owning", "title", "license", "source_file")]

# Ajouter ID_source dans principale
principale <- merge(principale, source, by = c("title", "license", "source_file"), all.x = TRUE)
principale <- principale[, c("ID_principale", "observed_scientific_name", "ID_source")]

# TABLEAU OBSERVATION
observation <- toutes_donnees[, c("ID_principale", "observed_scientific_name", "dwc_event_date", "year_obs", "day_obs", "obs_value")]

# TABLEAU WHEN
when <- toutes_donnees[, c("ID_principale", "year_obs", "day_obs", "time_obs")]

# TABLEAU WHERE
where <- toutes_donnees[, c("ID_principale", "lat", "lon")]



library(DBI)
library(RSQLite)

# Connexion à la base SQLite
lepidoptere <- dbConnect(SQLite(), "lepidoptere.sqlite")

# === CRÉATION DES TABLES ===

# Table principale
creer_principale <- "
CREATE TABLE principale (
  ID_principale            VARCHAR(50) PRIMARY KEY,
  observed_scientific_name VARCHAR(100),
  ID_source                VARCHAR(50)
);"
res <- dbSendQuery(lepidoptere, creer_principale)
dbClearResult(res)

# Table observation
creer_observation <- "
CREATE TABLE observation (
  ID_principale            VARCHAR(50),
  observed_scientific_name VARCHAR(100),
  dwc_event_date           VARCHAR(50),
  year_obs                 INTEGER,
  day_obs                  INTEGER,
  obs_value                NUMERIC,
  FOREIGN KEY (ID_principale) REFERENCES principale(ID_principale)
);"
res <- dbSendQuery(lepidoptere, creer_observation)
dbClearResult(res)

# Table creator
creer_creator <- "
CREATE TABLE creator (
  ID_creator       VARCHAR(50) PRIMARY KEY,
  creator          VARCHAR(100),
  original_source  VARCHAR(100)
);"
res <- dbSendQuery(lepidoptere, creer_creator)
dbClearResult(res)

# Table owning
creer_owning <- "
CREATE TABLE owning (
  ID_owning            VARCHAR(50) PRIMARY KEY,
  publisher            VARCHAR(100),
  intellectual_rights  VARCHAR(100),
  owner                VARCHAR(100)
);"
res <- dbSendQuery(lepidoptere, creer_owning)
dbClearResult(res)

# Table source
creer_source <- "
CREATE TABLE source (
  ID_source     VARCHAR(50) PRIMARY KEY,
  ID_creator    VARCHAR(50),
  ID_owning     VARCHAR(50),
  title         VARCHAR(200),
  license       VARCHAR(100),
  source_file   VARCHAR(100),
  FOREIGN KEY (ID_creator) REFERENCES creator(ID_creator),
  FOREIGN KEY (ID_owning) REFERENCES owning(ID_owning)
);"
res <- dbSendQuery(lepidoptere, creer_source)
dbClearResult(res)

# Table when (renommée pour éviter mot réservé)
creer_when <- "
CREATE TABLE when_table (
  ID_principale  VARCHAR(50),
  year_obs       INTEGER,
  day_obs        INTEGER,
  time_obs       VARCHAR(50),
  FOREIGN KEY (ID_principale) REFERENCES principale(ID_principale)
);"
res <- dbSendQuery(lepidoptere, creer_when)
dbClearResult(res)

# Table where (renommée pour éviter mot réservé)
creer_where <- "
CREATE TABLE where_table (
  ID_principale  VARCHAR(50),
  lat            REAL,
  lon            REAL,
  FOREIGN KEY (ID_principale) REFERENCES principale(ID_principale)
);"
res <- dbSendQuery(lepidoptere, creer_where)
dbClearResult(res)

# === INSERTION DES DONNÉES ===

dbWriteTable(lepidoptere, "principale", principale, append = TRUE, row.names = FALSE)
dbWriteTable(lepidoptere, "observation", observation, append = TRUE, row.names = FALSE)
dbWriteTable(lepidoptere, "creator", creator, append = TRUE, row.names = FALSE)
dbWriteTable(lepidoptere, "owning", owning, append = TRUE, row.names = FALSE)
dbWriteTable(lepidoptere, "source", source, append = TRUE, row.names = FALSE)
dbWriteTable(lepidoptere, "when_table", when, append = TRUE, row.names = FALSE)
dbWriteTable(lepidoptere, "where_table", where, append = TRUE, row.names = FALSE)

# Vérification (facultatif)
print(dbListTables(lepidoptere))

# Déconnexion
dbDisconnect(lepidoptere)
