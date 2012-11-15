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
	'<input name="text" type="text" placeholder="i.e. google.com"  />'+
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
	response.writeHead(200, {"Content-Type": "text/plain"});
	var url = querystring.parse(postData).text;
	var ip = "none";

	dns.resolve4(url, function (err,addresses) {
		if (err) throw err;

		ip = addresses[1];
		console.log('addresses: ' + addresses[1]);

		
		
	});

	response.write("The IP for " + url + " is " + ip);
	response.end();
}

function favicon(response,  postData) {
	console.log("Request handler 'favicon' was called.");
	// do nothing for the moment
}
	

exports.start = start;
exports.check = check;
exports.favicon = favicon;