# Intégration et nettoyage de données entomologiques de lépidoptères

## Description du projet

Ce projet vise à automatiser l'importation, la vérification, la transformation et l'intégration de jeux de données entomologiques historiques et contemporains portant sur des observations de lépidoptères. Il permet de produire une base de données relationnelle SQLite normalisée, reproductible, et connectée à des ressources taxonomiques officielles.

### Objectifs

-   Nettoyer et harmoniser les données d’observation provenant de fichiers CSV bruts de sources différentes et donc avec des formatages potentiellement différents.

-   Valider et corriger les colonnes clés (dates, coordonnées, identifiants, etc.).

-   Unifier les termes utilisés (ex. : presence → occurrence, abondance → abundance).

-   Ajouter les identifiants taxonomiques (TSN) via l’API de l’ITIS.

-   Générer automatiquement une base de données SQLite relationnelle complète.

-   Générer 3 figures basées sur les données et un rapport pour en faire l'analyse.

-   Rendre le processus entièrement reproductible grâce au package targets.

### Contexte

Ce projet s'inscrit dans une démarche de standardisation de données entomologiques dans le cadre d'études sur la répartition et l’abondance des papillons. Les jeux de données proviennent de sources variées, et leur hétérogénéité nécessite un important travail de préparation avant l'analyse.

### Données

Les données ont été fournies par Victor Cameron : [Victor.Cameron\@USherbrooke.ca](mailto:Victor.Cameron@USherbrooke.ca){.email} Elles proviennent de plusieurs collaborateurs.

Lorsque vous possédez le dossier : lepidopteres.zip, simplement ouvrir pour obtenir le dossier lepidopteres. Voir section structure du répertoir pour voir où mettre le dossier lepidopteres.

Les données se trouvant dans le dossier lepidopteres/ :

1.  Des fichiers .csv contenant des observations géoréférencées de lépidoptères réparties selon les années.

2.  Un fichier taxonomie.csv listant les noms valides utilisés dans les jeux de données ainsi que des informations sur les espèces de papillons.

### Méthodes

Le projet utilise les outils suivants :

-   R et les packages dplyr, readr, stringr, lubridate, ritis, DBI, RSQLite, viridis, ggplot2, sp, raster

-   Un pipeline targets structuré pour exécuter :

    -   sauvegarde des fichiers,

    -   Validation des colonnes,

    -   Correction des noms et des années,

    -   Correction d'erreurs communes ou de formatage

    -   Uniformisation de la présentation des données

    -   Harmonisation des temps et des termes (presence, abundance...),

    -   Ajout des identifiants TSN,

    -   Création de la base SQLite relationnelle

    -   Création de figures selon les données

    -   Création d'un rapport avec les figures pour l'interprétation des données

### Résultats

À l’issue de l’exécution du pipeline, le projet génère :

Un dossier de sauvegarde lepidopteres_sauvegarde/.

Un fichier taxonomie_TSN.csv contenant les identifiants taxonomiques officiels (TSN).

Un fichier lepidoptere.sqlite contenant 5 tables relationnelles :

-   principale
-   source
-   creator
-   owning
-   taxonomie

Un dossier \_targets contenant toutes les métadonnées du pipeline

Un dossier figures avec 3 figures sur les données de lépidoptères

Un dossier rapport contenant un rapport final contenant également les figures

# Structure du répertoire

``` bash
.
├── R/                        # Scripts de fonctions
├── lepidopteres/             # Données brutes .csv
├── lepidopteres_sauvegarde/  # Sauvegarde automatique des données généré par targets
├── _targets.R                # Fichier principal du pipeline
├── _targets/                 # Répertoire généré automatiquement par targets
├── lepidoptere.sqlite        # Base de données finale
├── rapport_initial.Rmd       # Rapport initial sans les figures mais y faisant appel
├── rapport/                  # Dossier allant contenir le rapport final généré par targets 
└── README.md                 # Documentation (ce fichier)
```

