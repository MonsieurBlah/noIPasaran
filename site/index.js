var server = require('./server');
var router = require('./router');
var requestHandlers = require('./requestHandlers');

var handle = {}
handle['/'] = requestHandlers.index;
handle['/index'] = requestHandlers.index;
handle['/check'] = requestHandlers.check;
handle['/about'] = requestHandlers.about;
handle['/check.htm'] = requestHandlers.checkhtm
handle['/noipasaran.css'] = requestHandlers.css;
handle['/noipasaran.png'] = requestHandlers.png;
handle['/favicon.ico'] = requestHandlers.favicon;
handle['/template.mustache'] = requestHandlers.template;

server.start(router.route, handle);