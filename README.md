
# noIPasaran

noIPasaran will be a web service that give you the most probable IP for the website you want to visit.
It will also check if your ISP is blocking the IP, based on a DNS server check. If so, it will gives you the opportunity to overpass this censorship.
Some additional features will be added along the way.

This is my final project in my bachelor degree. 

Since this project is due for June '13, it's still a work in progress.


## What it does

Not much for the moment. Be patient dear.


### What it's made of

+ [node.js][1]
+ [coffeescript][10]
+ [Express][2]
+ [Jade][3]
+ [Stylus][9]
+ [node-mysql][5]
+ [Bootstrap][4]
+ [Skeleton][6]

The database is hosted by [AlwaysData][7]


### How it works

If you clone the project, just don't yet.

Still, to run it, you must have [Node.js][1] installed.

You can install [nodemon][8], a great way to run node apps without stopping and starting each time you make a modification.

First install nodemon.

	npm install nodemon

Then run the app. Nodemon will know witch file to run based on the package.json

	nodemon

And off you go !


## Licence

Copyright (c) 2013 Bernard Debecker <bernard.debecker@gmail.com>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

[1]:http://nodejs.org/
[2]:http://expressjs.com
[3]:http://jade-lang.com/
[4]:http://twitter.github.io/bootstrap/
[5]:https://github.com/felixge/node-mysql
[6]:https://github.com/EtienneLem/skeleton
[7]:https://www.alwaysdata.com/
[8]:https://github.com/remy/nodemon
[9]:http://learnboost.github.io/stylus/
[10]:http://coffeescript.org/