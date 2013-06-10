

noIPasaran

Service web vérifiant l'intégrité des serveurs DNS

 

 

Rapport de l'épreuve intégrée
=============================

 

 

Section Bachelier en Informatique

 

 

 

 

EPFC

Avenue Charles Thielemans, 2

1150 Woluwe-Saint-Pierre

 

Elève

Bernard DEBECKER

bernard.debecker@gmail.com

Promoteur

Olivier Nisole

olnisole@epfc.eu

 

Juin 2013

Remerciements
=============

 

Je remercie Olivier Nisole, mon promoteur, qui malgré son emploi du
temps chargé a toujours été disponible. Ses conseils avisés m'ont fait
progresser considérablement dans mon travail.

 

Et bien sûr, Alain Silovy pour avoir accepté mon sujet.

 

Je remercie l'inventeur de Node.js, Ryan Dahl. Son langage est
formidable et réellement passionnant.

 

C'est grâce à l'émission Tracks d'Arte que j'ai appris l'existence des
contre-cultures et de certains mouvements alternatifs. Cette vision
nouvelle a lentement fait germer l'idée de ce TFE dans mon esprit.

 

La sortie du film The Pirate Bay Away From Keyboard au début de cette
année m'a donnée un angle de vue différent sur ce procès très médiatisé
dans lequel s'affrontaient les majors et les fondateurs du site
d'échange de fichiers torrents, The Pirate Bay.

 

Des principes qui m'ont plu et que j'ai adopté, le Datalove. C'est une
philosophie qui prône l'amour de la communication, toute forme de
communication ; qui défend l'échange et l'accès à l'information, comme
un droit et surtout comme un besoin. Ou quand la liberté et l'intérêt
commun l'emportent sur le profit personnel. Ceci explique la liberté
totale d'utilisation, de redistribution ou même de ré-attribution de mon
travail.

 

 

 

Table des matières
==================

 

​1. Introduction                                                       
                                6

 

​2. But du projet           7

 

​3. Technologies et méthodes utilisées                                 
                      8

3.1. Côté serveur

1.  1.  1.  3.1.1. Node.js

3.1.2. Express

1.  3.1.2.1. Modèles et middlewares utilisés

    ​a) Connect-assets

    ​b) Node-mysql

​c) Request

​d) Marked

​e) Async

​f) Underscore

​g) MD5

​h) Node-toobusy

1.  3.1.3. CoffeeScript

    3.1.4. Jade

    3.1.5. Stylus

    3.2. Côté client

3.2.1 Bootstrap

3.2.2. Flat-UI

1.  1.  1.  3.2.3.jQuery 

            ​a) DataTables 

            ​b) Validate 

1.  1.  3.3.Hébergement 

1.   

    ​4. Résultats                                                       
                                            19

4.1. Architecture du serveur
----------------------------

1.  1.  1.  4.1.1.app 

            4.1.2. config 

            4.1.3. lib 

            ​a) check.coffee 

            ​b) db.coffee 

            ​c) distance.coffee 

            ​d) ip.coffee 

            ​e) staticmap.coffee 

            4.1.4. nodes\_modules 

            4.1.5. public 

            4.1.6. Autres fichiers 

            ​a) LICENCE 

            ​b) Procfile 

            ​c) README.md 

            ​d) package.json 

            ​e) server.js 

            4.2. Structure de la base de données 

            4.3. Cas d'utilisation 

            4.3.1. Test d'une URL 

            4.3.2. Routine de nettoyage de la base de données "sites" 

            4.3.3. Contributions des utilisateurs à la base de données
            "servers" 

             

            ​5. Problèmes rencontrés et conclusion                     
                                              29 

            5.1. Problèmes rencontrés 

            5.2. L'avenir du projet 

            5.2.1. Comparaison visuelle des résultats 

            5.2.2. Servir de proxy 

1.  1.  1.  5.2.3.Améliorer les performances des tests 

            5.3. Conclusion 

1.  1.  1.   

            ​6. Références           32

             

            ​7. Glossaire            34

1. Introduction
===============

 

Le 26 septembre 2011, la cour d'appel d'Anvers a rendu un arrêt donnant
à Telenet et à Belgacom, les plus importants fournisseurs d'accès à
Internet belge, 14 jours pour mettre en place un blocage DNS de 11
adresses associées au site The Pirate Bay sous peine d'astreinte.
Belgacom et Telenet se sont exécutés, les requêtes vers ces sites ont
aussitôt été redirigées vers un site informant du blocage.

 


 

Il existe donc une forme de censure sur Internet en Belgique. Il n'en
fallait pas plus pour attiser ma curiosité.

 

J'ai appris qu'il existait un grand nombre de sites internet bloqués en
Belgique répartis en quatre grandes familles :

-   •Les sites de vente de médicaments 

-   •Les sites de téléchargement illégaux (fortement discutable) 

-   •Les sites de vente d'objets contrefaits 

-   •Les sites de jeux non-autorisés (pour lesquels il existe une liste
    noire publique, 74 sites actuellement, sur le site de la Commission
    des jeux de hasard du SPF Justice) 

     

Je regrette qu'une liste noire complète des sites interdits ne soit pas
accessible au public.

La frontière entre la protection du consommateur et la censure est mince
et dépend, selon moi, essentiellement de la transparence de ses actions
et de la communication avec les citoyens.

Ne sommes-nous pas en droit de savoir quels sites précisément sont
interdits dans notre pays ? Pourquoi cette liste noire est-elle gardée
aussi farouchement ?

 

Bien sûr, à l'étranger, la situation est parfois bien pire. A COMPLETER

 

Dès lors, comment avoir confiance dans les serveurs DNS que les FAI
mettent à la disposition de leurs abonnés ? Comment vérifier que les FAI
ne font pas de l'excès de zèle dans le blocage ?

 

 

L'arrestation de Kim.com

 

2. But du projet
================

 

Le but du projet est de permettre à un utilisateur sans connaissance
approfondie en réseau ou en informatique en général de vérifier la
qualité des serveurs DNS proposés par son fournisseur d'accès à
Internet.

 

