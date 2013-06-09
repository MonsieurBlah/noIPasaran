# noIPasaran

## 1. Pourquoi ?

Le 26 semptembre 2011, la cour d'appel d'Anvers a rendu un arrêt donnant à Telenet et à Belgacom, les plus importants fournisseurs d'accès à Internet belge, 14 jours pour mettre en place un blocage DNS de 11 addresses (URL) associées au site The Pirate Bay sous plein d'astreinte. 
Belgacom et Telenet se sont alors exécutés, les requètes étant alors redirigée vers un site informant du blocage

[insert screenshot here]

Il n'a fallu alors que quelques mois à Belgacom, voyant que certains de ses abonnés contournaient le blocage DNS en utilisant d'autres serveurs que les leurs, pour bloquer pûrement et simplement toutes requêtes vers le site. Or, aucun arrêt n'a été rendu pour ce faire, cette décision est propre à Belgacom. Depuis, Belgacom refuse de communiquer sur le sujet.

La Belgique autorise donc la censure sur Internet. Il n'en fallait pas plus pour suciter ma curiosité.

Ma curiosité m'a appris qu'il n'y a pas moins de ? sites Internet bloqués en Belgique depuis l'instauration d'une liste noire en 2009, et ce répartit en quatres grandes familles : 

+ Les sites de vente de médicaments (vrai ou faux)
+ Les sites de téléchargement 'illégaux' (tel que feu Megaupload)
+ Les sites de vente d'objets contrefaits
+ Les sites de jeux non-authorisés (environ 75 sites)

[Loppsi 2 en France, SOPA/PIPA aux Etat-Unis]

Mais aussi des Pays comme la Belgique, le Royaume-Uni (bloquage cas par cas)

[Parler de la Chine, Egypte durant printemps Arabe, ...]



Dès lors, comment avoir confiance dans les serveurs DNS que les FAI mettent à la disposition de leurs abonnés ? Comment vérifier que les FAI ne font pas de l'excès de zèle dans le blocage ?

C'est ici que l'idée est née : permettre à un utilisateur lambda, n'ayant pas de connaissance particulière en réseau ou en informatique en générale, de vérifier la qualité des services auquel il souscrit ?

## 2. Comment ?

Une fois l'idée germée, il a fallu réfléchir à comment offrir ce service. Un programme à installer ? Une extension pour le navigateur Internet ?

Le but étant de permettre à quiconque d'utiliser ce service, ces deux solutions ne sont pas envisageable. Pour pouvoir installer un programme ou une extension demande des droits assez élevé sur un ordinateur. Or, le client d'un cybercafé ou l'employé d'une entreprise ne possède souvent pas ces droits.

C'est donc assez naturellement que le choix s'est tourné vers une application web. De cette manière n'importe qui ayant un accès à Internet pourrait utiliser le service.

Pour aller plus loin, et permettre au maximum de monde d'utiliser le service, le choix a été fait de ne pas utiliser de JavaScript côté client pour les fonctionnalités principales du service.

Faire un site Internet pour informer de la censure comporte un risque : être censuré. Pour palier à ce risque, le serveur est voué à être distribué gratuitement. 

L'idéal serait que les versions distribuées utilisents une seule et même base de données pour une meilleure pertinence des résultats obtenus. Pour ceux qui désireraient crééer leur propre base de données, le script d'insertion de données sera joint au code du serveur.


Que permet donc ce service ?

La fonction principale est donc de proposer à l'utilisateur d'entrer une URL et de soumettre cette URL à vérifications.

Il peut aussi demander des informations générales sur les serveurs DNS de son FAI ou de son pays.

Cas d'utilisation 

### 1. Test d'une URL inconnue.

Lorsqu'une URL n'est pas encore présente dans la base de données, la première action va être de récupérer la ou les IP sur une sélection de serveurs DNS sûrs.

Les serveurs choisis pour cette tâche sont :

+ Google Public DNS
+ Level3
+ censurfridns.dk
+ SmartViper

[DETAIL DE POURQUOI EUX]

