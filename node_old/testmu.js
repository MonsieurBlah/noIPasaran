var mu = require('mu2'),
fs     = require('fs'),
    path   = require('path');

mu.root = __dirname + '/templates'

var template = fs.readFileSync(path.join(mu.root, 'template.mustache')).toString();
//console.log('template = ' + template);

mu.compileAndRender('index.htm', template)
	.on('data', function (data) {
    	console.log(data.toString());
	})