La vérification se fera soit par le biais d'une requête individuelle en
introduisant l'adresse d'un site internet à vérifier, soit en demandant
une vérification globale de l'intégrité de son fournisseur d'accès qui
fonctionnera sur base d'une liste de sites internet sensibles qui
s'affinera à l'utilisation.

 

Le service devant, par essence, être accessible à n'importe qui dans des
conditions pas toujours optimales (client d'un cybercafé, employé d'une
entreprise avec accès restreint), j'ai décidé que mon projet serait une
application web qui ne nécessite aucune installation ou extension de
navigateur Internet.

 

L'interface est volontairement simple et dépourvue de termes techniques
afin d'éviter de faire fuir un utilisateur non averti.

Les utilisateurs confirmés ne seront pas en reste, les détails du test
pouvant s'afficher sur demande.

 

3. Technologies et méthodes utilisées
=====================================

3.1. Côté serveur
-----------------

### 3.1.1. Node.js

 

Node.js est un framework événementiel créé pour développer des
applications réseau scalables en JavaScript, principalement des serveurs
web. Il repose sur la machine virtuelle V8 de Google.

 

Pour illustrer sa simplicité, voici un exemple de serveur HTTP renvoyant
un Hello world

 


 

Il est à constater qu'on travaille ici à un niveau assez bas. Il faut
donc définir soi-même le header de la réponse, signaler que la réponse
est finie, définir le contenu séparément du header.

C'est ici qu'Express entre en jeu.

 

Pour justifier l'utilisation de Node.js pour ce projet, je dois d'abord
défendre le choix de JavaScript.

Je vais le comparer à Java qui est également exécuté sur une machine
virtuelle.

 

Selon ce benchmark, Java est sans surprise plus rapide et plus gourmand
en mémoire que JavaScript V8.

 



 

JavaScript est effectivement plus lent que Java, malgré le formidable
moteur V8 développé par Google.

D'où l'intérêt de Node.js qui utilise un modèle orienté événement,
non-bloquant.

 

Pour illustrer cette différence entre les deux langages, je me permets
une parabole culinaire :

 

Albert et Simone ne se connaissent pas et vont, chacun dans leur
cuisine, préparer une tarte aux pommes pour leurs invités.

Albert représente Java et Simone, Node.js.

Mes deux protagonistes ne sont pas de grands chefs et vont donc
effectuer une seule opération à la fois durant toute la préparation du
goûter.

 

Albert procède de cette manière :

-   •Il épluche et coupe les pommes en tranches (5 minutes) 

-   •Il mélange les pommes avec le sucre et les épices (1 minutes) 

-   •Il étale la pâte qu'il a achetée toute faite dans un moule (1
    minute) 

-   •Il dispose les pommes sur la pâte (2 minutes) 

-   •Il fait préchauffer le four (10 minutes) 

-   •Il enfourne la tarte (1 minute) 

-   •Cuisson de la tarte (25 minutes) 

-   •La tarte sortie du four, il va mettre la table pour ses invités (10
    minutes) 

Au total, Albert a mis 55 minutes pour préparer son goûter.

 

Simone, avec son modèle non bloquant, procède de cette manière :

-   •Elle fait préchauffer le four (1 minute) 

-   •Elle épluche et coupe les pommes en tranches avec amour (10
    minutes) 

-   •Elle mélange les pommes avec le sucre et les épices (2 minutes) 

-   •Elle étale la pâte qu'elle a achetée toute faite dans un moule avec
    précaution (2 minutes) 

-   •Elle dispose les pommes sur la pâte avec minutie (4 minutes) 

-   •Le four est chaud, elle enfourne la tarte (1 minute) 

-   •Elle peut commencer à mettre la table en veillant à l'alignement
    parfait des assiettes (20 minutes) 

-   •Il lui reste 5 minutes avant la fin de la cuisson, elle prend un
    bon livre et se détend en attendant la tarte (5 minutes) 

Au total, Simone a mis 45 minutes pour préparer son goûter et a même eu
le temps de s'octroyer un moment de lecture.

 

En conclusion, Albert exécute plus vite les étapes, mais perd un temps
conséquent à attendre lors des étapes les plus longues.

 

Simone est plus lente à l'exécution, mais comme elle utilise un modèle
non-bloquant, elle peut passer à l'étape suivante pendant qu'Albert
attend bêtement que son four préchauffe.

 

Bien sûr, il s'agit un exemple grossier et exagéré dans un sens comme
dans l'autre. Mais il permet de comprendre une des différences
fondamentales entre Java et Node.js.

 

Pour être un peu plus technique, voici un petit Hello world permettant
d'illustrer le modèle non-bloquant.


 

Aussi étonnant que ça puisse paraître, le résultat en console sera bien
:

 

 hello

 world

Node.js ne permet pas de s'arrêter ou de tourner dans une boucle sans
rien faire d'autre.

 

Que fait alors le programme dans le Hello world ci-dessus, entre le
moment où il a affiché hello et le moment où il affichera world ?

Il idle, c'est-à-dire qu'il attend qu'on lui demande de faire quelque
chose.

Et comme il n'a plus rien à faire ensuite, le programme s'arrête.

 

Allons un petit peu plus loin encore avec le programme suivant :

 

 

Dans ce cas, le programme ne s'arrêtera pas de lui même car Node.js sait
lorsqu'il lui reste quelque chose à faire. Node.js conserve dont un
compteur de callback, et garde l'event loop actif tant qu'il y aura
encore quelque chose à faire.

 

Cette notion de callback mérite également d'être légèrement développée
car c'est une des particularités en Node.js pour pouvoir conserver son
caractère asynchrone.

 

Prenons cet exemple :

 


 

Qu'avons-nous ici ?

 

Une fonction executer qui reçoit deux paramètres. Un mot et un callback.
Le callback est une fonction qui sera appliquée sur le mot.

 

Lorsque j'appelle executer, je lui passe donc le mot 'Hello' et je lui
passe en second argument une fonction anonyme qui affichera en console
la valeur retournée.

 

Ce n'est qu'un petit aperçu de ce que permet un callback. La description
de l'exécution d'un test reprend cette notion en pratique dans le code
de l'application.

 

