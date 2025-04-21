# library(hms)
# library(chron)

fct_temps <- function(vct_temps){ #il faut que la colonne du temps soit en caractere a l'appel sinon
  message("Début de la correction des valeurs de temps")
  #les 0 avant les chiffres disparaissent quand ils sont appellés en numerique
  temps_inter <- vct_temps #vct_temps est pour la colonne du temps format HMS
  temps_fin <- c() #vecteur de sortie
  temps_inter <- as.character(temps_inter) #vecteur passant les traitements
  # temps_code <- "" #serait utile si les fonction de temps marcherait en vecteurs
  heure <- "" 
  minute <- ""
  seconde <- ""
  for (i in 1:length(vct_temps)) {
    if(is.na(temps_inter[i])){ #assure que les valeurs manquantes ne passent pas par la sequence creant les temps
      temps_fin[i] <- temps_inter[i] #copie la valeur comme ca s'il y a erreur, la valeur causant problème sera visible
    } else if(nchar(temps_inter[i]==6L)){
      heure <- substr(temps_inter[i], start = 1, stop = 2) #prend les deux caracteres correspondant a l'heure
      minute <- substr(temps_inter[i], start = 3, stop = 4) #prend les deux caracteres correspondant aux minutes
      seconde <- substr(temps_inter[i], start = 5, stop = 6) #prend les deux caracteres correspondant aux secondes
      temps_fin <- paste(heure, minute, seconde, sep = ":") #assemble les heures,minutes,secondes ensembles
      # temps_fin[i] <- times(temps_code) #les deux lignes pourraient donner 
      # temps_fin[i] <- as_hms(temps_code)
    }else{
      temps_fin[i] <- temps_inter[i] #si la valeur passe entre tous les filtres copie la valeur problematique
    }
  }
  message("fin de la correction des valeurs de temps")
  return(temps_fin)
}
