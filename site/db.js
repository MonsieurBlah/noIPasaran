var mongodb = require('mongodb')
, mongoose  = require('mongoose');

function initDB() {
	mongoose.connect('mongodb://admin:<password>@ds037847.mongolab.com:37847/noipasaran');
	var db = mongoose.connection;
	db.on('error', console.error.bind(console, 'connection error:'));
	db.once('open', function callback () {
		var dnsSchema = mongoose.schema({
			name: String,
			primaryIP: String,
			secondaryIP : String,
			isISP: Boolean
		})
		dnsSchema.method.isISP = function() {
			var result = this.isISP ? this.name + " is an ISP." : this.name + "isn't an ISP."
			console.log(result);
			return this.isISP;
		}


		var DNS = mongoose.model('DNS', dnsSchema)
		var google = new DNS({ name: 'Google', primaryIP: "8.8.8.8", 
			secondaryIP: '8.8.4.4', isISP: false});

		google.save(function(err, google) {
		if (err) { /*Deal with the error*/};
		google.isISP();
		})
	});
}

exports.initDB = initDB;