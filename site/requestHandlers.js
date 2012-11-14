var querystring = require("querystring");
var dns = require("dns");

function start(response, postData) {
	console.log("Request handler 'start' was called.");

	var body = '<html>'+
	'<head>'+
	'<meta http-equiv="Content-Type" content="text/html; '+
	'charset=UTF-8" />'+
	'</head>'+
	'<body>'+
	'<form action="/check" method="post">'+
	'<textarea name="text" rows="1" cols="60"></textarea>'+
	'<input type="submit" value="Submit link" />'+
	'</form>'+
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
	dns.resolve4(url, function (err,addresses) {
		if (err) throw err;

		console.log("addresses: " + JSON.stringify(addresses));
		
	});
	response.write("You've sent the url: " + url);
	response.end();
	

exports.start = start;
exports.check = check;