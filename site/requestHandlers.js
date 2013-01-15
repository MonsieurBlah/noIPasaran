var querystring = require('querystring');
var dns = require('dns');
var fs = require('fs');
/*var dns = require('native-dns');*/



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
			'</head>'+
			'<body>'+
			'<p>'+
			'The IP address of '+url+' is '+'<a href="http://'+ip[0]+'" target="_blank">'+ip[0]+'</a>'+ 
			'</p>'+
			'<a href="http://www.datalove.me" target="_blank"><img src="http://datalove.me/datalove/datalove-s1.png"/></a>'+
			'</body>'+
			'</html>');
		response.end();	
		console.log('address: ' + ip);
	})

}

function favicon(response,  postData) {
	response.writeHead(200, {'Content-Type': 'image/x-icon'} );
    response.end();
	console.log("Request handler 'favicon' was called.");
}
	

exports.start = start;
exports.check = check;
exports.favicon = favicon;