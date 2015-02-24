var passport = require('passport')

var express = require('express');

var router = express.Router();

router
	.post('/login',
		passport.authenticate('local-login', {
			failureFlash: true
		}));

router
	.post('/signup',
		passport.authenticate('local-signup', {
			successRedirect: '/', 
			failureRedirect: '/signup', 
			failureFlash: true 
		}));

router
	.get('/facebook',
		passport.authenticate('facebook', {
			session: false,
			scope: ['email']
		}));

router
	.get('/facebook/callback',
		passport.authenticate('facebook', {
			session: false
		}),
		function(req, res) {
			res.render('../index.html');
			res.redirect('/home');
		},
		function(err, req, res, next) {
			if (err) {
				res.render('..index.html');
				res.redirect('/login');
			}
		});

router
	.post('/facebook',
		passport.authenticate('facebook-token', {
			session: true
		}),
		function(req, res) {
			res.json(req.user);
		});

router.get('/unlink/local', unlink);
router.get('/unlink/facebook', unlinkFacebook);

function unlink(req, res) {
	var user = req.user;
	user.local.email = undefined;
	user.local.password = undefined;
	user.save(function(err) {
		res.redirect('/');
	});
}

function unlinkFacebook(req, res) {
	var user = req.user;
	user.facebook.token = undefined;
	user.save(function(err) {
		res.redirect('/');
	});
}

module.exports = router;