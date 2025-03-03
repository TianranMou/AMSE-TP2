TP2 - Jeu de Taquin en Flutter 

Introduction 

Ce projet consiste à réaliser un jeu de Taquin en utilisant Flutter. Avant d’implémenter le jeu final, nous avons réalisé plusieurs exercices pour construire progressivement ses différentes fonctionnalités.


Auteurs：

 	•	Tianran MOU
 	•	Ruying Ji


 Fonctionnalités：

🔹 Exo 1 : Affichage d’une Image
	•	Utilisation du widget Image.network() pour afficher une image aléatoire de Picsum.
	•	Adaptation automatique à la taille de l’écran.

🔹 Exo 2 : Transformation d’une Image
	•	Ajout de sliders pour appliquer :
	•	Rotation X et Z
	•	Mise à l’échelle (zoom)
	•	Effet miroir
	•	Possibilité d’activer une animation automatique.

🔹 Exo 3 : Menu de Navigation
	•	Création d’un menu pour naviguer entre les exercices via ListView, Card et ListTile.
	•	Utilisation de Navigator.push() pour la navigation entre les pages.

🔹 Exo 4 : Affichage d’une Tuile d’Image
	•	Découpe d’une portion d’image grâce à ClipRect + Align.
	•	Comparaison avec l’image originale.
	•	Effet cliquable sur la tuile.

🔹 Exo 5 : Génération du Plateau de Tuiles
	•	Utilisation de GridView pour afficher une grille fixe de tuiles.
	•	Chaque tuile représente une portion de l’image.

🔹 Exo 6 : Animation des Tuiles
	•	Implémentation d’un effet de glissement entre deux tuiles.
	•	Permutation dynamique des tuiles.

🔹 Exo 7 : Jeu de Taquin
	•	Jeu final avec :
	•	Choix de la difficulté (nombre de déplacements)
	•	Sélection de l’image (par défaut ou depuis Internet)
	•	Compteur de déplacements
	•	Détection automatique de la victoire
	•	Possibilité d’annuler un déplacement

    Installation & Exécution

    1️⃣ Cloner le projet
    git clone https://github.com/TianranMou/AMSE-TP2.git
    cd tp2_app

    2️⃣ Installer les dépendances
    flutter pub get

    3️⃣ Lancer l’application
    flutter run  ou  flutter run -d chrome

Licence

Ce projet est sous licence IMT Nord Europe.
