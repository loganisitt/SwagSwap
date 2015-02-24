var mongoose = require('mongoose'),
  mongoosastic = require('mongoosastic'),
  Schema = mongoose.Schema

var listingSchema = new Schema({
  created_at: Date,
  updated_at: Date,
  userId: String,
  category: String,
  name: {
    type: String,
    es_indexed: true
  },
  description: {
    type: String,
    es_indexed: true
  },
  price: Number,
  bids: [String],
  comments: [String],
  image_paths: [String]
});

listingSchema.plugin(mongoosastic)

listingSchema.pre('save', function(next) {
  var currentDate = new Date();

  this.updated_at = currentDate;

  if (!this.created_at)
    this.created_at = currentDate;

  next();
});

var Listing = mongoose.model('Listing', listingSchema);
var stream = Listing.synchronize();
var count = 0;

stream.on('data', function(err, doc) {
  count++;
});
stream.on('close', function() {
  console.log('indexed ' + count + ' documents!');
});
stream.on('error', function(err) {
  console.log(err);
});

module.exports = Listing