Intégration et nettoyage de données entomologiques de lépidoptères

# Description du projet

Ce projet vise à automatiser l'importation, la vérification, la transformation et l'intégration de jeux de données entomologiques historiques et contemporains portant sur des observations de lépidoptères. Il permet de produire une base de données relationnelle SQLite normalisée, reproductible, et connectée à des ressources taxonomiques officielles.

### Objectifs

-   Nettoyer et harmoniser les données d’observation provenant de fichiers CSV bruts de sources différentes et donc avec des formatages potentiellement différents.

-   Valider et corriger les colonnes clés (dates, coordonnées, identifiants, etc.).

-   Unifier les termes utilisés (ex. : presence → occurrence, abondance → abundance).

-   Ajouter les identifiants taxonomiques (TSN) via l’API de l’ITIS.

-   Générer automatiquement une base de données SQLite relationnelle complète.

-   Rendre le processus entièrement reproductible grâce au package targets.

### Contexte

Ce projet s'inscrit dans une démarche de standardisation de données entomologiques dans le cadre d'études sur la répartition et l’abondance des papillons au Québec. Les jeux de données proviennent de sources variées, et leur hétérogénéité nécessite un important travail de préparation avant analyse.

### Données

Les données se trouvent dans le dossier lepidopteres/ et consistent en :

Des fichiers .csv contenant des observations géoréférencées de lépidoptères répartit selon les années

Un fichier taxonomie.csv listant les noms valides utilisés dans les jeux de données ainsi que des informations sur les espèces de papillons

### Méthodes

Le projet utilise les outils suivants :

-   R et les packages targets, readr, dplyr, lubridate, ritis, DBI, RSQLite.

-   Un pipeline targets structuré pour exécuter en séquence :

    -   sauvegarde des fichiers,

    -   validation des colonnes,

    -   correction des noms et des années,

    -   harmonisation des temps et des termes (presence, abundance...),

    -   ajout des identifiants TSN,

    -   création de la base SQLite relationnelle.

### Résultats

À l’issue de l’exécution du pipeline, le projet génère :

Un dossier de sauvegarde lepidopteres_sauvegarde/.

Un fichier taxonomie_TSN.csv contenant les identifiants taxonomiques officiels (TSN).

Un fichier lepidoptere.sqlite contenant 5 tables relationnelles :

-   principale
-   source
-   creator
-   owning
-   Taxonomie

# Structure du répertoire

``` bash
.
├── R/                        # Scripts de fonctions
├── lepidopteres/             # Données brutes .csv
├── lepidopteres_sauvegarde/  # Sauvegarde automatique des données
├── _targets.R                # Fichier principal du pipeline
├── _targets/                 # Répertoire généré automatiquement par targets
├── lepidoptere.sqlite        # Base de données finale
└── README.md                 # Documentation (ce fichier)
```

``` bash
R/
├── assemblage_csv.R              # Assemble tous les fichiers CSV en une table unique
├── conversion_date.R             # Convertit les dates en format Date
├── coordonnees.R                 # Valide les coordonnées géographiques (lat/lon)
├── correction_des_noms.R         # Corrige les noms de colonnes selon un standard
├── correction_year_obs.R         # Corrige les années d'observation incohérentes
├── corriger_annee.R              # Standardise les formats d’années (ex: 20 → 2020)
├── creer_base_lepidoptere.R      # Crée la base de données SQLite finale
├── erreur_detection.R            # Détecte certaines erreurs (peut être obsolète)
├── Fct_time.R                    # Reformate les temps HHMMSS en HH:MM:SS
├── nom_colonne_correction.R      # Harmonise les noms de colonnes
├── sauvegarde_dossier.R          # Crée une copie de sauvegarde du dossier de données
├── TSN.R                         # Ajoute les identifiants taxonomiques TSN
├── type_colonne.R                # Corrige les types de colonnes (texte vs nombre)
├── uniformisation_dates.R        # Uniformise les formats de dates
├── verification_colonnes.R       # Vérifie la structure des colonnes dans les fichiers
├── verification_valeurs.R        # Détecte les valeurs aberrantes ou manquantes
├── verification_year_obs.R       # Vérifie la validité des années d’observation
├── Script_figure_abondance_par_annee.R  # Script (actuellement vide) 
```

# Description des fichiers

-   `lepidopteres/` : fichiers CSV bruts incluant `taxonomie.csv`.

-   `taxonomie_TSN.csv` : version enrichie automatiquement avec les identifiants TSN.

-   `_targets.R` : définition complète de la pipeline avec `{targets}`.

-   `_targets/` : dossier généré automatiquement par `{targets}` contenant les métadonnées du pipeline.

-   `lepidoptere.sqlite` : base de données SQLite finale, structurée en tables relationnelles, va être créée avec le target

Fonctions contenues dans le dossier R/ - `assemblage_csv.R` : assemble tous les fichiers CSV du dossier en une seule table de données unifiée.

-   `conversion_date.R` : convertit la colonne dwc_event_date au format Date pour les traitements temporels.

-   `coordonnees.R` : ajoute une colonne valid_coords pour identifier les coordonnées valides selon les bornes acceptées.

-   `correction_des_noms.R` : corrige les erreurs typographiques et harmonise les noms de colonnes selon une référence.

!!!!!- `correction_year_obs.R` : corrige les années d'observation invalides en les remplaçant par NA ou par une année plausible.

-   `corriger_annee.R` : standardise les années mal encodées.

-   `creer_base_lepidoptere.R` : génère une base de données relationnelle SQLite à partir des données nettoyées.

-   `Fct_time.R` : transforme les champs time_obs de type HHMMSS en HH:MM:SS.

-   `nom_colonne_correction.R` : harmonise les noms de colonnes selon une liste de correspondances standardisées.

-   `sauvegarde_dossier.R` : crée une copie de sauvegarde du dossier de données pour éviter toute perte accidentelle.

-   `TSN.R` : utilise le package ritis pour ajouter les identifiants taxonomiques TSN aux noms scientifiques.

-   `type_colonne.R` : corrige les types de colonnes mal interprétés (e.g. nombres lus comme caractères).

-   `uniformisation_dates.R` : rend les formats de dates cohérents entre les fichiers CSV.

-   `verification_colonnes.R` : vérifie que chaque fichier possède les colonnes attendues et signale les erreurs.

-   `verification_valeurs.R` : repère des erreurs potentielles sur les jours ou l'abondance, presence ou occurence

-   `verification_year_obs.R` : détecte les années aberrantes ou manquantes dans les colonnes year_obs.

-   `erreur_detection.R` (à retirer si non utilisé) : fonction de détection d'erreurs, si elle est encore active dans le projet.

-   `Script_figure_abondance_par_annee.R` (vide actuellement)

# Instructions

### Comment exécuter le projet

### Comment reproduire les résultats

### Comment accéder aux données et aux ressources

# Auteurs et contributeurs

Ce travail a été réalisé par Mélina Chicoine, Amélie LeBlanc, Amélie Ironman-Rochon et Jérémy Mainville-Gamache
