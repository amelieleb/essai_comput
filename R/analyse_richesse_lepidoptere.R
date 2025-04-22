######################################################
# Ce script crée une nouvelle base de données (new_db) à partir des requêtes SQL.
# La fonction "plot_richesse_lepidoptere" est ensuite appliquée pour obtenir 8
# graphiques de la richesse spécifique des lépidoptères au Québec, afin d’évaluer
# les différences entre les groupes d'années (20 ans).
#
# Résultat : un seul fichier PNG avec les 8 cartes côte à côte.
#
# Créé par Amélie LeBlanc
# Date : Création en avril 2025 
######################################################

analyse_richesse_lepidoptere <- function(db_path = "lepidoptere.sqlite",
                                         output_path = "figures/figure_richesse.png",
                                         resolution_raster = 1,
                                         xlim_fixed = c(-80, -57),
                                         ylim_fixed = c(45, 62)) {
  # Charger la fonction de tracé (nécessaire si elle est dans un script séparé)
  source("R/plot_richesse_lepidoptere.R")
  
  # Charger les bibliothèques nécessaires
  library(DBI)
  library(RSQLite)
  library(dplyr)
  library(viridis)
  library(sp)
  library(raster)
  
  # Créer le dossier de sortie s'il n'existe pas
  if (!dir.exists(dirname(output_path))) {
    dir.create(dirname(output_path), recursive = TRUE)
  }
  
  # Connexion à la base de données
  con <- dbConnect(SQLite(), dbname = db_path)
  
  # Requête SQL pour calculer la richesse spécifique par coordonnées et tranche temporelle
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
  
  # Exécuter la requête
  new_db <- dbGetQuery(con, sql_requete)
  
  # Définir les groupes temporels à tracer
  groupes <- c("1864-1883", "1884-1903", "1904-1923", "1924-1943",
               "1944-1963", "1964-1983", "1984-2003", "2004-2023")
  
  # Créer le fichier de sortie (8 graphiques côte à côte)
  png(output_path, width = 1600, height = 800, res = 150)
  par(mfrow = c(2, 4), mar = c(3, 3, 3, 1), oma = c(0, 0, 4, 0))
  
  # Appliquer la fonction de tracé à chaque groupe
  for (groupe in groupes) {
    plot_richesse_lepidoptere(new_db, groupe,
                              resolution_raster = resolution_raster,
                              xlim_fixed = xlim_fixed,
                              ylim_fixed = ylim_fixed)
  }
  
  # Ajouter un titre global à la figure
  mtext("Richesse spécifique des lépidoptères au Québec par période",
        outer = TRUE, cex = 1.5, line = 1)
  
  # Fermer le fichier PNG
  dev.off()
  
  # Fermer la connexion à la base
  dbDisconnect(con)
  
  # Message et retour du chemin pour le pipeline
  message(" Graphique sauvegardé dans : ", output_path)
  return(output_path)
}