L'URL est alors résolue sur les deux (principaux) serveurs de ces fournisseurs.

S'il devait y avoir des IP contradictoires dans les résultats obtenus, chaque IP est appellée à l'aide d'une requète http pour obtenir le contenu HTML de la page. Ce contenu est hashé à l'aide de l'algorithme MD5. Le résultat de ce hashage est alors comparé. Si deux IP produisent le même résultat, la probabilité est grande que ces deux IPs appartiennent bien au même site.

Le résultat obtenu est alors enregistré dans la base de données et les données du site enregistrés sont alors renvoyé pour la continuité du test.

En même temps, l'IP du client est récupérée sur base de sa requête.
Pour cela, deux possibilités :

+ Récupération du header de la requète X-Forwarded-For (XFF)
+ Récupération de la remoteAddress dans les paramètres de connexion de la requète.

Dans le cas où la requète vers le serveur est passée par un proxy pour l'atteindre, le header de la requète sera modifié en fonction et structuré de la façon suivante :

	X-Forwarded-For: IP client, IP proxy 1, IP proxy 2.

Cette information est malgré tout à prendre avec prudence car le header peut être modifié par le client. Malgré cela, c'est tout de même la source principale d'IP cliente qui sera retenue.

S'il ne devait pas y avoir de header, c'est la remote address de la connexion qui sera retenue.

L'IP récupérée va servir à tenter d'obtenir le fournisseur d'accès à Internet de l'utilisateur (FAI).

Il s'agit d'effectuer une requête de type Reverse DNS sur l'IP obtenue.
La méthode utilisée n'est pas sûre à 100%. Il est en effet possible que l'IP possède un canonical name autre que celui fourni par le fournisseur d'accès à Internet en utilisant un service comme DynDns.

Exemple de résultat pour une requète Reverse DNS sur l'IP 81.247.34.211
	
	211.34-247-81.adsl-dyn.isp.belgacom.be

Si cette méthode ne donne pas de résultat, ou que l'ISP de l'utilisateur n'est pas présent dans la base de données, c'est le pays duquel émane cette IP qui sera retenu.

Dans un cas comme dans l'autre, le ou les serveurs DNS correspondants sont récupérés dans la base de données.

De nouveau, l'URL est de nouveau résolue sur chacun des serveurs DNS.

Les résultats obtenus sont comparés avec le lot d'IP fournies par les serveurs sûrs.

En cas de discordance, une requète HTTP est de nouveau effectuée sur l'IP problèmatique, le contenu hashé et comparé.

Une fois ces tests effectués, le résultat est passé à la vue et l'utilisateur peut alors en prendre connaissance.

### 2. Test d'une URL connue.

Lorsqu'une URL est connue dans la base de données, le processus de test est simplifié vu qu'il ne faut que récupérer le site et le comparer au test du serveur DNS lié au client.

En pratique, comment est traitée une requète ?

Dans la page index du site se trouve un input text. Le contenu de ce champ, lorsque l'utilisateur clique sur le bouton 'Go', est passé en POST à l'url /query.

La requète arrive alors au sein du fichier index.coffee qui contient les différentes routes. 

	app.post '/query', app.maincontroller.query

L'application, app, reçoit donc une méthode de type POST addressée à /query, et elle appelle la méthode query du maincontroller.

	@query = (req, res) ->
		queryStr = req.body.query
		# Check if the query is an IP or an URL
		app.ip.isIp queryStr, (isIp) ->
			if isIp
				res.redirect "/ip/#{queryStr}"
			else
				# Check if there is a . means it could be a URL
				dot = queryStr.split('.').length - 1
				if dot
					res.redirect "/url/#{queryStr}"
				else
					res.redirect "/404/#{queryStr}"

Cette méthode query reçoit en paramètre la requète et la réponse qui servira de callback.

La valeur de la requète, c'est-à-dire le contenu de l'input est extraite du corps de la requète dans la variable queryStr. 
La valeur de cette variable est ensuite testée afin de déterminer si c'est une adresse IP, une possible URL, déterminée ici simplement s'il y a un point dans le texte, ou un contenu autre.

