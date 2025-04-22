######################################################
# Ce script permet d'obtenir un graphique du nombre d'espèces de lépidoptères par
# année pour comparer leur diversité spécifique. Seule les observations du Québec
# sont prises en compte pour l'analyse, et le nombre d'espèces observées est 
# déterminé par observed_scientific_name.

# Créé par Amélie LeBlanc et Amélie Ironman-Rochon
# Date : Création en avril 2025
######################################################


plot_diversite_lepidoptere <- function(db_path = "lepidoptere.sqlite", output_path = "figures/figure_diversite.png") {
  library(DBI)
  library(RSQLite)
  
  # Crée le dossier figures/ s'il n'existe pas
  if (!dir.exists(dirname(output_path))) {
    dir.create(dirname(output_path), recursive = TRUE)
  }
  
  # Connexion à la base
  con <- dbConnect(SQLite(), dbname = db_path)
  
  # Requête SQL
  sql <- "
    SELECT year_obs, COUNT(DISTINCT observed_scientific_name) AS nb_especes_uniques
    FROM principale
    WHERE lat BETWEEN 45 AND 62
      AND lon BETWEEN -80 AND -57
      AND year_obs IS NOT NULL
    GROUP BY year_obs
    ORDER BY year_obs;
  "
  
  df <- dbGetQuery(con, sql)
  dbDisconnect(con)
  
  # Enregistrement dans un fichier PNG
  png(filename = output_path, width = 1000, height = 600, res = 150)
  plot(df$year_obs, df$nb_especes_uniques,
       type = "l", col = "black", lwd = 2,
       xlab = "Année", ylab = "Nombre d'espèces uniques observées",
       main = "Tendance du nombre d'espèces de papillons (1865–2023)")
  dev.off()
  
  message("Graphique sauvegardé dans : ", output_path)
  return(output_path)
}
