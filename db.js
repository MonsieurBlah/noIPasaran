var mongoose = require( 'mongoose' );
var Schema   = mongoose.Schema;
 
var dns_model = new Schema({
    name        : String,
    primaryIP      : String,
    secondaryIP    : String,
    isISP          : Boolean,
    updatedAt      : Date
});
 
mongoose.model('dns_model', dns_model);
 
mongoose.connect('mongodb://localhost/dns');