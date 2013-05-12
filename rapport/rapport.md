# noIPasaran

## 1. Pourquoi ?
## 2. Comment ?
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

	7. Stylus
	8. Bootstra
	9. Node-mysql
	10. Request 