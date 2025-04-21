# Créer un tableau avec le nombre d'espèces par année
library(dplyr)7

toutes_donnees_quebec <- toutes_donnees %>%
  dplyr::filter(lat >= 45 & lat <= 62,
                lon >= -80 & lon <= -57)

especes_par_annee <- toutes_donnees_quebec %>%
  group_by(year_obs) %>%
  summarise(nb_especes = n_distinct(observed_scientific_name)) %>%
  arrange(year_obs)

# Créer la figure
plot(especes_par_annee$year_obs, especes_par_annee$nb_especes,
     type = "l",
     col = "blue",
     lwd = 2,
     xlab = "Année",
     ylab = "Nombre d'espèces uniques observées",
     main = "Tendance des espèces de papillons (1859–2023)")