Le cas qui nous intéresse ici est si la valeur est une URL. Le callback est alors utilisé pour établir une redirection vers /url/queryStr

Retour par les routes, et cette fois-ci, c'est la route /url/:url qui est donc utilisée.

	app.get '/url/:url', app.maincontroller.url

La notation ':url' permet de récupérer la valeur située après "/url/" dans les paramètres de la requète.

La méthode url du maincontroller est appelée.

	@url = (req, res) ->
		# Get the url
		url = req.params.url
		# If no www. and only one . in the url
		# ADD THE CLEANING AFTER THE FIRST /
		url = "www.#{url}" if url.indexOf 'www.', 0 < 0 and url.split('.').length - 1 < 2
		app.ip.getIpAndData req, url, (data) ->
			res.render 'url', view: 'url', title: "#{url}", url: url, ip: data.site.ip, clientip: data.clientip, country: ata.country, resultlocal: data.local 

L'url est donc récupérée dans les paramètres. Elle est ensuite formatée pour être sous la forme :

	www.example.com

C'est ensuite la méthode getIpAndData auquel est passée la requète, nécessaire pour récupérer l'IP du client, ainsi que l'url précédemment récupérée. Le callback de cette méthode, data, contient les données qui seront affichées dans la page de résultat.

Ces données sont structurés comme suit :

{ site: {	site_id: 1,
				 	url: 'www.example.com',
				 	ip: ['192.168.0.1'],
				 	hash: '78e731027d8fd50ed642340b7c9a63b3',
				  haz_problem: 0,
					date: Tue May 21 2013 18:46:50 GMT+0200 (Romance Daylight Time)},
	clientip: '127.0.0.1',
	local: [ { 	valid: true,
							name: 'ExampleDnsServer',
							primary_ip: '195.238.2.21',
							secondary_ip: '195.268.2.22',
							primary_result: [{addresses: ['192.168.0.1'], time: '30'}],
							secondary_result: [{addresses: ['192.168.0.1'], time: '27'}]
							}]}

Détaillons ceci :

+ 'site' est l'objet récupéré dans la base de données. L'adresse IP qu'il contient est celle renvoyée par les serveurs sûrs. Le hash est la valeur hashée du code HTML récupéré sur base de cette adresse IP.
+ 'clientip' est l'adresse IP du client.
+ 'local' contient les résultats des serveurs dit locaux. Si, comme dans cet exemple, le fournisseur d'accès Internet du client a pu être récupéré, il n'y a qu'un résultat. Celui-ci contient un boolean, 'valid', résultat du test comparatif entre le résultat de ce serveur et le résultat des serveurs sûrs. Les valeurs de 'name', 'primary_ip' et 'secondary_ip' sont récupérées de la base de données et passées au client pour information. Les résultats 'primary_results' et 'secondary_result' contiennent la ou les adresses IP renvoyée par ce serveur et le temps prit par ce serveur pour répondre (en millisecondes).


### 2. Routine de nettoyage de la base de données "sites"

Toutes les jours, une routine de nettoyage de la base de données "sites" est effectuée.

Celle-ci à pour but principal de ne pas surcharger cette base de données, compte tenu de la rapidité effective pour récupérer les informations qu'elle contient.

Tout site ne posant pas problème et n'ayant pas été consulté durant la journée est supprimé de la base de données.

Par contre, un site posant problème restera de façon indéfinie dans la base de données.


### 3. Contributions des utilisateurs à la base de données "servers"

Les utilisateurs ont la possibilités de soumettre un serveur DNS qui serait inconnu.

La page Help a été créée pour cela. 

Le format des adresses IP est vérifié côté client avant la soumission du formulaire.

Le pays est tapé en utilisant un typeahead au lieu d'un menu déroulant.

Une fois le formulaire completé et la soumission faite, côté serveur, l'existence du serveur et vérifiée sur base de adresses IP.

Si le serveur est existant, l'utilisateur en est averti.

Dans le cas contraire, le serveur est inséré dans la base de données et l'utilisateur est remercié.

## 4. Problèmes rencontrés

