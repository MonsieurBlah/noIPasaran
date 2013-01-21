var querystring = require('querystring')
, dns 			= require('dns')
, fs 			= require('fs')
, util          = require('util')
, mu 			= require('mu2')
, db            = require('./db');
/*var dns = require('native-dns');*/
var debug = false;

mu.root = __dirname + '/templates'

// The home page
function index(response, postData) {
    if (debug) {
	   console.log("Request handler 'start' was called.");
    }
    var stream = mu.compileAndRender('index.htm', 'template');
    util.pump(stream, response);
    /*fs.readFile('./index.htm', function(error, content) {
        if (error) {
            response.writeHead(500);
            response.end();
        }
        else {
            response.writeHead(200, { 'Content-Type': 'text/html' });
            response.end(content, 'utf-8');
            db.initDB();
        }
    });*/

}

// The page that is called when the Get IP button is clicked
function ip(response, postData) {
    if (debug) {
	   console.log("Request handler 'check' was called.");
    }

	var url = querystring.parse(postData).text;
    mu.root = __dirname + '/site';
	
	dns.resolve4(url, function (err, addresses) {
		if (err) throw err;

		var	ips = addresses;
		var jsonips = "{";
		for (var i = ips.length - 1; i >= 0; i--) {
			jsonips += "\"ip\": \"" + ips[i] + "\",\n";
		};
		jsonips += "}";

		console.log('jsonips = ' + jsonips);

		/*var JSONaddresses = JSON.stringify({ip : ips});*/
		
		var template = "{{#JSONaddresses}}<b>{{ip}}</b>{{/JSONaddresses}}";
/*
        var stream = mu.compileAndRender('check.htm', jsonips);
        sys.puts('Stream = ' + stream);
        util.pump(stream, response);
        console.log('Stream = ' + stream.toString('utf-8'));
        response.writeHead(200, { 'Content-Type': 'text/html' });
        response.end(stream, 'utf-8');*/

        fs.readFile('./check.htm', function(error, content) {
            if (error) {
                response.writeHead(500);
                response.end();
            }
            else {
                response.end(content, 'utf-8');
            }
        })

		/*var html = mu.to_html(template, jsonips);
		console.log('html = ' + html);
		response.writeHead(200, { 'Content-Type': 'text/html' });
        response.end(html, 'utf-8');
		
		response.end();	*/
		console.log('address: ' + ips);
	})
}

function iphtm(response, postData) {
    if (debug) {
	   console.log("Request handler 'css' was called.");
    }       
    fs.readFile('./check.htm', function(error, content) {
        if (error) {
            response.writeHead(500);
            response.end();
        }
        else {
            response.end(content, 'utf-8');
        }
    });
}

function about(response, postData) {
    if (debug) {
        console.log("Request handler 'start' was called.");
    }
    fs.readFile('./about.htm', function(error, content) {
        if (error) {
            response.writeHead(500);
            response.end();
        }
        else {
            response.writeHead(200, { 'Content-Type': 'text/html' });
            response.end(content, 'utf-8');
        }
    });

}

function help(response, postData) {
    if (debug) {
        console.log("Request handler 'help' was called.");
    }
    fs.readFile('./help.htm', function(error, content) {
        if (error) {
            response.writeHead(500);
            response.end();
        }
        else {
            response.writeHead(200, { 'Content-Type': 'text/html' });
            response.end(content, 'utf-8');
        }
    });

}

function css(response, postData) {
    if (debug) {
	   console.log("Request handler 'css' was called.");
    }
    fs.readFile('./noipasaran.css', function(error, content) {
        if (error) {
            response.writeHead(500);
            response.end();
        }
        else {
            response.end(content, 'utf-8');
        }
    });
}

// The function to give the favicon to the browser, not functionnal for now
function favicon(response,  postData) {
    if (debug) {
        console.log("Request handler 'favicon' was called.");
    }
    fs.stat('./favicon.ico', function(error, stat) {
        var rs;
        response.writeHead(200, {
            'Content-Type' : 'x-icon',
            'Content-Length' : stat.size
        });
        rs = fs.createReadStream('./favicon.ico');
        util.pump(rs, response, function(err) {
            if(err) {
                throw err;
            }
        });
    });
}

function template(response, postData) {
    if (debug) {
	   console.log("Request handler 'template' was called.");
    }
    fs.readFile('./template.mustache', function(error, content) {
        if (error) {
            response.writeHead(500);
            response.end();
        }
        else {
            response.end(content, 'utf-8');
        }
    });
}
	

exports.index = index;
exports.ip = ip;
exports.iphtm = iphtm;
exports.about = about;
exports.help = help;
exports.css = css;
exports.favicon = favicon;
exports.template = template;