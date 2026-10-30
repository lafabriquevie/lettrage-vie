// Lettrage Vié, version OpenSCAD : texte en relief deux couleurs – La Fabrique Vié
// Ouvrir dans OpenSCAD, puis Fenêtre > Customizer.
// Export 2 couleurs : choisir partie = "socle", F6, exporter STL ;
// puis partie = "texte", F6, exporter STL. Importer les deux dans
// Bambu Studio comme un seul objet (parties) et affecter les filaments.

/* [Ligne 1] */
texte1 = "Happy Birthday";
police1 = "Pacifico"; // [Pacifico, Lobster, Leckerli One]
taille1 = 14; // [4:0.5:60]
// Rayon de l'arc en mm. 0 = droit, petit = très courbé
courbure1 = 0; // [0:5:400]
// Coché = arc vers le bas (sourire), sinon vers le haut
arc_inverse1 = false;

/* [Ligne 2] */
texte2 = "to you";
police2 = "Pacifico"; // [Pacifico, Lobster, Leckerli One]
taille2 = 9; // [4:0.5:60]
courbure2 = 0; // [0:5:400]
arc_inverse2 = false;

/* [Ligne 3] */
texte3 = "Elena";
police3 = "Pacifico"; // [Pacifico, Lobster, Leckerli One]
taille3 = 16; // [4:0.5:60]
courbure3 = 0; // [0:5:400]
arc_inverse3 = false;

/* [Mise en page] */
// Écart vertical entre les lignes (mm, de centre à centre en plus des tailles)
interligne = 2; // [-10:0.5:20]
// Espacement des lettres (1 = normal)
espacement = 1; // [0.8:0.01:1.5]

/* [Chiffre de fond] */
// Laisser vide pour ne pas en mettre
chiffre = "10";
police_chiffre = "Leckerli One"; // [Pacifico, Lobster, Leckerli One]
taille_chiffre = 60; // [10:1:150]
decalage_chiffre_x = 0; // [-80:1:80]
decalage_chiffre_y = 0; // [-80:1:80]

/* [Épaisseurs et contour] */
// Épaisseur de la plaque du chiffre (mm)
epaisseur_fond = 2; // [0.6:0.2:10]
// Épaisseur du contour autour du texte (mm)
epaisseur_contour = 3; // [0.6:0.2:10]
// Hauteur du texte au-dessus du contour (mm)
relief_texte = 1.2; // [0.2:0.2:6]
// Largeur du contour autour des lettres (mm)
largeur_contour = 1.6; // [0.4:0.1:6]
// Comble les creux entre lettres (mm, 0 = désactivé)
lissage = 1; // [0:0.5:6]

/* [Export] */
partie = "apercu"; // [apercu, socle, texte]
couleur_socle = "pink";
couleur_texte = "white";

/* [Hidden] */
use <fonts/Pacifico-Regular.ttf>
use <fonts/Lobster-Regular.ttf>
use <fonts/LeckerliOne-Regular.ttf>
$fn = 32;
pas_tranche = 0.5; // largeur des tranches pour la courbure (mm)

textes   = [texte1, texte2, texte3];
polices  = [police1, police2, police3];
tailles  = [taille1, taille2, taille3];
courbes  = [courbure1, courbure2, courbure3];
inverses = [arc_inverse1, arc_inverse2, arc_inverse3];
actives  = [for (i = [0:2]) if (len(textes[i]) > 0) i];

// Hauteur occupée par une ligne : la taille OpenSCAD vaut ~ la hauteur des capitales
function hauteur(i) = tailles[i] * 1.4;
function somme(v, n) = n <= 0 ? 0 : v[n - 1] + somme(v, n - 1);
hauteurs = [for (i = actives) hauteur(i) + interligne];
hauteur_totale = somme(hauteurs, len(hauteurs)) - interligne;
// Ordonnée du centre de la k-ième ligne active (la 1re en haut)
function y_ligne(k) = hauteur_totale / 2 - somme(hauteurs, k) - hauteur(actives[k]) / 2;

module ligne_droite(i)
    text(textes[i], size = tailles[i], font = polices[i],
         halign = "center", valign = "center", spacing = espacement);

// Courbe une forme 2D centrée sur x=0 le long d'un cercle de rayon r.
// Découpe en tranches verticales, chacune tournée à sa place sur l'arc :
// les liaisons des lettres cursives restent intactes.
module courber(r, inverse, demi_largeur) {
    s = inverse ? -1 : 1;
    n = ceil(demi_largeur / pas_tranche);
    for (k = [-n:n - 1]) {
        x0 = k * pas_tranche;
        xc = x0 + pas_tranche / 2;
        a = xc / r * 180 / PI;
        translate([0, -s * r]) rotate(-s * a) translate([-xc, s * r])
            intersection() {
                children();
                translate([x0 - 0.01, -demi_largeur])
                    square([pas_tranche + 0.02, 2 * demi_largeur]);
            }
    }
}

module ligne(i) {
    // Demi-largeur estimée large : les tranches vides ne coûtent presque rien
    if (courbes[i] > 0)
        courber(courbes[i], inverses[i], len(textes[i]) * tailles[i] * espacement * 0.6 + 5)
            ligne_droite(i);
    else ligne_droite(i);
}

module texte_2d()
    for (k = [0:len(actives) - 1])
        translate([0, y_ligne(k)]) ligne(actives[k]);

module contour_2d()
    offset(r = -lissage) offset(r = lissage + largeur_contour) texte_2d();

module chiffre_2d()
    if (len(chiffre) > 0)
        translate([decalage_chiffre_x, decalage_chiffre_y])
            text(chiffre, size = taille_chiffre, font = police_chiffre,
                 halign = "center", valign = "center");

module socle() {
    linear_extrude(epaisseur_contour) contour_2d();
    if (len(chiffre) > 0) linear_extrude(epaisseur_fond) chiffre_2d();
}

module texte() {
    translate([0, 0, epaisseur_contour - 0.01])
        linear_extrude(relief_texte + 0.01) texte_2d();
}

if (partie == "socle") socle();
else if (partie == "texte") texte();
else {
    color(couleur_socle) socle();
    color(couleur_texte) texte();
}
