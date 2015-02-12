var mongoose = require('mongoose');

var listingSchema = mongoose.Schema({
    created_at: Date,
    updated_at: Date,
    userId: String,
    category: String,
    name: String,
    description: String,
    price: Number,
    bids: [String],
    comments: [String],
    image_paths: [String]
});

listingSchema.pre('save', function(next) {
    var currentDate = new Date();

    this.updated_at = currentDate;

    if (!this.created_at)
        this.created_at = currentDate;

    next();
});

module.exports = mongoose.model('Listing', listingSchema);
