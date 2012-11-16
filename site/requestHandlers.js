var querystring = require('querystring');
var dns = require('dns');
/*var dns = require('native-dns');*/

function start(response, postData) {
	console.log("Request handler 'start' was called.");

	var body = '<html>'+
	'<head>'+
	'<meta http-equiv="Content-Type" content="text/html; '+
	'charset=UTF-8" />'+
	'</head>'+
	'<body>'+
	'<form action="/check" method="post">'+
	'<input name="text" type="text" placeholder="e.g. www.google.com"  />'+
	'<input type="submit" value="Get IP" />'+
	'</form>'+
	'<a href="http://www.datalove.me" target="_blank"><img src="http://datalove.me/datalove/datalove-s1.png"/></a>'+
	'</body>'+
	'</html>';

	response.writeHead(200, {"Content-Type": "text/html"});
	response.write(body);
	response.end();
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