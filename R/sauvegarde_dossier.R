sauvegarde_dossier <- function(original_folder, backup_folder) {
  if (!dir.exists(original_folder)) {
    stop(paste("Le dossier original", original_folder, "n'existe pas."))
  }
  
  # Vérifier si la sauvegarde existe déjà
  if (dir.exists(backup_folder)) {
    message(" Un dossier de sauvegarde existe déjà. Aucune action prise.")
  } else {
    message(" Création d'une copie du dossier '", original_folder, "' en '", backup_folder, "'...")
    dir.create(backup_folder)  # Créer le dossier de sauvegarde
    
    # Lister les fichiers à copier (sauf taxonomie_TSN.csv)
    file_list <- list.files(original_folder, full.names = TRUE, recursive = TRUE)
    file_list <- file_list[!grepl("taxonomie_TSN\\.csv$", file_list)]
    
    for (file in file_list) {
      new_file <- gsub(original_folder, backup_folder, file)  # Modifier le chemin cible
      if (dir.exists(file)) {
        dir.create(new_file, recursive = TRUE)  # Créer les sous-dossiers
      } else {
        file.copy(file, new_file)  # Copier les fichiers
      }
    }
    
    message("Sauvegarde terminée : '", backup_folder, "'")
  }
}
