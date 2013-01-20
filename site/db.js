var mongodb = require('mongodb')
, mongoose  = require('mongoose');

function initDB() {
	mongoose.connect('mongodb://localhost/dns');
	var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function callback () {
	var dnsSchema = mongoose.schema({
		Name: String,
		primaryIP: String,
		secondaryIP : String,
		isISP: Boolean
	})
	var DNS = mongoose.model('DNS', dnsSchema)
});
}