######################################################
# Ce script permet d'obtenir un graphique raster qui présente la richesse spécifique
# pour chaque coordonnées valide enregistrer au Québec pendant des groupes d'années
# (20 années) pour évaluer les changements en richesse au cours des années
#
# Créé par Amélie LeBlanc
# Date : Création en avril 2025
######################################################


# Fonction de tracé pour un seul bloc temporel
plot_richesse_lepidoptere <- function(new_db, groupe_annees_label, resolution_raster = 1,
                                      xlim_fixed = c(-80, -57), ylim_fixed = c(45, 62),
                                      output_path = NULL) {
  
  # Charger les bibliothèques nécessaires
  library(dplyr)
  library(viridis)
  library(sp)
  library(raster)
  
  # Filtrer les données pour un groupe d'années
  diversite_bloc <- new_db %>%
    filter(groupe_annees == groupe_annees_label)
  
  # Spatialiser les données
  coordinates(diversite_bloc) <- ~lon + lat
  
  # Créer un raster vide avec une étendue fixe
  r <- raster(extent(xlim_fixed[1], xlim_fixed[2], ylim_fixed[1], ylim_fixed[2]),
              resolution = c(resolution_raster, resolution_raster))
  
  # Rasteriser la richesse
  r <- rasterize(diversite_bloc, r, field = "richesse_specifique", fun = "max")
  
  # Si un chemin de sauvegarde est fourni, on enregistre dans un fichier
  if (!is.null(output_path)) {
    dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)
    png(filename = output_path, width = 1000, height = 800, res = 150)
  }
  
  # Afficher la carte avec des limites fixes
  plot(r,
       main = groupe_annees_label,
       col = viridis(100, option = "turbo"),
       legend.args = list(text = NULL, side = 3, line = 0.5, cex = 1),
       zlim = c(0, 865),
       xlim = xlim_fixed,
       ylim = ylim_fixed)
  
  if (!is.null(output_path)) {
    dev.off()
    message("Carte de richesse sauvegardée : ", output_path)
  }
  
  return(output_path)
}
