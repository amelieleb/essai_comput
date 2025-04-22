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
├── ajout_TSN.R                        # Ajoute les identifiants taxonomiques TSN dans la taxonomie
├── assemblage_csv.R                  # Assemble tous les fichiers .csv en un seul tableau
├── conversion_date.R                # Convertit la colonne `dwc_event_date` en format Date
├── correction_nom_colonne.R         # Corrige les noms de colonnes vers un format standard
├── correction_year_obs.R            # Applique les corrections aux années non valides (hors 1800–2050)
├── creer_base_lepidoptere.R         # Crée la base de données SQLite à partir des données nettoyées
├── definition_type_colonne.R        # Corrige les types des colonnes (ex : caractères ou numériques)
├── liste_correction_year_obs.R      # Contient les règles manuelles de correction des années
├── liste_nom_colonne.R              # Contient la liste de noms de colonnes valides attendues
├── sauvegarde_dossier.R             # Fait une copie de sauvegarde du dossier de données
├── Script_figure_abondance_par_année.R  # (Vide) Script pour générer des figures d'abondance par année
├── uniformisation_dates.R           # Reformate les dates dans un format standard (YYYY-MM-DD)
├── uniformisation_obs_variable.r    # Uniformise les noms de la variable observée (ex : "presence" → "occurrence")
├── uniformisation_time_obs.R        # Reformate les temps `time_obs` en HH:MM:SS
├── verification_colonnes.R          # Vérifie que les colonnes attendues sont présentes
├── verification_coordonnees.R       # Vérifie que les coordonnées géographiques sont valides
├── verification_valeurs.R           # Vérifie la validité des valeurs et détecte les manquants ou aberrants
├── verification_year_obs.R          # Vérifie la cohérence des années dans `year_obs`
```

# Description des fichiers

Chaque script contenu dans le dossier `R/` correspond à une étape du pipeline de nettoyage, de transformation ou de structuration des données :

-   `ajout_TSN.R` : ajoute les identifiants taxonomiques TSN aux noms scientifiques à l’aide du package `{ritis}`.

-   `assemblage_csv.R` : assemble tous les fichiers `.csv` (sauf taxonomie) en une seule table complète des observations.

-   `conversion_date.R` : convertit la colonne `dwc_event_date` au format `Date` pour les analyses temporelles.

-   `correction_nom_colonne.R` : harmonise les noms de colonnes selon la référence définie dans `liste_nom_colonne.R`.

-   `correction_year_obs.R` : met les valeurs en caractères pour pouvoir appliquer une correction selon la `liste_correction_year_obs.R`

-   `creer_base_lepidoptere.R` : crée une base de données SQLite finale et relationnelle à partir des données nettoyées.

-   `definition_type_colonne.R` : corrige les types de colonnes mal interprétés (ex : chaînes de caractères lues comme numériques).

-   `liste_correction_year_obs.R` : contient les règles manuelles de correction des années d’observation erronées.

-   `liste_nom_colonne.R` : liste de référence des noms de colonnes attendus dans les fichiers d’observation.

-   `sauvegarde_dossier.R` : génère une copie de sauvegarde du dossier `lepidopteres/` avant toute modification par le pipeline.

-   `Script_figure_abondance_par_année.R` : 

-   `uniformisation_dates.R` : standardise les dates (ex. 2023-4-7 → 2023-04-07) pour une cohérence entre les fichiers.

-   `uniformisation_obs_variable.R` : détecte et uniformise les valeurs de `obs_variable` (par ex. "presence" → "occurrence").

-   `uniformisation_time_obs.R` : reformate les valeurs `time_obs` du type `HHMMSS` en `HH:MM:SS`.

-   `verification_colonnes.R` : vérifie la présence et l’ordre des colonnes obligatoires dans chaque fichier.

-   `verification_coordonnees.R` : ajoute une colonne `valid_coords` selon la validité des coordonnées (`lat` entre 0 et 90, `lon` entre -180 et 0).

-   `verification_valeurs.R` : 

-   `verification_year_obs.R` : repère les années aberrantes ou absentes dans la colonne `year_obs`.

# Instructions

### Comment exécuter le projet

### Comment reproduire les résultats

### Comment accéder aux données et aux ressources

# Auteurs et contributeurs

Ce travail a été réalisé par Mélina Chicoine, Amélie LeBlanc, Amélie Ironman-Rochon et Jérémy Mainville-Gamache
