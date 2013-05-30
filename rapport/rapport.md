# noIPasaran

## 1. Pourquoi ?

Le 26 semptembre 2011, la cour d'appel d'Anvers a rendu un arrêt donnant à Telenet et à Belgacom, les plus importants fournisseurs d'accès à Internet belge, 14 jours pour mettre en place un blocage DNS de 11 addresses (URL) associées au site The Pirate Bay sous plein d'astreinte. 
Belgacom et Telenet se sont alors exécutés, les requètes étant alors redirigée vers un site informant du blocage

[insert screenshot here]

Il n'a fallu alors que quelques mois à Belgacom, voyant que certains de ses abonnés contournaient le blocage DNS en utilisant d'autres serveurs que les leurs, pour bloquer pûrement et simplement toutes requêtes vers le site. Or, aucun arrêt n'a été rendu pour ce faire, cette décision est propre à Belgacom. Depuis, Belgacom refuse de communiquer sur le sujet.

Dès lors, comment avoir confiance dans les serveurs DNS que les FAI mettent à la disposition de leurs abonnés ? Comment vérifier que les FAI ne font pas de l'excès de zèle dans le blocage ?

C'est ici que l'idée est née : permettre à un utilisateur lambda, n'ayant pas de connaissance particulière en réseau ou en informatique en générale, de vérifier la qualité des services auquel il souscrit ?

## 2. Comment ?

Pour comprendre comment effectuer les tests nécessaires à cette vérification, il faut tout d'abord comprendre comment fonctionne la résolution d'une URL et ce qu'est une URL.

### 1. Qu'est-ce qu'une URL ?

Une URL, Uniform Resource Locator ou adresse réticulaire, est ce qu'on appelle communément une adresse web. C'est une chaîne de caractères utilisée pour adresser les ressources du World Wide Web : page HTML, image, son, etc. Cette URL permet d'indiquer à un programme comment accéder à cette ressource. Elle peut comprendre le protocole de communication, un numéro de port TCP/IP, un nom de dommaine ou autres.

Dans mon cas, je n'utilise que des noms de domaines tel

	www.uneadresse.be

Cette adresse peut-être scindée en plusieurs partie :

+ www: sous-domaine.
+ uneadresse: nom de domaine de deuxième niveau.
+ com: nom de domaine de premier niveau.

Je reviendrai sur ces dénominations et leurs utilités un petit peu plus loin.

### 2. Résolution d'une URL

Pour qu'un navigateur Internet puisse obtenir cette page, l'ordinateur (l'hôte) de l'utilisateur doit en obtenir l'IP. Ce processus s'appelle la résolution d'une URL.
Pour ce faire, l'hôte s'adresse à un serveur DNS. L'hôte reçoit normalement l'IP d'un ou deux serveurs DNS via DHCP. Ce sont généralement ceux mis à disposition par le fournisseur d'accès Internet auquel l'utilisateur est abonné. Il est également possible d'introduire en dur ces IP, et donc choisir d'autres serveurs DNS.





Une fois l'idée germée, il a fallu réfléchir à comment offrir ce service. Un programme à installer ? Une extension pour le navigateur Internet ?

Le but étant de permettre à quiconque d'utiliser ce service, ces deux solutions ne sont pas envisageable. Pour pouvoir installer un programme ou une extension demande des droits assez élevé sur un ordinateur. Or, le client d'un cybercafé ou l'employé d'une entreprise ne possède souvent ces droits.

C'est donc assez naturellement que le choix s'est tourné vers une application web. De cette manière n'importe qui ayant un accès à Internet pourrait utiliser le service.
Pour aller plus loin, et permettre au maximum de monde d'utiliser le service, le choix a été fait de ne pas utiliser de JavaScript côté client pour les fonctionnalités principales du service.

Que permet donc alors ce service ?

La fonction principale est donc de proposer à l'utilisateur d'entre une URL et de soumettre cette URL à vérifications. Ce que le service va faire alors, c'est de comparer les résultats de la résolution de l'URL par les serveurs DNS des différents FAI de son pays avec 

## 3. Avec quoi ?

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


### 4. Skeleton

Skeleton est un générateur de structure d'application Express. Il permet de générer une base d'application en fonction de différents paramètres. 
Les principaux sont : 

+ Le moteur de template (ejs ou jade)
+ Le moteur de feuilles de style (Stylus, LESS ou CSS)
+ Le moteur JavaScript (CoffeeScript ou JavaScript)

### 5. connect-assets
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

Simple non ?

###	7. Stylus
###	8. Bootstrap
###	9. Node-mysql
###	10. Request 