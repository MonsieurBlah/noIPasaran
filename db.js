var mongoose = require( 'mongoose' );
var Schema   = mongoose.Schema;

var DNS = Schema({
			name		: String,
			primaryIP	: String,
			secondaryIP : String,
			isISP		: Boolean
});

mongoose.model('DNS', DNS);

mongoose.connect('mongodb://admin:noipasaranadmin@ds037847.mongolab.com:37847/noipasaran');