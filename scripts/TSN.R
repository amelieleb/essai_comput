#Script qui permet d'obtenir les TSN des noms scientifiques et de les ajouter
#dans une nouvelle colonne du fichier excel taxonomie.csv

#Chargement des packages nécessaire
library(ritis)
library(readr)


# Boucle pour récupérer le TSN pour chaque nom scientifique
 TSN_ajout <- function(file="taxonomie.csv"){
   
   taxonomie <- read_csv(file)
   
   #Ajout d'une colonne TSN dans la base de données taxonomie
   taxonomie$TSN <- NA
   
  for(i in 1:nrow(taxonomie)) {
    
    #Aller chercher le nom scientifique sur un site
    nom_scientifique <- gsub(" ", "\\\\ ", taxonomie$valid_scientific_name[i])
    
    #Aller chercher le TSN associé au nom_scientifique
    result <- itis_search(q = paste0("nameWOInd:", nom_scientifique))
    
    #Si la recherche retourne un résultat, obtenir le TSN
    if(length(result) > 0) {
      taxonomie$TSN[i] <- result$tsn[1]
      
    }
  }
   
   #Sauvegarder le fichier avec les TSN
   write_csv(taxonomie, "taxonomie_TSN.csv")
   
   message("Ajout des TSN trouvés. Fichier sauvegardé")
 }
 