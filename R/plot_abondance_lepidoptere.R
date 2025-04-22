plot_abondance_lepidoptere <- function(db_path = "lepidoptere.sqlite", output_path = "figures/figure_abondance.png") {
  # Librairies
  library(DBI)
  library(RSQLite)
  library(dplyr)
  library(ggplot2)
  library(viridis)
  
  # Crée le dossier s'il n'existe pas
  dir.create(dirname(output_path), showWarnings = FALSE, recursive = TRUE)
  
  # Connexion
  con <- dbConnect(SQLite(), dbname = db_path)
  
  # Requête SQL
  sql_requete <- "
    SELECT
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
        END AS year_bloc,
        observed_scientific_name,
        COUNT(*) AS abundance
    FROM principale
    WHERE lat BETWEEN 45 AND 62
      AND lon BETWEEN -80 AND -57
      AND year_obs IS NOT NULL
    GROUP BY year_bloc, observed_scientific_name
    ORDER BY year_bloc, abundance DESC;
  "
  
  resultats <- dbGetQuery(con, sql_requete)
  dbDisconnect(con)
  
  # Traitement des données
  abondance_relative <- resultats %>%
    group_by(year_bloc) %>%
    mutate(pourcentage = (abundance / sum(abundance)) * 100) %>%
    slice_max(pourcentage, n = 3, with_ties = FALSE) %>%
    ungroup()
  
  # Création du graphique
  p <- ggplot(abondance_relative, aes(x = year_bloc, y = pourcentage, fill = observed_scientific_name)) +
    geom_col(position = position_dodge(width = 0.7), width = 0.6, color = "black") +
    scale_fill_viridis_d(option = "H") +
    labs(
      title = "Abondance relative des 3 espèces principales par groupe d'années",
      x = "Années", y = "Abondance relative (%)", fill = "Espèces"
    ) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
      plot.title = element_text(hjust = 0.5),
      axis.ticks = element_line(color = "black"),
      axis.ticks.length = unit(0.2, "cm")
    )
  
  # Sauvegarde
  ggsave(output_path, plot = p, width = 10, height = 6, dpi = 300)
  message("Graphique sauvegardé dans : ", output_path)
  return(output_path)
}
