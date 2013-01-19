var debug = false;

function route(handle, pathname, response, postData) {
	if (debug) {
		console.log('About to route a request for ' + pathname);
	}
	if (typeof handle[pathname] === 'function') {
		handle[pathname](response, postData);
	} else {
		if (debug) {
			console.log('No request handler found for ' + pathname);
		}
		/*TODO make and call a real 404*/
		response.writeHead(404, {'Content-Type': "text/plain"});
		response.write('404 Not found');
		response.end();
	}
}

exports.route = route;