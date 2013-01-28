var mongoose = require( 'mongoose' );
var Schema   = mongoose.Schema;
 
var dns_temp = new Schema({
	name			: String,
	primaryIP		: String,
	secondaryIP		: String,
	isISP			: Boolean,
	updatedAt		: Date
});

var dns_final = new Schema({
	name			: String,
	primaryIP		: String,
	secondaryIP		: String,
	isISP			: Boolean,
	updatedAt		: Date
});

mongoose.model('dns_temp', dns_temp);
mongoose.model('dns_final', dns_final);
 
mongoose.connect('mongodb://localhost/test');