En plus de ce modèle particulier, Node.js repose sur le moteur
JavaScript V8 de Google. Initialement développé pour leur navigateur
Chrome, il apporte un fonctionnement innovant pour l'exécution de code
JavaScript.

L'intérêt de ce moteur repose sur la compilation du JavaScript en
langage machine à l'exécution. Le code compilé est optimisé
dynamiquement lors de celle-ci.

 

Je ne vais trop entrer dans les détails, je vous invite, si le sujet
vous intéresse, à aller visiter le site de V8 (v. Références).

 

Ce mode de fonctionnement répond parfaitement à mes besoins pour ce
projet car je dois effectuer de nombreuses requêtes sortantes vers des
serveurs DNS. Le temps de réponse de ceux-ci fluctuant, je ne peux pas
me permettre d'additionner linéairement les temps de réponse. Node.js me
permet d'envoyer successivement toutes les requêtes et de recevoir les
résultats au fur et à mesure, sans perdre de temps.

 

Ce projet aurait donc pu s'appeler Simone.

### 3.1.2. Express

 

Express est un framework très léger pour Node.js qui lui fournit un
panel de fonctionnalités pour construire des applications web. Il permet
l'utilisation de middleware. Les middlewares utilisés sont développés
ci-après.

 


 

Plus besoin de définir le header ou quoi que ce soit, express s'en
charge. Il est également intéressant d'observer qu'une notion de route
est abordée. En effet, app.get('/', (...)) définit la route que le
serveur prend en charge. Toute autre route ne renverra rien.

 

La notion de contrôleur comme on l'entend dans une application web en
Java n'existe pas en Node.js et Express. L'intégralité du code pourrait
s'écrire dans un seul fichier. Dans le cas de mon application, les
routes sont définies dans des fichiers séparés uniquement par volonté de
clarté dans la structure.

Il n'y a pas non plus de notion de MVC. La seule chose qui peut exister
réellement en Express est la notion de vue.

#### 3.1.2.1. Modules et middlewares utilisés

#### a) Connect-assets

Ce middleware permet de servir à l'exécution du serveur les fichiers
.coffee et .styl en .js et .css

Ceci évite la tâche redondante de compiler manuellement ces fichiers
avant l'exécution.

De plus, il permet d'accéder à ces fichiers compilés en utilisant le
raccourci :

 

#### 


 

#### b) Node-mysql

Ce module entièrement écrit en JavaScript est ce qu'il y a de plus
performant pour utiliser une base de données de type MySQL.

Son utilisation est très simple et ses possibilités très poussées. A
usage égal, il a été démontré qu'il peut être plus performant qu'un
module écrit en C pour effectuer le même travail. Pour les explications
complètes, je vous invite à regarder la présentation vidéo du module
faite par son créateur, Felix Geisendörfer (v. Références).

#### c) Request

Ce petit module permet de faire des requêtes HTTP de manière très
simple. Le module HTTP inclus dans Node.js permet de faire le même
travail, mais de façon un peu moins intuitive.

#### d) Marked

Ce module très performant permet de convertir un fichier Markdown en
code HTML.

Ce module est intégralement écrit en JavaScript.

#### e) Async

Ce module rajoute des fonctions d'exécution de code de façon asynchrone
à Node.js.

Il permet de contrôler précisément l'exécution de fonction en parallèle
par exemple ou d'exécuter une même fonction sur une collection en
parallèle et n'envoyer le callback qu'une fois toutes les opérations
effectuées.

#### f) Underscore

Underscore est un ensemble de fonction destiné à manipuler différent
type d'objet de façon très simple. Tel que grouper des tableaux,
concaténer des listes sur base de certain paramètres et autres fonctions
très utiles.

#### g) MD5

Permet de hasher facilement et simplement n'importe quoi en utilisant le
protocol MD5.

 


 

#### h) Node-toobusy

Ce petit module permet de vérifier si le temps passé par un opération
dans la file d'attente de tâches dans le serveur n'est pas supérieur à
une valeur donnée. Par défaut celle-ci est de 70 millisecondes.

 

1.  i)Native-dns 

     

    Ce module est indispensable pour mon application car la librairie
    inclue dans Node.js permettant d'effectuer des requêtes sur un
    serveur DNS ne permet quasiment aucun paramètrage. 

     

    Ce que me permet ce module est de faire une même requête sur
    différent serveurs, de calculer le temps de la requête ou encore de
    définir le temps de timeout.  

### 3.1.3. CoffeeScript

 

CoffeeScript est un langage de programmation qui se compile en
JavaScript. Sa valeur ajoutée sont les sucres syntaxiques inspirés de
Ruby, Python et Haskell. Ils lui permettent de rendre le code plus
lisible.

Un autre avantage de CoffeeScript est qu'il permet d'écrire en moyenne
1/3 de ligne en moins qu'un programme équivalent en JavaScript, tout en
n'ayant aucun effet négatif sur les performances, au contraire.

 

Par exemple, une classe JavaScript donne :


 

L'équivalent CoffeeScript est nettement plus clair et plus court :

 


 

Ou encore, une boucle for pour itérer dans une liste en JavaScript :

 


 

Cette même boucle en CoffeeScript :

 


 

Avec ceci, vient d'éventuels désavantages :

-   •.Le langage est très sensible aux espaces et à l'indentation 

-   •.Le compilateur n'est pas toujours très précis en cas d'erreur 

 

C'est finalement une question d'habitude.

 

Le Hello World Express en CoffeeScript :

 


 

### 3.4. Jade

 

Jade est un moteur de template HTML haute-performance développé
spécifiquement pour Node.js.

Il permet d'écrire des pages HTML sans balise.

 

Une simple page HTML telle que :

 


 

Peut s'écrire en Jade :

 


 

En plus de posséder une structure très légère, Jade permet également
d'exécuter du code sur base des valeurs qu'on transmet au template.

 

Pour illustrer ceci, un exemple pratique d'un template auquel je passe
une liste d'éléments :

 

layout.jade


 

itemview.jade

 


 

