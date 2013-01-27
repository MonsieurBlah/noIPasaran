var mongoose = require( 'mongoose' );
var Schema   = mongoose.Schema;
 
var dns_model = new Schema({
    dns_name        : String,
    primary_ip      : String,
    secondary_ip    : String,
    isISP           : Boolean,
    updated_at      : Date
});
 
mongoose.model('dns_model', dns_model);
 
mongoose.connect('mongodb://localhost/dns');