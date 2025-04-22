######################################################
# Ce script permet d'obtenir un graphique du nombre d'espèces de lépidoptères par
# année pour comparer leur diversité spécifique. Seule les observations du Québec
# sont prises en compte pour l'analyse, et le nombre d'espèces observées est 
# déterminé par observed_scientific_name.

# Créé par Amélie LeBlanc et Amélie Ironman-Rochon
# Date : Création en avril 2025
######################################################


plot_diversite_lepidoptere <- function(db_path = "lepidoptere.sqlite") {
  
  # Charger les bibliothèques nécessaires
  library(DBI)
  library(RSQLite)
  
  # Connexion à la base de données
  con <- dbConnect(SQLite(), dbname = db_path)
  
  # Requête SQL pour obtenir le nombre d'espèces uniques par année au Québec
  sql_requete_graph_1 <- "
    SELECT year_obs, COUNT(DISTINCT observed_scientific_name) AS nb_especes_uniques
    FROM principale
    WHERE lat BETWEEN 45 AND 62
      AND lon BETWEEN -80 AND -57
      AND year_obs IS NOT NULL
    GROUP BY year_obs
    ORDER BY year_obs;
  "
  
  # Exécuter la requête
  nb_especes_annee <- dbGetQuery(con, sql_requete_graph_1)
  
  # Tracer le graphique
  plot(nb_especes_annee$year_obs, nb_especes_annee$nb_especes_uniques,
       type = "l",
       col = "black",
       lwd = 2,
       xlab = "Année",
       ylab = "Nombre d'espèces uniques observées",
       main = "Tendance du nombre d'espèces de papillons (1865–2023)")
  
  # Déconnexion de la base de données
  dbDisconnect(con)
}


# Pour observer le graphique, voici la ligne de code à utiliser (il faudra l'ajouter
# dans target, mais je ne suis pas certaine de comment faire, donc en attendant elle
# est ici)
plot_diversite_lepidoptere()