``` bash
R/
├── ajout_TSN.R                        # Ajoute les identifiants taxonomiques TSN dans la taxonomie
├── analyse_richesse_lepidoptere.R    # Génère un ensemble de cartes raster de richesse spécifique par période de 20 ans
├── assemblage_csv.R                  # Assemble tous les fichiers .csv en un seul tableau
├── conversion_date.R                 # Convertit la colonne `dwc_event_date` en format Date
├── correction_nom_colonne.R          # Corrige les noms de colonnes vers un format standard
├── correction_year_obs.R             # Applique les corrections aux années non valides (hors 1800–2050)
├── creer_base_lepidoptere.R          # Crée la base de données SQLite à partir des données nettoyées
├── definition_type_colonne.R         # Corrige les types des colonnes (ex : caractères ou numériques)
├── liste_correction_year_obs.R       # Contient les règles manuelles de correction des années
├── liste_nom_colonne.R               # Contient la liste de noms de colonnes valides attendues
├── plot_abondance_lepidoptere.R      # Génère un graphique d’abondance relative par périodes de 20 ans
├── plot_diversite_lepidoptere.R      # Génère un graphique du nombre d’espèces observées par année
├── plot_richesse_lepidoptere.R       # Affiche une carte de richesse spécifique pour une période donnée
├── sauvegarde_dossier.R              # Fait une copie de sauvegarde du dossier de données
├── uniformisation_dates.R            # Reformate les dates dans un format standard (YYYY-MM-DD)
├── uniformisation_obs_variable.r     # Uniformise les noms de la variable observée (ex : "presence" → "occurrence")
├── uniformisation_time_obs.R         # Reformate les temps `time_obs` en HH:MM:SS
├── verification_colonnes.R           # Vérifie que les colonnes attendues sont présentes
├── verification_coordonnees.R        # Vérifie que les coordonnées géographiques sont valides
├── verification_valeurs.R            # Vérifie la validité des valeurs et détecte les manquants ou aberrants
├── verification_year_obs.R           # Vérifie la cohérence des années dans `year_obs`
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

-   `uniformisation_dates.R` : standardise les dates (ex. 2023-4-7 → 2023-04-07) pour une cohérence entre les fichiers.

-   `uniformisation_obs_variable.R` : détecte et uniformise les valeurs de `obs_variable` (par ex. "presence" → "occurrence").

-   `uniformisation_time_obs.R` : reformate les valeurs `time_obs` du type `HHMMSS` en `HH:MM:SS`.

-   `verification_colonnes.R` : vérifie la présence et l’ordre des colonnes obligatoires dans chaque fichier.

-   `verification_coordonnees.R` : ajoute une colonne `valid_coords` selon la validité des coordonnées (`lat` entre 0 et 90, `lon` entre -180 et 0).

-   `verification_year_obs.R` : repère les années aberrantes ou absentes dans la colonne `year_obs`.

-   `plot_abondance_lepidoptere.R` : génère un graphique à barres de l’abondance relative (%) des 3 espèces principales par groupe de 20 ans.

-   `plot_diversite_lepidoptere.R` : génère un graphique linéaire du nombre d'espèces observées chaque année au Québec.

-   `plot_richesse_lepidoptere.R` : produit une carte raster de la richesse spécifique (diversité spatiale) pour un groupe d’années.

-   `analyse_richesse_lepidoptere.R` : génère une grille de 8 cartes raster (une par groupe de 20 ans) illustrant la richesse spécifique dans le temps.

Pour les autres fichiers :

`_targets.R` : définit et exécute l’ensemble du pipeline de traitement de données avec `{targets}`. Spécifie l’ordre d’exécution des étapes, gère les dépendances entre les fonctions du dossier `R/`, et permet de générer automatiquement les bases de données, figures et rapports reproductibles.

`_targets/`: dossier généré durant le targets contenant les métadonnées et fichiers temporaires du pipeline.

`figures` : va contenir les figures créée par targets soit : `figure_abondance.png`, `figure_diversite.png` et `figure_richesse.png`

`lepidopteres/`: données avec des modifications suite à la réalisation du targets. Il contient également un readme sur les données présentes et un fichier taxonomie.csv avec des informations sur les espèces de papillons. Avec targets, un fichier taxonomie_TSN.csv est également produit, c'est le même que taxonomie.csv avec une colonne de plus pour les TSN

`lepidopteres_sauvegarde/`: données brute sur les lepidopteres, avec taxonomie.csv et readme initiale également

`rapport_initial.Rmd` : rapport initiale sans les figures, mais faisant leur appel

`rapport/`: dossier vide où le rapport final va être enregistré

# Instructions

### Comment exécuter le projet et comment reproduire les résultats

Assurez-vous que le dossier `lepidopteres/` est présent à la racine du projet. Il doit contenir tous les fichiers .csv bruts,

Ouvrez le projet dans RStudio (ou une session R avec le bon répertoire de travail).

Exécutez la pipeline avec `{targets}` en lançant la commande suivante dans la console R :

```{r}
targets::tar_make()
```

Cela exécutera tous les scripts nécessaires (nettoyage, transformation, création de la base SQLite et production des graphiques) en respectant les dépendances. Vous obtiendrez un rapport final dans le dossier rapport.

### Comment accéder aux données et aux ressources

Les données doivent être ajouté par vous dans le répertoir racine. Pour les obtenir contacté : [Victor.Cameron\@USherbrooke.ca](mailto:Victor.Cameron@USherbrooke.ca)

# Auteurs et contributeurs

Ce travail a été réalisé par Mélina Chicoine, Amélie LeBlanc, Amélie Ironman-Rochon et Jérémy Mainville-Gamache
