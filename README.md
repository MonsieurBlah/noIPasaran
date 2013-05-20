# noIPasaran

noIPasaran will be a web service that give you the most probable IP for the website you want to visit.
It will also check if your ISP is blocking the IP, based on a DNS server check. If so, it will gives you the opportunity to overpass this censorship.
Some additional features will be added along the way.

This is my final project in my bachelor degree. 

Since this project is due for June '13, it's still a work in progress.



## What it does

Not much for the moment. Be patient dear.


### What it's made of

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

The database is hosted by [AlwaysData][alwaysdata]

It uses also : 

+ [freegeoip][freegeoip]

Made with love under [Ubuntu][ubuntu] using [Sublime Text][sublimetext] with lots of cool packages


### How it works

If you clone the project, just don't yet.

Still, to run it, you must have [Node.js][node] installed.

You can install [nodemon][nodemon], a great way to run node apps without stopping and starting each time you make a modification.

First install nodemon (with a -g for global)

	npm install -g nodemon

Then run the app. Nodemon will know witch file to run based on the package.json file.

	nodemon

And off you go !
The app is currently set on developpement mode and listens on the port 3000 (or up if busy)


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
[bootsrap]:http://twitter.github.io/bootstrap/
[nodemysql]:https://github.com/felixge/node-mysql
[skeleton]:https://github.com/EtienneLem/skeleton
[alwaysdata]:https://www.alwaysdata.com/
[nodemon]:https://github.com/remy/nodemon
[stylus]:http://learnboost.github.io/stylus/
[coffee]:http://coffeescript.org/
[freegeoip]:http://freegeoip.net/
[jquery]:http://jquery.com/
[connect]:https://github.com/adunkman/connect-assets
[ubuntu]:http://www.ubuntu.com/
[sublime]:http://www.sublimetext.com/
[request]:https://github.com/mikeal/request
[licence]:https://bitbucket.org/brnrd/noipasaran/raw/b4bf2a8132fbdefb9c5e56787e75e45147323a80/LICENCE
[nodedns]:https://github.com/tjfontaine/node-dns
[marked]:https://github.com/chjj/marked
[async]:https://github.com/caolan/async/
[underscore]:http://underscorejs.org/