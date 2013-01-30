var mongoose = require( 'mongoose' );
var Schema   = mongoose.Schema;
 
var dns_temp = new Schema({
	DNSname			: String,
	primaryIP		: String,
	secondaryIP		: String,
	country			: String,
	isISP			: Boolean,
	updatedAt		: Date
});

var dns_final = new Schema({
	DNSname			: String,
	primaryIP		: String,
	secondaryIP		: String,
	country			: String,
	isISP			: Boolean,
	updatedAt		: Date
});

var user = new Schema({
	username		: String,
	password		: String
});

mongoose.model('dns_temp', dns_temp);
mongoose.model('dns_final', dns_final);
mongoose.model('user', user);
 
mongoose.connect('mongodb://localhost/test');