corriger_annee <- function(x, ligne = NULL, fichier = NULL) {
  if (is.na(x) || x == "") return(NA)
  
  x <- as.character(x)
  
  # Cas 1 : Format avec heure UTC (ex: "1985-06-18 12:00:00 UTC")
  if (grepl("^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2} UTC$", x)) {
    x <- gsub(" UTC", "", x)  # Enlever le " UTC"
    date_try <- suppressWarnings(lubridate::ymd_hms(x))
    if (!is.na(date_try)) return(year(date_try))
  }
  
  # Cas 2 : Format "YYYY-MM-DD HH:MM:SS"
  if (grepl("^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}$", x)) {
    date_try <- suppressWarnings(lubridate::ymd_hms(x))
    if (!is.na(date_try)) return(year(date_try))
  }
  
  # Cas 3 : Date simple "YYYY-MM-DD"
  if (grepl("^\\d{4}-\\d{2}-\\d{2}$", x)) {
    date_try <- suppressWarnings(lubridate::ymd(x))
    if (!is.na(date_try)) return(year(date_try))
  }
  
  # Cas 4 : Année seule
  if (grepl("^\\d{4}$", x)) {
    return(as.integer(x))
  }
  
  # Si aucun format ne correspond
  msg <- paste0("Aucun format valide détecté pour la valeur : '", x, "'")
  if (!is.null(fichier)) msg <- paste0(msg, " dans le fichier ", fichier)
  if (!is.null(ligne)) msg <- paste0(msg, " (ligne ", ligne, ")")
  message(msg)
  
  return(NA)
}
