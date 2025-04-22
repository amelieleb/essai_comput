######################################################
# Ce script permet d'obtenir 8 graphiques de la richesse spécifique selon les
# coordonnées géographique du Québec pour différents groupes d'années (20 ans)

# Créé par Amélie LeBlanc
# Date : Création en avril 2025
######################################################


library(dplyr)
library(viridis)
library(sp)
library(raster)

plot_richesse_bloc <- function(data, annee_debut, annee_fin, resolution_raster = 1) {
  
  # Filtrer les données pour le bloc d'années
  diversite_bloc <- data %>%
    filter(year_obs >= annee_debut, year_obs <= annee_fin) %>%
    group_by(lon, lat) %>%
    summarise(richesse = n_distinct(observed_scientific_name), .groups = "drop")
  
  # Résumé rapide
  print(summary(diversite_bloc))
  
  # Spatialiser les données
  coordinates(diversite_bloc) <- ~lon + lat
  
  # Créer un raster vide
  r <- raster(extent(diversite_bloc), resolution = c(resolution_raster, resolution_raster))
  
  # Ratisser la richesse
  r <- rasterize(diversite_bloc, r, field = "richesse", fun = "max")
  
  # Créer un titre dynamique
  titre <- paste(" (", annee_debut, "-", annee_fin, ")", sep = "")
  
  # Afficher la carte
  plot(r,
       main = titre,
       col = viridis(100, option = "turbo"),
       legend.args = list(text = "RS", side = 3, line = 0.5, cex = 1),
       zlim = c(0, 865))  # Ajuste si nécessaire selon tes données
}

par(mfrow = c(2, 4), mar = c(3, 3, 3, 1))  # marges réduites

# Générer toutes les cartes
for (bloc in blocs) {
  plot_richesse_bloc(toutes_donnees_quebec, bloc[1], bloc[2])
}