J'ai commencé ce projet alors que je débutais à peine Node.js et je n'avais jamais fais de JavaScript. J'ai suivi quelques tutoriaux et ça m'a amené à prendre de mauvaises habitudes. Les tutoriaux que j'ai suivi oubliaient tous un point important : la structure. Ce qui m'a ammené assez vite à un code horrible et inmaintenable.

C'est là que j'ai décidé de reprendre la structure depuis le début avec l'aide de Skeleton.

J'ai également rencontré des problèmes avec la base de données. J'avais débuté avec une base de données noSQL de type MongoDB. De nouveau, étant novice en la matière, c'était le foutoir. Pour gagner du temps, je me suis retourné vers une technologie avec lequel j'ai plus d'expérience, le SQL. Maintenant que l'application est en place, et compte tenu du fait que ma base de données n'est absolument pas relationnelle, je pense retourner vers MongoDB le plus rapidement possible.

Les problèmes structurels passés et le développement réellement commencé, le plus gros obstacle que j'ai rencontré, et que je rencontre toujours, ne s'explique toujours pas.

Pour pouvoir effectuer des requètes à un serveur DNS précis sans devoir gérer moi-même l'ouverture d'un socket UDP, d'envoyer un buffer sur le port 53 au serveur DNS puis d'en attendre la réponse et la déchiffrer, j'ai trouvé un module pour Node qui permet de faire ces requètes facilement. En effet, la librairie de Node ne permet pas pour le moment d'effectuer ce type de requête paramétrable. Cela pourrait venir dans un futur proche vu que le développeur du module en question travaille maintenant pour Joyent, la société auquel appartient Node.js.

Le module qui me permet d'effectuer ces requètes donc s'appelle node-dns (ou native-dns dans NPM).
Pour utiliser un module dans Node, il faut l'importer. 

	dns = require 'native-dns'

Au démarrage du serveur, l'application est créée, les différents fichiers et modules importés. 
Sous Windows, aucun problème, le serveur se lance correctement et effectue parfaitement ce que je lui demande de faire avec ce module.

Sous Linux par contre, impossible de démarrer le serveur, une erreur se produit dans un sous module de "node-dns".

Développer sous Windows n'étant pas un problème en soi, c'est ce que je continue de faire. Le problème réel est pour l'hébergement du serveur. En effet, Heroku, AppFog, Nodejitsu sont autant de PaaS sous Linux. Donc impossible de lancer le serveur hosté. Malédiction.

## 5. Et ensuite ?

Ce projet est en effet voué à perdurer. Même si la neutralité du net devait devenir un acqui au niveau mondial, rêvons grand, il ne faut pas pour autant vivre au pays des bisounours. Internet reste un outil complexe, manipulable de façon parfois très aisée. Il faut donc toujours partir sur un principe de précaution.

Que va devenir ce projet par la suite ?

Une fois le problème lié au module 'native-dns', il sera mis en ligne, enfin.
Le retour d'une base de données MongoDB devrait avoir également avoir lieu.

Il y a également des fonctionnalités que je n'ai pas eu le temps d'implémenter qui sont néanmoins intéressantes à détailler de façon théorique.

### 5.1 Comparaison visuelle des résultats.

Imaginons qu'un utilisateur, Marcel, veuille se rendre sur un site Internet possiblement censuré dans son pays.

Marcel se rend donc sur le site du projet pour effectuer le test sur base de l'url. Le service lui répond qu'il y a une différence, et qu'il ne doit pas se fier au serveur DNS de son FAI parce que les résultats des IP et des hashages d'HTML sont différents. Super.

Mais Marcel ne sait pas ce qu'est une adresse IP et encore moins le hashage de code HTML. Problème.

En voulant aider Marcel, je l'embrouille avec du jargon. Ce n'est pas ce que je veux. Je voudrais que Marcel puisse observer la différence entre les deux résultats. En utilisant deux iframe par exemple.

Le premier fait un rendu du site sur base de l'URL de base, le second sur base de l'IP renvoyée.

