library(dplyr)

# Fonction pour corriger les noms de colonnes incohérents dans un dataframe
nom_colonne_correction <- function(df) {
  colnames(df) <- colnames(df) %>%
    gsub("^titre$", "title", .) %>%          
    gsub("^éditeur$", "publisher", .) %>%    
    gsub("^licence$", "license", .) %>%      
    gsub("^créateur$", "creator", .) %>%     
    gsub("^propriétaire$", "owner", .)       
  
  return(df)
}
