# library(hms)
# library(chron)
library(readr)
library(dplyr)

fct_temps <- function(folder_path){ #il faut que la colonne du temps soit en caractere a l'appel sinon
  message("\n Début de la correction des valeurs de temps... \n")
  
  # Lister tous les fichiers CSV sauf taxonomie
  file_list <- list.files(path = folder_path, pattern = "\\.csv$", full.names = T)
  file_list <- file_list[file_list!=tail(file_list, n=1)]
  #Applique le chagement du format du temps sur tous les fichiers
  for (file in file_list) {
    df <- read.csv(file, colClasses = c("time_obs" = "character"))
    for (nb in 1:length(df$time_obs)) {
      if(is.na(df$time_obs[nb])== T){
        df$time_obs[nb] <- NA
      }else if(nchar(df$time_obs[nb])==6){
        heure <- substr(df$time_obs[nb], start = 1, stop = 2) #prend les deux caracteres correspondant a l'heure
        minute <- substr(df$time_obs[nb], start = 3, stop = 4) #prend les deux caracteres correspondant aux minutes
        seconde <- substr(df$time_obs[nb], start = 5, stop = 6) #prend les deux caracteres correspondant aux secondes
        df$time_obs[nb] <- paste(heure, minute, seconde, sep = ":") #assemble les heures,minutes,secondes ensembles
      }
    }
    write.csv(df,file)
    message("Correctection appliquée dans : ", basename(file))
  }
  message("fin de la correction des valeurs de temps")
}

