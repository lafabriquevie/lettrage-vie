# Lettrage Vié

Générateur de lettrage cursif en relief, deux couleurs, pour l'impression 3D chez La Fabrique Vié : cake toppers, enseignes, plaques. Outil interne, sans rapport avec le site lafabriquevie.fr.

## Deux versions

- **Page web** (`lettrage-vie.source.html`) : aperçu 3D en direct et export d'un ZIP qui contient un 3MF (pièces « Socle » et « Texte », à affecter aux filaments AMS) et un STL par couleur.
- **OpenSCAD** (`lettrage-vie.scad`) : à ouvrir dans OpenSCAD, puis Fenêtre > Customizer. Fonctions de base uniquement (3 lignes, arc, chiffre de fond).

## Construire la page

```
python3 build.py
```

Le script injecte les polices de `fonts/` en base64 dans le source et produit `lettrage-vie.html`, un fichier autonome. Il suffit de l'ouvrir dans un navigateur (connexion internet nécessaire pour les bibliothèques three.js, opentype.js, clipper-lib et fflate, chargées depuis cdnjs et jsdelivr).

## Réglages de la page

- Lignes en nombre libre (12 au maximum). Pour chaque ligne : texte, police, hauteur des majuscules, arc (rayon et sens), décalage X/Y, rotation.
- Contour sous le texte, désactivable, avec un arrière plein ou creux (parois, face avant pleine, fond arrière ouvert ou fermé).
- Chiffre ou texte de fond, désactivable.
- Le texte de face reste toujours plein.

## Polices

Pacifico, Lobster et Leckerli One, toutes sous SIL Open Font License 1.1 (licences dans `fonts/`).