Que nous appelons en utilisant Express

 


 

Va produire le code HTML suivant :

 


 

Quelques explications s'imposent :

-   •.Jade supporte l'héritage de template. Un template peut donc en
    étendre un autre. 

-   •.Les attributs id="unId" et class="uneClasse" d'un élément
    s'écrivent respectivement \#unId et .uneClasse 

-   •.Les tags \<div\> sont optionnels et supposés lors de l'utilisation
    d'id ou de classe. On peut écrire, en reprenant l'exemple précédent,
    \#rowId.rowclass et obtenir un tag parfaitement formé \<div
    id="rowId" class="rowclass"\>\</div\> 

-   •.Les variables passées sont accessibles soit par l'utilisation de
    la balise \#{variable} ou directement après un tag p= variable 

### 3.5. Stylus

 

Stylus est au CSS ce que Jade est au HTML. Simple, intuitif et complet.
Il permet la rédaction de feuilles de style de façon très simple.

 

Pourquoi écrire :

 


 

Quand on peut se contenter de :

 


 

Le code Stylus est évidemment compilé en CSS par la suite.

 

3.2. Côté client
----------------

### 3.2.1. Bootstrap

 

Bootstrap est une collection d'outils front-end pour créer des design
templates simplement grâce aux fichiers CSS et JS qui le compose.

 

Je l'utilise principalement pour la structure des éléments et la
présentation des modals de modification de la partie admin.

 

### 3.2.2. Flat-UI

 

Cette librairie CSS repose sur la structure de Bootstrap, mais offre un
peu de gaité et d'originalité.

 

### 3.2.3. jQuery

 

Cette librairie JavaScript permet de manipuler les éléments du code HTML
d'un page. En plus d'être très puissante, elle est extrêmement légère.

 

Comme la décision a été prise de ne pas utiliser de JavaScript côté
client, l'utilisation en est faite principalement dans la partie admin
du site, pour facilité les modifications des informations contenues dans
la base de données.

 

#### a) DataTables

 

Ce plug-in jQuery permet de trier, filtrer et organiser facilement la
présentation de données sous forme de tableau.

 

#### b) Validate

 

Ce plugin de validation permet de valider côté client le contenu de
champs type input text sur base d'expression régulière. Cela me permet
de garder une base de données propres et correctement structurée sans
devoir effectuer ces tests côté serveur.

 

3.3. Hébergement
----------------

Le site a pour vocation d'être hébergé par Heroku. Si je n'avais pas ce
problème de module.

 

Heroku est un service de PaaS. Un des avantages d'Heroku par rapport à
un PaaS comme AppFog, est que le code ne doit pas être uploadé avec tous
les modules. Lors de la création d'une application, un dépot Git est
créé. Il suffit alors de pusher le code source sur le dépot. Une fois le
code chargé, le service détecte le type d'application avec le fichier
Procfile, règle l'environnement selon ce qui a été déclaré dans le
fichier package.json de l'application et télécharge automatiquement les
dépendances nécessaires.

 

Il est ensuite possible d'avoir accès aux logs de l'application, d'y
ajouter des add-on pour gérer le cache ou une base de données locale.

 

Durant le développement, j'ai testé plusieurs PaaS, dont Nodejitsu et
AppFog, je ne pouvais exporter la base de données à chaque fois. C'est
pour cette raison qu'elle est hébergée actuellement sur AlwaysData.

 

Il y a un point négatif à cela : le temps des requètes entre le serveur
et la base de données dépent de la rapidité de la connexion à internet à
la disposition du serveur.

 

Une fois l'application en production, la base de données sera migrée sur
ClearDB.

Lors du transfert vers MongoDB, elle sera hébergée sur MongoLab.

 

4. Résultats
============

4.1. Architecture du serveur
----------------------------

La structure du serveur est générée par Skeleton.

 


 

### 4.1.1. app

-   •.app.coffee : c'est ici que la configuration du framework Express
    est faite. 

[commenter app.coffee et coller le code ici]

-   •.assets : le dossier assets contient les fichiers Stylus et
    CoffeeScript qui seront compilés en mémoire RAM pour être utilisé
    par le client. 

-   •.controllers : c'est ici que les fichiers contrôleurs se trouvent.
    Deux contrôleurs sont définis : admincontroller et maincontroller.
    Cette division à principalement pour but d'offrir plus de clarté et
    de lisibilité. Le contrôleur n'en est pas vraiment un, c'est
    simplement un ensemble de fonction qui fait le lien entre ce que
    requière une route comme données et d'autres classes permettant
    d'accéder à ces données. 

-   •.helpers : helpers.coffee est un fichier généré par Skeleton
    permettant à celui-ci d'effectuer un chargement automatique des
    contrôleurs et des classes lors du démarrage du serveur. 

-   •.routes : c'est au sein du fichier index.coffee du dossier routes
    que les requètes sont distribuées aux contrôleurs. La politique de
    sécurité d'accès aux pages est également gérée au sein de ce
    fichier. 

-   •.views : les vues sont pages HTML, écrites ici en Jade. 

-   •.config : le fichier boot.coffee contient les instructions de
    chargement automatique lors du démarrage du serveur. 

-   •.lib : ce dossier contient les différentes classes qui sont
    utilisées au sein du serveur. 

