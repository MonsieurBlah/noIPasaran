var server = require('./server');
var router = require('./router');
var requestHandlers = require('./requestHandlers');

var handle = {}
handle['/'] = requestHandlers.start;
handle['/start'] = requestHandlers.start;
handle['/check'] = requestHandlers.check;
handle['/check.htm'] = requestHandlers.checkhtm
handle['/noipasaran.css'] = requestHandlers.css;
handle['/favicon.ico'] = requestHandlers.favicon;
handle['/template.mustache'] = requestHandlers.template;

server.start(router.route, handle);