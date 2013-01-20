var server = require('./server');
var router = require('./router');
var requestHandlers = require('./requestHandlers');

var handle = {}
handle['/'] = requestHandlers.index;
handle['/index'] = requestHandlers.index;
handle['/ip'] = requestHandlers.ip;
handle['/about'] = requestHandlers.about;
handle['/help'] = requestHandlers.help;
handle['/ip.htm'] = requestHandlers.checkhtm
handle['/noipasaran.css'] = requestHandlers.css;
handle['/favicon.ico'] = requestHandlers.favicon;
handle['/template.mustache'] = requestHandlers.template;

server.start(router.route, handle);