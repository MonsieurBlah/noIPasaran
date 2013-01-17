var querystring = require('querystring');
var dns = require('dns');
var fs = require('fs');
/*var dns = require('native-dns');*/
var debug = false;

// The first page
function start(response, postData) {
	console.log("Request handler 'start' was called.");
    fs.readFile('./index.htm', function(error, content) {
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

// The page that is called when the Get IP button is clicked
function check(response, postData) {
	console.log("Request handler 'check' was called.");

	var url = querystring.parse(postData).text;
	
	dns.resolve4(url, function (err,addresses) {
		if (err) throw err;

		var	ip = addresses;
		response.writeHead(200, {"Content-Type": "text/html"});
		response.write('<html>'+
			'<head>'+
			'<meta http-equiv="Content-Type" content="text/html; '+
			'charset=UTF-8" />'+
			'<link rel="stylesheet" type="text/css" media="screen" href="noipasaran.css" />'+
			'</head>'+
			'<body>'+
			'<p>'+
			'The IP address of '+url+' is '+'<a href="http://'+ip[0]+'" target="_blank">'+ip[0]+'</a>'+ 
			'</p>'+
			'<div class = "externals">'+
			'<a href="http://www.datalove.me" target="_blank"><img src="http://datalove.me/datalove/datalove-s1.png"/></a>'+
			'</div>'+
			'</body>'+
			'</html>');
		response.end();	
		console.log('address: ' + ip);
	})
}

function css(response, postData) {
	console.log("Request handler 'css' was called.");
    fs.readFile('./noipasaran.css', function(error, content) {
        if (error) {
            response.writeHead(500);
            response.end();
        }
        else {
            /*response.writeHead(200, { 'Content-Type': 'text/html' });*/
            response.end(content, 'utf-8');
        }
    });

}

// The function to give the favicon to the browser, not functionnal for now
function favicon(response,  postData) {
	response.writeHead(200, {'Content-Type': 'image/x-icon'} );
    response.end();
	console.log("Request handler 'favicon' was called.");
}
	

exports.start = start;
exports.check = check;
exports.css = css;
exports.favicon = favicon;