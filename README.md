# NGS_Practicals_scRNA

05/11/2019 Mise en place de l'environnement de travail: connexion à l'IFB, création d'un git repo, test du téléchargment des données avec le script script_fastqdump.bash.

Infos utiles: 
- Clés de téléchargement des données: SRX5584534;SRX5584533

Commandes utiles:
git add * -> ajouter les fichiers au repo
git commit -m "message" -> quand on veut ajouter un commit
git push -> mise à jour
Aussi: https://confluence.atlassian.com/bitbucketserver/basic-git-commands-776639767.html

06/11/2019
Téléchargement des données génomiques de souris (génome + annotation des transcrits) afin d'y mapper nos transcrits ainsi que de les quantifier.
(Fonctions wget -> permet de télécharger un fichier directement depuis le terminak avec le lien
Fonction gunzip -> permet de dézipper les gzips)
Pour cela nous utilisons l'outil salmon qui permet de créer un index, de mapper les transcrits ainsi que de les quantifier. 
Tout d'abord nous devons construire l'index. L'index est un dictionnaire de "mots" (k-mer, dont on choisit arbitrairement le k) que l'on peut retrouver dans les séquences de transcrits.
Une fois l'index construit à partir des données d'annotations du génome (transcrits),
on peut maintenant utiliser l'outil alevin de salmon. Cet index permet d'inférer à quel gène/transcrit correspond nos reads.
Alevin va procéder au mapping ainsi qu'à la quantification des transcrits de nos échantillon. Nouvelle méthode hyper efficace et qui est plus rapide que tout le monde.
(Fonctions utiles: salmon index pour l'indexage
                   salmon alevin pour le mapping et la quantification
                   
examples: salmon index -t Fichier_RefTranscrits_Sequence.txt -i Fichier_Output -k int(taille du kmer = 31 conventionnellement)

        salmon alevin -l ISR -1 Fichiers_CB_UMI.fq -2 Fichiers_Reads.fq --chromium (technique de séquençage)  -i Dossier_Index -p Nombre_de_Coeurs_A_Utiliser -o Fichier_output --tgMap Fichier_RefTranscrits_NomsGenes

voir: https://salmon.readthedocs.io/en/latest/index.html

Plus -> Utilisation d'un peu de awk afin de produire les fichiers associant référence des transcrits à sa séquence, et référence des transcrits aux gènes correspondant.
        