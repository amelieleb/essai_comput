######################################################
# Ce script créer une nouvelle base de données (new_db) à partir des requêtes SQL.
# La fonction "plot_richesse_lepidoptere" est ensuite appliquée pour obtenir 8
# graphiques des richesse spécifiques de lépidoptères au Québec pour évaluer les
# différences entre les groupes d'années (20 ans)

# Créé par Amélie LeBlanc
# Date : Création en avril 2025
######################################################

# Fonction principale pour l'analyse complète
analyse_richesse_lepidoptere <- function(db_path = "lepidoptere.sqlite",
                                         resolution_raster = 1,
                                         xlim_fixed = c(-80, -57),
                                         ylim_fixed = c(45, 62)) {
  source("scripts/plot_richesse_lepidoptere.R")
  
  # Charger les bibliothèques nécessaire
  library(DBI)
  library(RSQLite)
  library(dplyr)
  library(viridis)
  library(sp)
  library(raster)
  
  # Connexion à la base de données
  con <- dbConnect(SQLite(), dbname = db_path)
  
  # Requête SQL
  sql_requete <- "SELECT 
  lat,
  lon,
  CASE
    WHEN year_obs BETWEEN 1864 AND 1883 THEN '1864-1883'
    WHEN year_obs BETWEEN 1884 AND 1903 THEN '1884-1903'
    WHEN year_obs BETWEEN 1904 AND 1923 THEN '1904-1923'
    WHEN year_obs BETWEEN 1924 AND 1943 THEN '1924-1943'
    WHEN year_obs BETWEEN 1944 AND 1963 THEN '1944-1963'
    WHEN year_obs BETWEEN 1964 AND 1983 THEN '1964-1983'
    WHEN year_obs BETWEEN 1984 AND 2003 THEN '1984-2003'
    WHEN year_obs BETWEEN 2004 AND 2023 THEN '2004-2023'
    ELSE 'Autre'
  END AS groupe_annees,
  COUNT(DISTINCT observed_scientific_name) AS richesse_specifique
  FROM principale
  WHERE lat BETWEEN 45 AND 62 AND lon BETWEEN -80 AND -57
  GROUP BY lat, lon, groupe_annees
  ORDER BY groupe_annees, richesse_specifique DESC;"
  
  # Récupération des données
  new_db <- dbGetQuery(con, sql_requete)
  
  # Liste des groupes temporels
  groupes <- c("1864-1883", "1884-1903", "1904-1923", "1924-1943",
               "1944-1963", "1964-1983", "1984-2003", "2004-2023")
  
  # Mise en page des graphiques
  par(mfrow = c(2, 4), mar = c(3, 3, 3, 1), oma = c(0, 0, 4, 0))
  
  # Générer chaque carte
  for (groupe in groupes) {
    plot_richesse_lepidoptere(new_db, groupe,
                           resolution_raster = resolution_raster,
                           xlim_fixed = xlim_fixed,
                           ylim_fixed = ylim_fixed)
  }
  
  # Titre général
  mtext("Richesse spécifique des lépidoptères au Québec par période", 
        outer = TRUE, cex = 1.5, line = 1)
  
  # Fermeture de la connexion
  dbDisconnect(con)
}



# Pour observer le graphique, voici la ligne de code à utiliser (il faudra l'ajouter
# dans target, mais je ne suis pas certaine de comment faire, donc en attendant elle
# est ici)
analyse_richesse_lepidoptere()