Pas de problème si le FAI de Marcel ne fait que du blocage DNS, par contre si celui-ci fait également du blocage IP, un problème se pose avec le rendu du site basé sur l'IP.

### 5.2 Servir de proxy

[test à faire avant d'en parler]

## 3. Avec quoi ?

Pourquoi Node.js ?

Afin de pouvoir explique pourquoi Node.js, je dois commencer par justifier JavaScript.

Afin de le comparer à un autre langage exécuté sur machine virtuelle, je vais prendre Java comme langage de comparaison.

A en croire ce [benchmark](http://benchmarksgame.alioth.debian.org/u32/javascript.php), Java a tendance à être majoritairement plus rapide en exécution mais légèrement plus gourmand en mémoire que JavaScript. 

JavaScript est donc plus lent que Java, malgré le formidable moteur V8 développé par Google, ce n'est pas une nouvelle.

C'est ici que Node.js entre en jeu.

Une des caractéristiques de Node.js, est que cet ensemble de librairie utilise un modèle orienté évènement, non-bloquant.

Pour illustrer la chose, je me permets une analogie. Je prends donc un homme, Albert et une femme, Simone. Albert représente Java et Simone Node.js. Je sais que les femmes savent faire plusieurs choses à la fois, mais pas Simone. Mes deux protagonistes n'effectuent qu'une opération à la fois.

Albert et Simone vont chacun préparer une tarte au pommes pour un goûter qu'ils organisent chacun chez eux.

Voyons comment Albert s'y prend :

- Il commence par épelucher et couper ses pommes en tranche. (5 minutes)
- Il étale sa pâte toute faite dans son moule. (2 minutes)
- Il dispose les pommes sur la pâte. (2 minutes)
- Il fait préchauffer le four. (10 minutes)
- Une fois le four chaud, il enfourne la tarte. (1 minute)
- Cuisson de la tarte. Une fois cuite, il la sort du four. (25 minutes)
- Il peut maintenant mettre la table pour ses invités. (10 minutes)

Au total, Albert a mis 55 minutes pour préparer son goûter.

Maintenant, comment Simone et son modèle non bloquant va-t-elle si prendre ?

- Elle met le four à préchauffer (1 minute)
- Elle épeluche et coupe ses pommes en tranche avec amour. (10 minutes)
- Elle étale sa pâte toute faite dans son moule avec minutie. (4 minutes)
- Elle dispose les pommes sur la pâte avec attention. (4 minutes)
- Le four est chaud, elle enfourne la tarte. (1 minute)
- Elle met la table pour ses invités en veillant à l'alignement parfait des assiettes. (20 minutes)
- Il lui reste 15 minutes avant de la fin de la cuisson... Elle prend un bon livre et lit durant le temps restant. (5 minutes)

Au total, Simone a mis 45 minutes pour préparer son goûter et a même eu le temps de lire son livre.

Que conclure de ces deux façons de faire ?

Albert exécute plus vite les étapes, mais perd énormément de temps à attendre lors de les étapes longue vu qu'il ne peut rien faire d'autre.

Simone est plus lente à l'exécution, mais comme elle utilise un modèle non-bloquant, elle peut effectuer d'autres étapes de la préparation quand Albert attend bêtement devant son four.

Bien sur, cette analogie est grossière et exagérée, dans un sens comme dans l'autre. Mais elle permet de comprendre une des différences fondamentales entre Java et Node.js

Pour être un peu plus technique, voici un petit "Hello world" permettant d'illustrer le modèle non bloquant.

	setTimeout(function(){
		console.log("world");
	}, 2000);

	console.log("hello")

Aussi étonnant que ça puisse paraître de prime abord, le résultat en console sera bien :

	hello
	world

Node.js ne permet jamais de s'arrêter ou de tourner dans une boucle sans rien faire d'autre.

Que fait donc le programme dans le "Hello world" ci-dessus, entre le moment où il a affiché "hello" et le moment où il affichera "world" ?

Il "idle", il attend qu'on lui demande de faire quelque chose.

- "Ok Bernard, super, c'est génial dans le principe, mais JavaScript s'exécute plus lentement vu que c'est un langage interpreté."

Oui... Et non. Oui, parce que JavaScript est en effet un langage interpreté. Mais non, parce que j'utilise ici JavaScript sur Node.js. Et Node.js repose sur le moteur JavaScript V8 de Google.

- "Ok Bernard, donc là tu vas dire que parce que c'est Google, c'est mieux."

Bah oui, mais pas parce que c'est Google, parce que Google a eu une bonne idée : "Et si on compilait le JavaScript en langage machine avant de l'exécuter ?" Le code compilé est en plus optimisé et réoptimisé dynamiquement à l'exécution. Mais je ne vais pas rentrer trop dans les détails.


Pourquoi ai-je besoin de ce modèle de fonctionnement pour ce projet ?

Comme je dois effectuer un nombre important de requètes sortantes vers des serveurs DNS qui peuvent aussi bien répondre en moins de 100 millisecondes mais aussi ne pas répondre du tout et donc renvoyer un timeout (après 1000 millisecondes dans mon cas), je ne peux pas me permettre de faire une boucle traditionnelle où les temps de réponses des différents serveurs s'additionne. Ce que me permet Node, c'est d'envoyer successivement toutes les requètes, et de recevoir les résultats au fur et à mesure. Sans perdre de temps à ne rien faire.

Ce projet aurait donc pu s'appeler Simone.

### 3.1 Architecture du serveur

La structure du serveur est générée par [Skeleton][skeleton].

	noIPasaran
	├─┬ app
	│ ├── app.coffee
	│ ├─┬ assets
	│ │ ├─┬ css
	│ │ │ └── styles.styl
	│ │ └─┬ js
	│ │   └── scripts.coffee
	│ ├─┬ controllers
	│ │ └── controllers.coffee
	│ ├─┬ helpers
	│ │ └── index.coffee
	│ ├─┬ routes
	│ │ └── index.coffee
	│ └─┬ views
	│   ├── 404.jade
	│   ├── index.jade
	│   └── layout.jade
	├─┬ config
	│ └── boot.coffee
	├─┬ lib
	│ └─┬ myapp
	│   └── my_custom_class.coffee
	├── package.json
	├── Procfile
	├── public
	├── README.md
	└── server.coffee

#### 3.1.2 app

- app.coffee : c'est ici que la configuration du framework Express est faite.

[commenter app.coffee et coller le code ici]

- assets : le dossier assets contient les fichiers Stylus et CoffeeScript qui seront compilés en mémoire RAM pour être utilisé par le client.

- controllers : c'est ici que les fichiers contrôleurs se trouvent. Deux contrôleurs sont définis : admincontroller et maincontroller. Cette division à principalement pour but d'offrir plus de clarté et de lisibilité. Le contrôleur n'en est pas vraiment un, c'est simplement un ensemble de fonction qui fait le lien entre ce que requière une route comme données et d'autres classes permettant d'accéder à ces données.

- helpers : helpers.coffee est un fichier généré par Skeleton permettant à celui-ci d'effectuer un chargement automatique des contrôleurs et des classes lors du démarrage du serveur.

- routes : c'est au sein du fichier index.coffee du dossier routes que les requètes sont distribuées aux contrôleurs. La politique de sécurité d'accès aux pages est également gérée au sein de ce fichier.

- views : les vues sont pages HTML, écrites ici en Jade.

- config : le fichier boot.coffee contient les instructions de chargement automatique lors du démarrage du serveur.

- lib : ce dossier contient les différentes classes qui sont utilisées au sein du serveur.

- package.json : ce fichier contient différentes informations contenant le projet. Son nom, sa version, ses dépendances (les modules qu'il utilise), ainsi que des informations sur le fichier à exécuter pour lancer le serveur.

- server.coffee : le fichier qui est appellé lors du lancement du serveur. Ici, il ne fait que charger le compilateur CoffeeScript et charger le fichier app.coffee qui va paramétrer et démarrer le serveur.



### 1. Node.js

Node.js est système logiciel créé pour développer des applications Internet scalable, principalement des serveurs webs. Les programmes sont écrits en JavaScript, et utilisent une architecture orientée évènements et asynchrone. Node.js permet également d'écrire une application entièrement en JavaScript, tant côté client que côté serveur.

Pour illustrer sa simplicité, voici un exemple de serveur HTTP renvoyant un "Hello world"

	var http = require('http');
 
	http.createServer(
		function (request, response) {
			response.writeHead(200, {'Content-Type': 'text/plain'});
			response.end('Hello world\n');
	 	}
	).listen(8000);
 
	console.log('Server running at http://localhost:8000/');

	Il est à constater qu'on travaille ici à un niveau assez bas. Il faut donc définir soi-même le Header de la réponse, signaler que la réponse est finie, définir le contenu séparément du header.
	C'est ici qu'Express entre en jeu.


### 2. Express.js

Express.js est un framework très léger pour Node.js qui lui fourni une légère surcouche pour construire des applications web. Ce framework permet l'utilisation de middleware. Les middlewares utilisés sont développés ci-après.

	var express = require('express')
		,	app = express.createServer();

	app.get('/', function(req, res) {
		res.send('Hello world');
	});

	app.listen(3000);

	Ici donc, plus besoin de définir le header ou quoi que ce soit, express s'en charge. Il est également intéressant d'observer qu'une notion de route est abordée. En effet, app.get('/', (...)) défini la route que le serveur prend en charge. Toute autre route ne renvera rien.

	La notion de controleur comme on l'entend dans une application web en Java n'existe pas en Node/Express. L'intégralité du code pourrait s'écrire dans un seul fichier. Dans le cas de mon application, les routes sont définies dans des fichiers séparés uniquement par volonté de clarté dans la structure.

	Il n'y a pas de notion de MVC en Node/Express. La seul chose qui peut exister réellement en Express et la notion de vue.

### 3. CoffeeScript

CoffeeScript est un langage de programmation qui se compile en JavaScript. Le langage a comme valeur ajoutée par rapport à ce dernier des sucres syntaxiques inspirés de Ruby, Python et Haskell qui lui permette de rendre le code plus lisible et succin.

Un autre avantage de Coffee est qu'il permet d'écrire en moyenne 1/3 de ligne en moins qu'un programme équivalent en JavaScript, tout en n'ayant aucun effet négatif sur les performances, au contraire.

Par exemple, une classe JavaScript donne :

	var MaClasse = (function() {
		function MaClass() {
			alert('Constructeur')
		}

		MaClasse.prototype.faitQQChose = function() {
			alert('fait quelque chose')
		};

		return MaClasse;
	})();

	c = new MaClasse();
	c.faitQQChose();

L'équivalent Coffe est nettement plus clair et plus court :

	class MaClasse
		constructeur: ->
			alert 'constructeur'

		faitQQChose: ->
			alert 'fait quelque chose'

		c = new MaClasse()
		c.faitQQChose()

Ou encore, une boucle 'for' pour itérer dans une liste en JavaScript :

	for (var i = 0; i < list.length; i++) {
		var item = list[i];
		process(item)
	}

	Donnera en Coffee : 

	for item in list
		process item

Mais avec ceci, vient également d'éventuels désavantages : 

+ Le langage est très sensible aux espaces et à l'indentation.
+ Le compilateur n'est pas toujours très précis en cas d'erreur.

Pour continuer avec le même exemple :

	express = require 'express'
	app = express.createServer()

	app.get '/', (req, res) ->
		res.send 'Hello world'

	app.listen 3000


### 4. Jade

Jade est un moteur de template HTML haute-performance développé spécifiquement pour Node.js.

Il permet d'écrire des pages HTML sans balise.

Une simple page HTML tel que
		
	<!DOCTYPE html>
		<html>
			<head>
				<title>
					Exemple de HTML
				</title>
			</head>
			<body>
				Ceci est une phrase avec un <a href="cible.html">hyperlien</a>.
				<p>
					Ceci est un paragraphe
				</p>
			</body>
		</html>

Peut s'écrire en Jade :

	!!!5
		html
			head
				title Exemple de HTML
			body
				Ceci est une phrase avec un
					a(href="cible.html") hyperlien
				p Ceci est un paragraphe

En plus de posséder une structure très légère, Jade permet également d'exécuter du code sur base des valeurs qu'on passe au template.

[Intro de cet exemple]

layout.jade

	!!!5
			html
				head
					title #{title} | Exemple
				body
					block content

itemview.jade

	extends layout

	block content
		#rowid.rowclass
			ul.list
				each item in items
					li= item.name

Que nous appelons en utilisant Express

	res.render 'itemview', view: 'itemwiew', title: 'Ceci est un', items: {{name: "Jean"},{name:"Marc"}}

Va produire le code HTML suivant :

	<!DOCTYPE html>
		<html>
			<head>
				<title>
					Ceci est un | Exemple
				</title>
			</head>
			<body>
				<div id="rowid" class="rowclass">
					<ul>
						<li>Jean</li>
						<li>Marc</li>
					</ul>
				</div>
			</body>
		</html>

Quelques explications s'imposent:

- Jade supporte l'héritage de template. Un template peut donc en étendre un autre.
- Les attributs id="unId" et class="uneClasse" d'un éléments se s'écrivent respectivement #unId et .uneClasse
- Les tag <div> sont optionnels et supposés lors de l'utilisation d'id ou de classe. On peut écrire par exemple, en reprennant l'exemple précédent, #rowId.rowclass et obtenir un tag parfaitement formé <div id="rowid" class="rowclass"></div>
- Les variables passées sont accessibles soit par l'utilisation de la balise #{variable} ou directement après un tag, p= variable.

###	5. Stylus

Stylus est au CSS ce que Jade est au HTML. Simple, intuitif et complet.
Il permet la rédaction de feuilles de style de façon très simple.

Pourquoi écrire : 

	body {
  	font: 12px Helvetica, Arial, sans-serif;
	}
	a.button {
 	 	-webkit-border-radius: 5px;
  	-moz-border-radius: 5px;
  	border-radius: 5px;
	}

Quand on peut se contenter de :

	border-radius()
	  -webkit-border-radius arguments
	  -moz-border-radius arguments
	  border-radius arguments
  
	body
	  font 12px Helvetica, Arial, sans-serif
  
	a.button
	  border-radius 5px

Le code Stylus est évidemment compilé en CSS par la suite.

### 6. Modules et middlewares utilisés

#### 6.1 Connect-assets

Ce middleware permet de servir à l'exécution du serveur les fichiers .coffee et .styl en .js et .css

Ceci évite la tâche redondante de compiler manuellement ces fichiers avant l'exécution.

De plus, il permet d'accéder à ces fichiers compilés en utilisant le raccourci :

	!= css('nomdufichiercss')

ou

	!= js('nomdufichierjs')

#### 6.2 mysql

Ce module entièrement écrit en JavaScript est ce qu'il y a de plus performant pour utiliser une base de données de type MySQL.

Son utilisation est très simple mais ses possibilités sont très poussées. A usage égal, il a été démontré qu'il peut être plus performant qu'un module écrit en C pour effectuer le même travail. Pour les explications complètes, je vous invite à regarder la présentation du module faite par Felix Geisendörfer, créateur de ce module, en vidéo : [Faster than C? Parsing Node.js Streams!](http://youtu.be/Kdwwvps4J9A)

#### 6.3 request

Ce petit module permet de faire des requètes HTTP de manière très simple. Le module HTTP inclus dans Node.js permet bien sûr de faire le même travail, mais de façon un peu moins intuitive.

#### 6.4 marked

Ce module très perfomant permet de convertir un fichier Markdown en code HTML.

Ce module est également intégralement écrit en JavaScript.

#### 6.5 async

Ce module rajoute des fonctions d'exécution de code de façon asynchrone à Node.js.

#### 6.6 underscore

Blah

#### 6.7 MD5

Permet de hasher facilement et simplement n'importe quoi en utilisant le protocol MD5.

	console.log md5 'message'

	>> "78e731027d8fd50ed642340b7c9a63b3"
