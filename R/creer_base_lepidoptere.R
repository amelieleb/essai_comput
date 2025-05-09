######################################################
# Ce script crée des tables puis les mets dans une base de donnée SQL et injecte les données à la fin

# Créé par Mélina Chicoine, Amélie LeBlanc, Amélie Ironman-Rochon et Jérémy Mainville-Gamache
# Date : Création en avril 2025
######################################################

#Librairies nécessaires
library(DBI)
library(RSQLite)
library(dplyr)

creer_base_lepidoptere <- function(toutes_donnees, taxo, nom_sqlite = "lepidoptere.sqlite") {
  
  # Supprimer le fichier SQLite s'il existe déjà
  if (file.exists(nom_sqlite)) file.remove(nom_sqlite)
  
  # === TABLE CREATOR ===
  creator <- unique(toutes_donnees[, c("creator", "original_source")])
  creator$ID_creator <- paste0(seq_len(nrow(creator)), "c")
  
  # === TABLE OWNING ===
  owning <- unique(toutes_donnees[, c("publisher", "intellectual_rights", "owner")])
  owning$ID_owning <- paste0(seq_len(nrow(owning)), "o")
  
  # === TABLE SOURCE ===
  source_df <- unique(toutes_donnees[, c(
    "creator", "original_source", "publisher", "intellectual_rights",
    "owner", "title", "license", "source_file"
  )])
  
  source_df <- merge(source_df, creator, by = c("creator", "original_source"), all.x = TRUE)
  source_df <- merge(source_df, owning, by = c("publisher", "intellectual_rights", "owner"), all.x = TRUE)
  source_df$ID_source <- paste0(seq_len(nrow(source_df)), "s")
  
  # === TABLE PRINCIPALE ===
  principale <- toutes_donnees[, c(
    "observed_scientific_name", "year_obs", "day_obs", "time_obs",
    "dwc_event_date", "obs_variable", "obs_unit", "obs_value", "lat", "lon", "source_file"
  )]
  
  principale <- merge(principale, source_df[, c("ID_source", "source_file")], by = "source_file", all.x = TRUE)
  principale$ID_principale <- paste0(seq_len(nrow(principale)), "p")
  
  principale <- principale[, c(
    "ID_principale", "observed_scientific_name", "year_obs", "day_obs", "time_obs", "dwc_event_date",
    "obs_variable", "obs_unit", "obs_value", "lat", "lon", "ID_source"
  )]
  
  # === TABLE TAXONOMIE ===
  taxo <- unique(taxo[, c(
    "observed_scientific_name", "valid_scientific_name", "rank", "vernacular_fr",
    "kingdom", "phylum", "class", "order", "family", "genus", "species", "TSN"
  )])
  
  # === CONNEXION À LA BASE ===
  lepidoptere <- dbConnect(SQLite(), nom_sqlite)
  
  # === CRÉATION DES TABLES ===
  dbExecute(lepidoptere, "
    CREATE TABLE creator (
      ID_creator       VARCHAR(50) PRIMARY KEY,
      creator          VARCHAR(100),
      original_source  VARCHAR(100)
    );")
  
  dbExecute(lepidoptere, "
    CREATE TABLE owning (
      ID_owning            VARCHAR(50) PRIMARY KEY,
      publisher            VARCHAR(100),
      intellectual_rights  VARCHAR(100),
      owner                VARCHAR(100)
    );")
  
  dbExecute(lepidoptere, "
    CREATE TABLE source (
      ID_source     VARCHAR(50) PRIMARY KEY,
      ID_creator    VARCHAR(50),
      ID_owning     VARCHAR(50),
      title         VARCHAR(200),
      license       VARCHAR(100),
      source_file   VARCHAR(100),
      FOREIGN KEY (ID_creator) REFERENCES creator(ID_creator),
      FOREIGN KEY (ID_owning) REFERENCES owning(ID_owning)
    );")
  
  dbExecute(lepidoptere, "
    CREATE TABLE principale (
      ID_principale            VARCHAR(50) PRIMARY KEY,
      observed_scientific_name VARCHAR(100),
      year_obs                 INTEGER,
      day_obs                  INTEGER,
      time_obs                 VARCHAR(50),
      dwc_event_date           VARCHAR(50),
      obs_variable             VARCHAR(100),
      obs_unit                 VARCHAR(50),
      obs_value                NUMERIC,
      lat                      REAL,
      lon                      REAL,
      ID_source                VARCHAR(50),
      FOREIGN KEY (ID_source) REFERENCES source(ID_source)
    );")
  
  dbExecute(lepidoptere, "
    CREATE TABLE Taxonomie (
      observed_scientific_name VARCHAR(100),
      valid_scientific_name    VARCHAR(100),
      rank                     VARCHAR(50),
      vernacular_fr            VARCHAR(100),
      kingdom                  VARCHAR(50),
      phylum                   VARCHAR(50),
      class                    VARCHAR(50),
      'order'                  VARCHAR(50),
      family                   VARCHAR(50),
      genus                    VARCHAR(50),
      species                  VARCHAR(100),
      TSN                      VARCHAR(50),
      FOREIGN KEY (observed_scientific_name) REFERENCES principale(observed_scientific_name)
    );")
  
  # === INSERTION DES DONNÉES ===
  dbWriteTable(lepidoptere, "creator", creator, append = TRUE, row.names = FALSE)
  dbWriteTable(lepidoptere, "owning", owning, append = TRUE, row.names = FALSE)
  dbWriteTable(lepidoptere, "source", source_df[, c(
    "ID_source", "ID_creator", "ID_owning", "title", "license", "source_file"
  )], append = TRUE, row.names = FALSE)
  dbWriteTable(lepidoptere, "principale", principale, append = TRUE, row.names = FALSE)
  dbWriteTable(lepidoptere, "taxonomie", taxo, append = TRUE, row.names = FALSE)
  
  message("Base de données SQLite créée avec succès : ", nom_sqlite)
  print(dbListTables(lepidoptere))
  
  dbDisconnect(lepidoptere)
}
