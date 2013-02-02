var dnsClass	= require('dns')
  , mongoose 	= require('mongoose')
  , dns_temp	= mongoose.model('dns_temp')
  , dns_final	= mongoose.model('dns_final')
  , user		= mongoose.model('user')
  , flash = require('connect-flash')

var REGEX_IP = /\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/;

exports.root = function (req, res) {
  	res.render('index',{title: 'Home'})
};

exports.index = function (req, res) {
	res.redirect('/');
}

exports.query = function (req, res) {
	var query = req.body.query;
	if (query.match(REGEX_IP) != null) {
		res.redirect("/ip="+query)
	} else {
		res.redirect("/url="+query)
	};
}

exports.ip = function (req, res) {
	var theIP = req.url.substr(4,req.url.length);
	res.render('resultip',{title: 'IP ' + theIP + ' ', subtitle: theIP,
	 ip: theIP, message: ''})
};

exports.url = function (req, res) {
	var theURL = req.url.substr(5,req.url.length);

	dnsClass.resolve4(theURL, function(err, addresses){
		if (err) throw err;
		res.render('resulturl',{title: 'URL' + theURL + ' ',
		 url: theURL, ip: addresses})
	})
};

exports.help = function (req, res) {
	res.render('help',{title: 'Help', subtitle: 'I need somebody...',
		message: req.flash('info'), message1: req.flash('info1'),
		message2: req.flash('info2'),message3: req.flash('info3'),
		name: req.flash('name'), prip: req.flash('prip'),
		seip: req.flash('seip')});
};

exports.helpip = function (req, res) {
	req.flash('prip', req.params.ip);
	res.redirect('help');
}

exports.submit = function (req, res) {
	var body = req.body;
	if (!body.primaryip.match(REGEX_IP)) {
		req.flash('info1', 'firstwrong');
	}
	if (!body.secondaryip.match(REGEX_IP)) {
		req.flash('info2', 'secondwrong');
	}
	if (body.country == "") {
		req.flash('info3', 'countrywrong');
	} 
	if (body.primaryip.match(REGEX_IP) && body.secondaryip.match(REGEX_IP) && body.country != "") {
		new dns_temp({
			DNSname 	: req.body.dnsname,
			primaryIP 	: req.body.primaryip,
			secondaryIP : req.body.secondaryip,
			country		: req.body.country,
			isISP		: req.body.isisp,
			updatedAt	: Date.now()
		}).save(function(err, dns_temp, count) {
		if (err) {console.log("Err on save")};
		})
		req.flash('info', 'ok');
	} 
	if (req.flash('info') != 'ok') {
		req.flash('name', body.dnsname);
		req.flash('prip', body.primaryip);
		req.flash('seip', body.secondaryip);
	} else {
		req.flash('info', 'ok');
	}
	res.redirect('/help');
};

exports.destroy = function (req, res) {
	if (req.params.db == 'temp') {
		dns_temp.findById(req.params.id, function (err, dnses) {
			dnses.remove( function (err, dnses) {
				res.redirect('/admin/temp');
			})
		})
	} else {
		dns_final.findById(req.params.id, function (err, dnses) {
			dnses.remove( function (err, dnses) {
				res.redirect('/admin/final');
			})
		})
	}
};

exports.validate = function (req, res) {
	if (req.params.db == 'temp') {
		dns_temp.findById(req.params.id, function(err, dns) {
			new dns_final({
			DNSname 	: dns.DNSname,
			primaryIP 	: dns.primaryIP,
			secondaryIP : dns.secondaryIP,
			country		: dns.country,
			isISP		: dns.isISP,
			updatedAt	: Date.now()
		}).save(function(err, dns_final, count) {
			if (err) {"Err on save"};
			dns.remove( function(err, dns) {
				res.redirect('/admin/temp');
			})
		})
		})
	};
};

exports.edit = function (req, res) {
	if (req.params.db == 'temp') {
		dns_temp.find( function(err, dnses) {
			if (err) {};
			res.render('admin',{title: 'Admin', subtitle: 'Edit',
			 dnslist: dnses, current: req.params.id, type: 'temp'})
		});
	} else {
		dns_final.find( function(err, dnses) {
			if (err) {};
			res.render('admin',{title: 'Admin', subtitle: 'Edit',
			 dnslist: dnses, current: req.params.id, type: 'final'})
		});
	}
};

exports.update = function (req, res) {
	if (req.params.db == 'temp') {
		dns_temp.findById(req.params.id, function(err, dns) {
			dns.DNSname		= req.body.dnsname;
			dns.primaryIP 	= req.body.primaryip;
			dns.secondaryIP = req.body.secondaryip;
			dns.country		= req.body.country;
			dns.isISP 		= req.body.isisp;
			dns.updatedAt	= Date.now();
			dns.save(function(err, dns, count) {
				res.redirect('/admin/temp');
			});
		});
	} else {
		dns_final.findById(req.params.id, function(err, dns) {
			dns.DNSname		= req.body.dnsname;
			dns.primaryIP 	= req.body.primaryip;
			dns.secondaryIP = req.body.secondaryip;
			dns.country		= req.body.country;
			dns.isISP 		= req.body.isisp;
			dns.updatedAt	= Date.now();
			dns.save(function(err, dns, count) {
				res.redirect('/admin/final');
			});
		});
	}
};

exports.admin = function (req, res) {
	if (req.params.db == 'temp') {
		dns_temp.find( function(err, dnses) {
			if (err) {};
			res.render('admin',{title: 'Admin', subtitle: 'DNS Temp',
			 dnslist: dnses, current: '1', type: 'temp'});
		});
	} else {
		dns_final.find( function(err, dnses) {
			if (err) {};
			res.render('admin',{title: 'Admin', subtitle: 'DNS Finals',
			 dnslist: dnses, current: '1', type: 'final'});
		});
	}
};

exports.test = function (req, res) {
	dns_final.find( function(err, dnses) {
		if (err) {};
		res.render('test',{title: 'Test', dnslist: dnses});
	});
};

exports.fourOfour = function (req, res) {
  	res.render('404',{title: '¿ Qué pasó ?', subtitle: 'Es un cuatrocientos cuatro !', 
  		url : req.headers.host + req.url})
};