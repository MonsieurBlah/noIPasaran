# noIPasaran

## 1. Pourquoi ?

Le 26 semptembre 2011, la cour d'appel d'Anvers a rendu un arrêt donnant à Telenet et à Belgacom, les plus importants fournisseurs d'accès à Internet belge, 14 jours pour mettre en place un blocage DNS de 11 addresses (URL) associées au site The Pirate Bay sous plein d'astreinte. 
Belgacom et Telenet se sont alors exécutés, les requètes étant alors redirigée vers un site informant du blocage

[insert screenshot here]

Il n'a fallu alors que quelques mois à Belgacom, voyant que certains de ses abonnés contournaient le blocage DNS en utilisant d'autres serveurs que les leurs, pour bloquer pûrement et simplement toutes requêtes vers le site. Or, aucun arrêt n'a été rendu pour ce faire, cette décision est propre à Belgacom. Depuis, Belgacom refuse de communiquer sur le sujet.

Dès lors, comment avoir confiance dans les serveurs DNS que les FAI mettent à la disposition de leurs abonnés ? Comment vérifier que les FAI ne font pas de l'excès de zèle dans le blocage ?

C'est ici que l'idée est née : permettre à un utilisateur lambda, n'ayant pas de connaissance particulière en réseau ou en informatique en générale, de vérifier la qualité des services auquel il souscrit ?

## 2. Comment ?

Une fois l'idée germée, il a fallu réfléchir à comment offrir ce service. Un programme à installer ? Une extension pour le navigateur Internet ?

Le but étant de permettre à quiconque d'utiliser ce service, ces deux solutions ne sont pas envisageable. Pour pouvoir installer un programme ou une extension demande des droits assez élevé sur un ordinateur. Or, le client d'un cybercafé ou l'employé d'une entreprise ne possède souvent ces droits.

C'est donc assez naturellement que le choix s'est tourné vers une application web. De cette manière n'importe qui ayant un accès à Internet pourrait utiliser le service.
Pour aller plus loin, et permettre au maximum de monde d'utiliser le service, le choix a été fait de ne pas utiliser de JavaScript côté client pour les fonctionnalités principales du service.

Que permet donc ce service ?

La fonction principale est donc de proposer à l'utilisateur d'entrer une URL et de soumettre cette URL à vérifications.

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

[JSON DONNEES]


## 3. Avec quoi ?

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

- controllers : c'est ici que les fichiers contrôleurs se trouvent. Deux contrôleurs sont définis : admincontroller et maincontroller. Cette division à principalement pour but d'offrir plus de clarté et de lisibilité. Le rôle du contrôleur n'est ici pas le même qu'un contrôleur en Java. En Java, la fonction du contrôleur est double : 

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
			response.end('Hello, world\n');
	 	}
	).listen(8000);
 
	console.log('Server running at http://localhost:8000/');

### 2. CoffeeScript

CoffeeScript est un langage de programmation qui se compile en JavaScript. Le langage a comme valeur ajoutée par rapport à ce dernier des sucres syntaxiques inspirés de Ruby, Python et Haskell qui lui permette de rendre le code plus lisible et succin.

Un autre avantage de Coffee est qu'il permet d'écrire en moyenne 1/3 de ligne en moins qu'un programme équivalent en JavaScript, tout en n'ayant aucun effet négatif sur les performances.

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

### 3. Express.js

Express.js est un framework pour Node.js

### 6. Jade

Jade est un moteur de template HTML haute-performance développé spécifiquement pour Node.js.

Il permet d'écrire des pages HTML sans balise et permet d'exécuter du code sur base d'élément passé au template.

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

###	7. Stylus
###	8. Bootstrap
