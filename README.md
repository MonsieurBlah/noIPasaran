noIPasaran
==========

[noIPasaran](http://noipasaran.eu01.aws.af.cm/) will be a web service that give you the most probable IP for the website you want to visit.
It will also check if your ISP is blocking the IP. If so, it will gives you the opportunity to overpass this censorship.
Some additional features will be added along the way.

This is my final project in my bachelor degree. 

Since this project is due for June '13, it's still a work in progress.


What it does
------------

Nothing for the moment the online version is only used for testing purpose. 
Don't rely on anything you read there. 


What it's made of
-----------------

+ [node.js](http://nodejs.org/)
+ [Express](http://expressjs.com)
+ [Jade](http://jade-lang.com/)
+ [Stylus](http://learnboost.github.com/stylus/)
+ [Nib](http://visionmedia.github.com/nib/)
+ [MongoDB](http://www.mongodb.org/)
+ [Mongoose](http://mongoosejs.com/)
+ [Bootstrap](http://twitter.github.com/bootstrap/)

The app and database are hosted by [AppFog](https://www.appfog.com).

A backup database will be hosted by [MongoLab](https://mongolab.com).


How it works
------------

If you clone the project and you wish to use this pre-alpha version, you must be insane.

Still, to run it, you must have [Node.js](http://nodejs.org/) installed.

Once the installation complete, in the main directory, run :

	node app.js

Or you can install [nodemon](https://github.com/remy/nodemon), a great way to run node apps without stopping and starting each time you make a modification.

First install nodemon.

	npm install nodemon

Then run the app.

	nodemon app.js

And off you go !