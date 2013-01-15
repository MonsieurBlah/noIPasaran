noIPasaran
==========
[http://github.com/MonsieurBlah/noIPasaran](https://github.com/MonsieurBlah/noIPasaran)

Description
-----------

[noIPasaran](http://noipasaran.eu01.aws.af.cm/) will be a web service written in Node.js that give you the most probable IP for the website you want to visit.
It will also check if your ISP is blocking the IP. If so, it will gives you the opportunity to overpass this censorship.

This is my final project in my bachelor degree. 

Since this project is due for June '13, it's still a work in progress.

What it does
------------

The online version is only used for testing purpose. Don't rely on anything you read there. 
It's hosted by [AppFog](https://www.appfog.com).

For now it only does a simple resolve of the given URL. And it doesn't always do it well.

To be done
----------

- Switch to Express.
- Link a MongoDB database with the ISP DNS servers.
- Choose whether the resolve is going to be done on the client or on the server. For now, it's on the server but the client may be a good idea.
- Find new ideas.