-   •.package.json : ce fichier contient différentes informations
    contenant le projet. Son nom, sa version, ses dépendances (les
    modules qu'il utilise), ainsi que des informations sur le fichier à
    exécuter pour lancer le serveur. 

-   •.server.coffee : le fichier qui est appellé lors du lancement du
    serveur. Ici, il ne fait que charger le compilateur CoffeeScript et
    charger le fichier app.coffee qui va paramétrer et démarrer le
    serveur. 

### 4.1.2. config

Le dossier config ne contient qu'un seul fichier, boot.coffee. Il
permet, lorsqu'il est chargé dans app.coffee, de charger automatiquement
le contenu des dossiers lib et controllers.

### 4.1.3. lib

Lib contient les classes utilisées dans l'application.

#### a) check.coffee

[A rajouter]

#### b) db.coffee

Le fichier db est une pseudo classe de DAO. Il n'y a en effet pas de
modèle déclaré dans l'application. Cette classe sera à terme refactorée
en une vrai classe de DAO à l'aide de MongoDB et Mongoose qui permet de
déclarer des modèles et de simplifier leurs manipulations dans la base
de données.

Ce fichier n'est donc composé que de différentes fonctions permettant
d'insérer, modifier, récupérer ou supprimer des informations dans la
base de données.

#### c) distance.coffee

Distance est une petite classe pour calculer la distance réelle entre
deux coordonnées géographique à vol d'oiseaux, en tenant compte de la
courbure de la terre. Elle permet de fournir à titre indicatif la
distance entre un serveur DNS et la position d'un utilisateur.

#### d) ip.coffee

La classe la plus importante du projet. Elle contient toutes les
fonctions nécessaires à la manipulation, la recherche d'information
basée sur les URL et les adresses IP.

#### e) staticmap.coffee

Cette classe est utilisée pour générer l'URL d'une carte Google Maps
Static.

### 4.1.4. nodes\_modules

C'est ici que sont installés les modules déclarés dans le fichier
package.json

### 4.1.5. public

Ce dossier contient les fichiers qui n'ont pas besoin d'être compilés,
tels les images, fichier CSS ou JS provenant de sources externes.

### 4.1.6. Autres fichiers

#### a) LICENCE

Le texte de licence devient un indispensable et fait souvent couler
beaucoup d'encre sur Internet. J'ai pour ma part opté pour la plus libre
d'entre toutes, la WTFPL.

#### b) Procfile

Fichier spécifique à l'utilisation d'Heroku comme hébergeur. Il permet
de déclarer le type d'application qui est déployée.

#### c) README.md

 

Le fichier README, incontournable, c'est le fichier de présentation qui
est visible sur les dépôts de code. Il est rédigé en markdown.

#### d) package.json

Ce fichier permet de déclarer le nom et les dépendances de
l'application. Les dépendances sont téléchargées sur NPM, le packet
manager de Node.js. Ce fichier permet de préciser la version de Node.js
ou d'un module à utiliser.

#### e) server.js

Le fichier primaire du serveur. C'est lui qui est appelé lors du
chargement du serveur, tel que déclaré dans le fichier package.json.

Il ne contient que deux informations : déclarer explicitement que
l'exécution nécessite le compilateur CoffeeScript et que le reste du
code se trouve dans le fichier app.coffee.

 

4.2. Structure de la base de données
------------------------------------

 

La base de données se compose de 3 tables.

 


 

Comme on peut aisément le constater, ce modèle n'est absolument pas
relationnel. C'est pour ça qu'il est aisément concevable et réalisable
de passer à une base de données noSQL rapidement.

 

dns\_servers contient les serveurs DNS enregistrés.

 

Sa structure est la suivante :

 

- name: le nom des serveurs DNS, du service qui les emploient ou du
fournisseur d'accès à Internet auquel ils appartiennent.

- primary\_ip et secondary\_ip: les adresses IP des deux serveurs.

- location: Global si les serveurs ne sont pas lié à un FAI, le pays du
FAI dans le cas contraire.

- is\_isp : Un booléen signalant si les serveurs appartiennent à un FAI

- date : Le timestamp d'insertion du serveur DNS dans la base de donnée.

- valid : Un booléen indiquant si le serveur est validé, c'est à dire
qu'il peut être utilisé pour effectuer des tests dessus.

 

sites contient les sites qui ont été soumis aux tests. Les sites ayant
connu une différence de résultat entre les serveurs DNS sûr et les
autres. Les autres sites sont supprimés au bout de 24 heures.

 

Structure :

 

- url: l'URL du site sous sa forme www.example.com.

- ip: l'IP la plus probable du site selon les serveurs DNS sûrs.
Celle-ci est vérifiée toutes les 24 heures pour les sites persistants

- hash : le code HTML de la page obtenue en effectuant une requête HTTP
sur cette URL, hashé en MD5

- haz\_problem : un booléen indiquant si le site a connu des problèmes.
Permet d'assurer sa persistance dans la base de données.

- date : le timestamp de dernière utilisation du site. Si le site n'a
pas été demandé depuis 24h et qu'il ne connait pas de problème, il est
supprimé lors du nettoyage quotidien.

 

users est uniquement utilisée pour l'accès à la partie admin du site.

 

- username: le nom d'utilisateur

- password: le mot de passe hashé en MD5.

 

4.3. Cas d'utilisations
-----------------------

### 4.3.1. Test d'une URL

Dans la page index du site se trouve un input text. Le contenu de ce
champ, lorsque l'utilisateur clique sur le bouton 'Go', est passé en
POST à l'url /query.

 

 example.com

 

La requête arrive alors au sein du fichier routes/index.coffee qui
contient les différentes routes.

 


 

L'application, app, reçoit donc une méthode de type POST adressée à
/query, et elle appelle la méthode query du maincontroller.

 


 

Cette méthode query reçoit en paramètre la requête et la réponse qui
servira de callback.

La valeur de la requète, c'est-à-dire le contenu de l'input est extraite
du corps de la requète dans la variable queryStr. La valeur de cette
variable est ensuite testée afin de déterminer si c'est une adresse IP,
une possible URL, déterminée ici simplement s'il y a un point dans le
texte, ou un contenu autre.

Le cas qui nous intéresse ici est si la valeur est une URL. Le callback
est alors utilisé pour établir une redirection vers /url/queryStr

Retour par les routes, et cette fois-ci, c'est la route /url/:url qui
est donc utilisée.

 


 

La notation ':url' permet de récupérer la valeur située après "/url/"
dans les paramètres de la requète.

La méthode url du maincontroller est appelée.

 

[SCREEN A VENIR]

 

L'URL est donc récupérée dans les paramètres. Elle est ensuite formatée
pour être sous la forme :

 

        [www.example.com](http://www.example.com/)

 

C'est ensuite la méthode getIpAndData auquel est passée la requète,
nécessaire pour récupérer l'IP du client, ainsi que l'url précédemment
récupérée.

 


 

Dans getIpAndData les opérations suivantes sont effectuées :

 

Je vérifie si le site est présent dans la base de données. Le cas
échéant, les données du site sont récupérées. Dans le cas contraire,
l'URL est soumise aux serveurs DNS sûrs pour récupérer l'IP qui lui est
relative.

 

La première action va être de récupérer la ou les IP sur une sélection
de serveurs DNS sûrs.

Les serveurs choisis pour cette tâche sont :

-   •.Google Public DNS 

-   •.Level3 

-   •.censurfridns.dk 

-   •.SmartViper 

[DETAIL DE POURQUOI EUX]

 

Les détails de ces serveurs DNS récupérés dans la base de données sont
passés à la fonction resolveGlobalServers. Pour chaque serveur, c'est la
serveur treatGlobalServer qui est appellée. Le résultat resolved
retourné en callback est ajouté à la variable result, un tableau de
String via une union. En effet, une union de deux ensemble est
l'ensemble qui contient tous les éléments qui appartiennent au premier
OU au deuxième. La variable result contient bien toujours une seule fois
le même résultat.

 


 

Pour chaque fournisseur, l'URL est résolue sur les deux serveurs de
façon parallèle.

Une fois les deux résultats de retour, la réponse est renvoyée en
callback.

 


 

La fonction resolve est la fonction de plus bas niveau de l'application.

Je construis tout d'abord une variable question qui contient le type de
requête à faire sur le serveur DNS.

La requête req est ensuite construite sur base de la question, de l'IP
du serveur sur lequel la requête va être faite et le timeout. Ici, le
délai réglé à 1000 millisecondes. La plupart des serveurs répondent en
moins de 300 millisecondes, il n'est pas nécessaire d'attendre plus
qu'une seconde pour déclarer un serveur en timeout. Cette valeur
pourrait être abaissée afin d'optimiser le temps des requêtes.

 

Ce qui est déclaré ensuite sont les actions a effectuer en fonction de
l'état de la requête.

 

Si elle timeout, la réponse l'indiquera.

S'il y a un message, chaque adresse IP est rajoutée à la liste
d'adresses de la réponse.

Lors de la réception du message de fin, c'est le temps de réponse qui
est calculé et passé à la réponse.

 

La requête est alors envoyée.

 

Cette fonction illustre parfaitement le modèle asynchrone de Node.js. On
ne sait pas ce qui sera effectué, ni quand, donc on prévoit et on envoie
le résultat en callback quand c'est fini.


 

S'il devait y avoir des IP contradictoires dans les résultats obtenus,
chaque IP est appellée à l'aide d'une requète http pour obtenir le
contenu HTML de la page. Ce contenu est hashé à l'aide de l'algorithme
MD5. Le résultat de ce hashage est alors comparé. Si deux IP produisent
le même résultat, la probabilité est grande que ces deux adresses IP
appartiennent bien au même site.

Le résultat obtenu est alors enregistré dans la base de données et les
données du site enregistrés sont alors renvoyé pour la continuité du
test.

 

En même temps, l'IP du client est récupérée sur base de sa requête. Pour
cela, deux possibilités :

-   •.Récupération du header de la requète X-Forwarded-For (XFF) 

-   •.Récupération de la remoteAddress dans les paramètres de connexion
    de la requète. 

 

Dans le cas où la requète vers le serveur est passée par un proxy pour
l'atteindre, le header de la requète sera modifié en fonction et
structuré de la façon suivante :

 

 X-Forwarded-For: IP client, IP proxy 1, IP proxy 2

 

Cette information est malgré tout à prendre avec prudence car le header
peut être modifié par le client. Malgré cela, c'est tout de même la
source principale d'IP cliente qui sera retenue.

S'il ne devait pas y avoir de header, c'est la remote address de la
connexion qui sera retenue.


 

L'IP récupérée va servir à tenter d'obtenir le fournisseur d'accès à
Internet de l'utilisateur (FAI).

Il s'agit d'effectuer une requête de type Reverse DNS sur l'IP obtenue.
La méthode utilisée n'est pas sûre à 100%. Il est en effet possible que
l'IP possède un canonical name autre que celui fourni par le fournisseur
d'accès à Internet en utilisant un service comme DynDns.

 


 

Exemple de résultat pour une requête Reverse DNS sur l'IP 81.247.34.211

 

 211.34-247-81.adsl-dyn.isp.belgacom.be

 

Si cette méthode ne donne pas de résultat, ou que l'ISP de l'utilisateur
n'est pas présent dans la base de données, c'est le pays duquel émane
cette IP qui sera retenu.

Dans un cas comme dans l'autre, le ou les serveurs DNS correspondants
sont récupérés dans la base de données.

 

Le callback de cette méthode, data, contient les données qui seront
affichées dans la page de résultat.

Ces données sont structurés comme suit :

 


 

Détaillons ceci :

-   •.'site' est l'objet récupéré dans la base de données. L'adresse IP
    qu'il contient est celle renvoyée par les serveurs sûrs. Le hash est
    la valeur hashée du code HTML récupéré sur base de cette adresse
    IP. 

-   •.'clientip' est l'adresse IP du client. 

-   •.'local' contient les résultats des serveurs dit locaux. Si, comme
    dans cet exemple, le fournisseur d'accès Internet du client a pu
    être récupéré, il n'y a qu'un résultat. Celui-ci contient un
    boolean, 'valid', résultat du test comparatif entre le résultat de
    ce serveur et le résultat des serveurs sûrs. Les valeurs de 'name',
    'primary\_ip' et 'secondary\_ip' sont récupérées de la base de
    données et passées au client pour information. Les résultats
    'primary\_results' et 'secondary\_result' contiennent la ou les
    adresses IP renvoyée par ce serveur et le temps prit par ce serveur
    pour répondre (en millisecondes). 

### 4.3.2. Routine de nettoyage de la base de données "sites"

Toutes les jours, une routine de nettoyage de la base de données "sites"
est effectuée.

Celle-ci à pour but principal de ne pas surcharger cette base de
données, compte tenu de la rapidité effective pour récupérer les
informations qu'elle contient.

Tout site ne posant pas problème et n'ayant pas été consulté durant la
journée est supprimé de la base de données.

Par contre, un site posant problème restera de façon indéfinie dans la
base de données. Lors de cette routine, l'exactitude de l'adresse IP
stockée est vérifiée et le hash du code HTML est regénéré.

 

[SCREEN A VENIR]

 

Le nettoyage s'effectue à heure fixe tous les jours. Pour éviter de
perturber l'activité du site, j'utilise un module appelé "toobusy". Ce
module permet d'éviter d'effectuer ce nettoyage, potentiellement lourd
en requète entrante et sortante, lorsqu'il y a un grand nombre de
requète client. Pour cela, il observe le retard qu'a la file
d'évènement. Si ce retard est plus grand que 70 millisecondes, le
nettoyage est reporté de 5 minutes.

 

En fonction des performances du serveur, cette valeur peut être abaissée
ou augmentée pour coller au mieux avec la disponibilité souhaitée pour
le service.

 

Il est également possible d'effectuer ce nettoyage manuellement depuis
la partie Admin.

### 4.3.3. Contributions des utilisateurs à la base de données "servers"

Les utilisateurs ont la possibilités de soumettre un serveur DNS qui
serait inconnu.

La page Help a été créée pour cela.

Le format des adresses IP est vérifié côté client avant la soumission du
formulaire.

Le pays est tapé en utilisant un typeahead au lieu d'un menu déroulant.

Une fois le formulaire completé et la soumission faite, côté serveur,
l'existence du serveur et vérifiée sur base de adresses IP.

Si le serveur est existant, l'utilisateur en est averti.

Dans le cas contraire, le serveur est inséré dans la base de données et
l'utilisateur est remercié.

 

Les serveurs insérés par les utilisateurs peuvent être modifié, activé
ou supprimé dans la partie Admin.

5. Problèmes rencontrés et conclusion
=====================================

5.1. Problèmes rencontrés
-------------------------

J'ai commencé ce projet alors que je débutais à peine Node.js et je
n'avais jamais fais de JavaScript. J'ai suivi quelques tutoriaux et ça
m'a amené à prendre de mauvaises habitudes. Les tutoriaux que j'ai suivi
oubliaient tous un point important : la structure. Ce qui m'a ammené
assez vite à un code horrible et inmaintenable.

C'est là que j'ai décidé de reprendre la structure depuis le début avec
l'aide de Skeleton.

J'ai également rencontré des problèmes avec la base de données. J'avais
débuté avec une base de données noSQL de type MongoDB. De nouveau, étant
novice en la matière, c'était le foutoir. Pour gagner du temps, je me
suis retourné vers une technologie avec lequel j'ai plus d'expérience,
le SQL. Maintenant que l'application est en place, et compte tenu du
fait que ma base de données n'est absolument pas relationnelle, je pense
retourner vers MongoDB le plus rapidement possible.

Les problèmes structurels passés et le développement réellement
commencé, le plus gros obstacle que j'ai rencontré, et que je rencontre
toujours, ne s'explique toujours pas.

Pour pouvoir effectuer des requètes à un serveur DNS précis sans devoir
gérer moi-même l'ouverture d'un socket UDP, d'envoyer un buffer sur le
port 53 au serveur DNS puis d'en attendre la réponse et la déchiffrer,
j'ai trouvé un module pour Node qui permet de faire ces requètes
facilement. En effet, la librairie de Node ne permet pas pour le moment
d'effectuer ce type de requête paramétrable. Cela pourrait venir dans un
futur proche vu que le développeur du module en question travaille
maintenant pour Joyent, la société auquel appartient Node.js.

Le module qui me permet d'effectuer ces requètes donc s'appelle
native-dns. Pour utiliser un module dans Node, il faut l'importer.

 

 dns = require 'native-dns'

 

Au démarrage du serveur, l'application est créée, les différents
fichiers et modules importés. Sous Windows, aucun problème, le serveur
se lance correctement et effectue parfaitement ce que je lui demande de
faire avec ce module.

Sous Linux par contre, impossible de démarrer le serveur, une erreur se
produit dans un sous module de "node-dns".

Développer sous Windows n'étant pas un problème en soi, c'est ce que je
continue de faire. Le problème réel est pour l'hébergement du serveur.
En effet, Heroku, AppFog, Nodejitsu sont autant de PaaS sous Linux. Donc
impossible de lancer le serveur hosté. Malédiction.

5.2. L'avenir du projet
-----------------------

Ce projet est en effet voué à perdurer. Même si la neutralité du net
devait devenir un acqui au niveau mondial, rêvons grand, il ne faut pas
pour autant vivre au pays des bisounours. Internet reste un outil
complexe, manipulable de façon parfois très aisée. Il faut donc toujours
partir sur un principe de précaution.

Que va devenir ce projet par la suite ?

Une fois le problème lié au module native-dns, il sera mis en ligne,
enfin. Le retour d'une base de données MongoDB devrait avoir également
avoir lieu.

Il y a également des fonctionnalités que je n'ai pas eu le temps
d'implémenter qui sont néanmoins intéressantes à détailler de façon
théorique.

### 5.2.1. Comparaison visuelle des résultats

Imaginons qu'un utilisateur, Marcel, veuille se rendre sur un site
Internet possiblement censuré dans son pays.

Marcel se rend donc sur le site du projet pour effectuer le test sur
base de l'url. Le service lui répond qu'il y a une différence, et qu'il
ne doit pas se fier au serveur DNS de son FAI parce que les résultats
des IP et des hashages d'HTML sont différents. Super.

Mais Marcel ne sait pas ce qu'est une adresse IP et encore moins le
hashage de code HTML. Problème.

En voulant aider Marcel, je l'embrouille avec du jargon. Ce n'est pas ce
que je veux. Je voudrais que Marcel puisse observer la différence entre
les deux résultats. En utilisant deux iframe par exemple.

Le premier fait un rendu du site sur base de l'URL de base, le second
sur base de l'IP renvoyée.

Pas de problème si le FAI de Marcel ne fait que du blocage DNS, par
contre si celui-ci fait également du blocage IP, un problème se pose
avec le rendu du site basé sur l'IP.

### 5.2.2. Servir de proxy

Une fonctionnalité qui devra être rajoutée est la possibilité pour un
utilisateur bloqué est de lui proposer de se rendre sur le site qu'il
désire en se servant de mon serveur comme proxy. Il faudra néanmoins se
poser à ce sujet les questions de légalité inhérente à cette
fonctionnalité.

 

### 5.2.3. Améliorer les performances des tests

 

Une étape importante est le temps d'exécution des tests afin de
minimiser le temps de réponse pour le client. En utilisant le module
async, je vais pouvoir mieux contrôler l'exécution des fonctions lentes
afin que l'attente du callback ne soit pas bloquant pour l'envoi de la
réponse.

 

Le choix de ne pas avoir de JavaScript côté client pour le test est un
choix qui n'aide pas pour les performances. En effet, une fois que
l'utilisateur à soumis un URL à test, il ne voit rien d'autre qu'une
page blanche en attendant le résultat du test si celui-ci devait durer.
A terme, ce qui est envisageable, c'est de proposer aux clients dont le
JavaScript est activé une interface plus dynamique.

 

Le test une fois lancé, le client serait directement redirigé vers la
page de résultat, mais le contenu de celle-ci serait ajouté au fur et à
mesure que le serveur progresse dans les tests. Ceci est assez facile en
utilisant jQuery et en demandant au serveur d'envoyer chaque résultat,
même partiel, en JSON au client.

5.3. Conclusion
---------------

6. Références
=============

 

-   •Arte Tracks Les hackers urbains partent à l'abordage des villes 

    [http://www.arte.tv/fr/les-hackers-urbains-partent-a-l-abordage-des-villes/6909544,CmC=6909554.html](http://www.arte.tv/fr/les-hackers-urbains-partent-a-l-abordage-des-villes/6909544,CmC=6909554.html) 

-   •The Pirate Bay Away From Keyboard 

     [http://watch.tpbafk.tv/](http://watch.tpbafk.tv/) 

-   •Datalove 

    [http://datalove.me/](http://datalove.me/) 

-   •SPF Justice Commission des jeux de hasard Liste noire des sites de
    jeux illégaux
    [http://www.gamingcommission.be/opencms/opencms/jhksweb\_fr/gamingcommission/news/news\_0001.html](http://www.gamingcommission.be/opencms/opencms/jhksweb_fr/gamingcommission/news/news_0001.html) 

-   •RTBF Médias La liste noire des sites web bloqués mise en cause  

    [http://www.rtbf.be/info/medias/detail\_la-liste-noire-des-sites-web-bloques-mise-en-cause?id=8001587](http://www.rtbf.be/info/medias/detail_la-liste-noire-des-sites-web-bloques-mise-en-cause?id=8001587) 

-   •Node.js 

    [http://nodejs.org/](http://nodejs.org/) 

-   •Wikipédia Node.js 

    [http://fr.wikipedia.org/wiki/Node.js](http://fr.wikipedia.org/wiki/Node.js) 

-   •Benchmark JavaScript V8 vs. Java 7 

    [http://benchmarksgame.alioth.debian.org/u32/javascript.php](http://benchmarksgame.alioth.debian.org/u32/javascript.php) 

-   •V8 JavaScript Engine 

    [http://code.google.com/p/v8/](http://code.google.com/p/v8/) 

-   •Express 

    [http://expressjs.com/](http://expressjs.com/) 

-   •Connect-assets 

    [https://github.com/adunkman/connect-assets](https://github.com/adunkman/connect-assets) 

-   •Node-mysql 

    [https://github.com/felixge/node-mysql](https://github.com/felixge/node-mysql) 

-   •YouTube Felix Geisendörfer: Faster than C? Parsing Node.js Streams!
     

    [http://youtu.be/Kdwwvps4J9A](http://youtu.be/Kdwwvps4J9A) 

-   •Request 

    [https://github.com/mikeal/request](https://github.com/mikeal/request) 

-   •Marked 

    [https://github.com/chjj/marked](https://github.com/chjj/marked) 

-   •Async 

    [https://github.com/caolan/async](https://github.com/caolan/async) 

-   •Underscore 

    [http://underscorejs.org](http://underscorejs.org/) 

-   •MD5 

    [https://github.com/pvorb/node-md5](https://github.com/pvorb/node-md5) 

-   •Node-toobusy 

    [https://github.com/lloyd/node-toobusy](https://github.com/lloyd/node-toobusy) 

-   •CoffeeScript 

        [http://coffeescript.org](http://coffeescript.org/)

 

-   •Jade 

        [http://jade-lang.com](http://jade-lang.com/)

-   •Stylus 

    [http://learnboost.github.io/stylus](http://learnboost.github.io/stylus/) 

-   •Bootstrap 

    [http://twitter.github.io/bootstrap](http://twitter.github.io/bootstrap/) 

-   •Flat-UI 

    [http://designmodo.github.io/Flat-UI](http://designmodo.github.io/Flat-UI/) 

-   •jQuery 

    [http://jquery.com](http://jquery.com/) 

-   •DataTables 

    [http://www.datatables.net](http://www.datatables.net/) 

-   •Validate 

    [https://github.com/engageinteractive/validate](https://github.com/engageinteractive/validate) 

-   •Heroku 

    [https://www.heroku.com](https://www.heroku.com/) 

-   •AlwaysData 

    [https://www.alwaysdata.com](https://www.alwaysdata.com/) 

-   •MySQL 

    [http://www.mysql.fr](http://www.mysql.fr/) 

-   •ClearDB 

    [http://www.cleardb.com](http://www.cleardb.com/) 

-   •MongoDB 

    [http://www.mongodb.org](http://www.mongodb.org/) 

-   •MongoLab 

    [https://mongolab.com](https://mongolab.com/) 

 

7. Glossaire
============

 

The Pirate Bay : Site créé en Suède en 2003 permettant l'échange de
fichiers torrents. Il est l'un des plus gros sites internet

 

Scalabilité :

 

Benchmark :

 

Middleware :

 
