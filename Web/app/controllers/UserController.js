var mongoose = require('mongoose')
var User = require('../models/user');

// GET api/user/
module.exports.index = function(req, res) {
	User.find(function(err, users) {
		if (err)
			res.send(err);

		res.status(200);
		res.json(users);
	});
};