# Lettrage Vié

Générateur de lettrage en relief multicolore (jusqu'à 4 filaments AMS), pour l'impression 3D chez La Fabrique Vié : cake toppers, enseignes, plaques. Outil interne, sans rapport avec le site lafabriquevie.fr.

## Deux versions

- **Page web** (`lettrage-vie.source.html`) : plan de travail 2D, aperçu 3D et export d'un ZIP qui contient un 3MF (objets « Filament 1 » à « Filament 4 », déjà colorés) et un STL par filament.
- **OpenSCAD** (`lettrage-vie.scad`) : à ouvrir dans OpenSCAD, puis Fenêtre > Customizer. Fonctions de base uniquement (3 lignes, arc, chiffre de fond).

## Construire la page

```
python3 build.py
```

Le script injecte les polices de `fonts/` en base64 dans le source et produit `lettrage-vie.html`, un fichier autonome. Il suffit de l'ouvrir dans un navigateur (connexion internet nécessaire pour les bibliothèques three.js, opentype.js, clipper-lib et fflate, chargées depuis cdnjs et jsdelivr).

## La page

- **Plan de travail** vu de dessus : clic pour sélectionner, glisser pour déplacer (aimantation au centre), poignée ronde pour tourner (Maj = pas de 15°), poignée carrée pour agrandir. Molette ou pincement pour zoomer, glisser sur le vide pour déplacer la vue.
- **Calques** : textes et lettres ou chiffres de fond, en nombre libre. L'ordre de la liste décide qui passe devant ; un texte placé plus bas dans la liste découpe les textes d'une autre couleur qui le recouvrent.
- **Propriétés** de l'élément sélectionné : texte, police (aperçu dans la police), hauteur des majuscules, espacement, arc, relief, filament, position et rotation. Sans sélection : couleurs des 4 filaments et contour commun sous les textes.
- **Formes et icônes** : rectangle, cercle ou ovale, cœur, nuage, étoile ; pieds de bébé, lune, horloge, règle, balance, couronne ; les 12 signes du zodiaque. Une forme sert de **support** (posée sur le plateau, comme une lettre de fond) ou est **en relief** (posée sur ce qu'elle recouvre, comme un texte). Hauteur, largeur (0 = proportions d'origine), arrondi des angles.
- **Liseré** : bordure en relief qui suit le pourtour d'un support ou d'une lettre de fond, avec sa largeur, sa hauteur et son filament.
- **Import SVG** : surfaces remplies et traits, transformations comprises. Le dessin est enregistré dans le projet. Une forme blanche posée sur une noire est fusionnée avec elle : seul le contour extérieur compte.
- Contour et fonds peuvent avoir un **arrière creux** (parois, face avant pleine, fond arrière ouvert ou fermé). Les textes restent pleins.
- **Annuler / rétablir** (Ctrl Z, Ctrl Maj Z), Suppr, Ctrl D pour dupliquer, flèches pour déplacer de 1 mm (10 mm avec Maj).
- **Enregistrer / ouvrir** un projet en `.json`. Le dernier projet est aussi gardé dans le navigateur ; les réglages de l'ancienne version sont repris automatiquement.

## Polices

La page embarque 13 familles sous SIL Open Font License 1.1, en woff (sous-ensemble latin, accents compris) : Roboto, Open Sans, Inter, Montserrat, Lato, Poppins, Oswald, Raleway, Nunito, Playfair Display, avec plusieurs graisses, et les cursives Pacifico, Lobster et Leckerli One. La liste est dans `fonts/polices.json`, les licences dans `fonts/licences/`. Pour ajouter une police : déposer le woff dans `fonts/`, l'ajouter à `polices.json`, relancer `build.py`.

La version OpenSCAD utilise les TTF de `fonts/ttf/`.
