# noIPasaran

[noIPasaran][noipasaran] is a web service that give you the most probable IP for the website you want to visit.
It will also check if your ISP is blocking the IP, based on a DNS server check. 
Some additional features will be added along the way.

This is my final project in my bachelor degree. 

It's still a work in progress.


## What it does

It gets your IP address (but never saves it), try to get the country you live in and/or your ISP.
Then, base on the URL you submited, compares the resolved IP address for that URL with the one of a selection of neutral DNS servers.

It performs too a content comparaison of the resulted HTML page.


## What it's made of

+ [node.js][node] - The great JS framework to build lightweight and scalable network application
+ [CoffeeScript][coffee] - It's just JavaScript. But better.
+ [Express][express] - Web application framework for Node.
+ [connect-assets][connect] - File compilation and dependency management framework for Node's connect framework.
+ [jQuery][jquery] - The multi-browser JS library designed for client-side scripting of HTML
+ [Jade][jade] - High performance template engine influenced by Haml and implemented with JS for Node.
+ [Stylus][stylus] - Efficient way to write CSS. It is to CSS what's Jade is to HTML.
+ [node-mysql][nodemysql] - A great little module to use MySQL db with node.
+ [Bootstrap][bootstrap] - The most famous front-end framework.
+ [Skeleton][skeleton] - An Express 3.0 framework-lss app structure generator.
+ [Request][request] - A simple module to make HTTP calls.
+ [Node-dns][nodedns] - A replacement DNS stack for Node.
+ [Marked][marked] - A markdown parser and compiler build for speed.
+ [Async][async] - A utility module that provides asynchronous function for JS.
+ [Underscore][underscore] - Underscore is a utility-belt library for JavaScrip.
+ [MD5][md5] - A quick md5 hasher.
+ [bcrypt.node.js][brcypt] - A simple module to crypt/decrypt a password based on the bcrypt algorithm. 

The app is hosted by [Heroku][heroku]
The wierd [noIProxy][noiproxy] it uses to hash HTML is hosted by [appfog][appfog]
The database is currently hosted by [AlwaysData][alwaysdata]

It uses also : 

+ [freegeoip][freegeoip]

Made with love under [Fedora][fedora] using [Sublime Text][sublime] with lots of cool packages


### How it runs

To run it, you must have [Node.js][node] installed.

You can install [nodemon][nodemon], a great way to run node apps without stopping and starting each time you make a modification.

First install nodemon (with a -g for global)

	(sudo) npm install -g nodemon

Then run the app. Nodemon will know witch file to run based on the package.json file.

	nodemon

And off you go !
The app is currently set on developpement mode and listens on the port 3000


## Licence

Copyright (c) 2013 Bernard Debecker <bernard.debecker@gmail.com>

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the [LICENCE][licence] file for more details.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

[node]:http://nodejs.org/
[express]:http://expressjs.com
[jade]:http://jade-lang.com/
[bootstrap]:http://twitter.github.io/bootstrap/
[nodemysql]:https://github.com/felixge/node-mysql
[skeleton]:https://github.com/EtienneLem/skeleton
[alwaysdata]:https://www.alwaysdata.com/
[nodemon]:https://github.com/remy/nodemon
[stylus]:http://learnboost.github.io/stylus/
[coffee]:http://coffeescript.org/
[freegeoip]:http://freegeoip.net/
[jquery]:http://jquery.com/
[connect]:https://github.com/adunkman/connect-assets
[fedora]:http://fedoraproject.org/
[sublime]:http://www.sublimetext.com/
[request]:https://github.com/mikeal/request
[licence]:https://raw.github.com/brnrd/noipasaran/master/LICENCE
[nodedns]:https://github.com/tjfontaine/node-dns
[marked]:https://github.com/chjj/marked
[async]:https://github.com/caolan/async/
[underscore]:http://underscorejs.org/
[md5]:https://github.com/pvorb/node-md5
[bcrypt]:https://github.com/ncb000gt/node.bcrypt.js/
[appfog]:https://www.appfog.com/
[heroku]:https://www.heroku.com/
[noiproxy]:http://noiproxy.ap01.aws.af.cm/
[noipasaran]:http://noipasaran.herokuapp.com/