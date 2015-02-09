var mongoose = require('mongoose');

var imageSchema = mongoose.Schema({
    title: {type: String, required: true},
    author: {type: String, required: true},
    description: {type: String},
    image: {
        modificationDate: {type: Date},
        name: {type: String},
        size: {type: Number},
        type: {type: String},
        filename: {type: String}
    },
    modificationDate: {type: Date, "default": Date.now}
});

module.exports = mongoose.model('Image', imageSchema);
