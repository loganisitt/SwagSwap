var Listing = require('./models/listing');
var formidable = require('formidable'),
  http = require('http'),
  util = require('util'),
  fs = require('fs-extra');

module.exports = function(app, passport) {

  // process the login form
  app.post('/login', passport.authenticate('local-login', {
    failureFlash: true // allow flash messages
  }));

  // SIGNUP =================================

  // process the signup form
  app.post('/signup', passport.authenticate('local-signup', {
    successRedirect: '/profile', // redirect to the secure profile section
    failureRedirect: '/signup', // redirect back to the signup page if there is an error
    failureFlash: true // allow flash messages
  }));

  // facebook -------------------------------

  app.get('/auth/facebook', passport.authenticate('facebook', {
    scope: 'email',
    session: true
  }));

  // handle the callback after facebook has authenticated the user
  app.get('/auth/facebook/callback',
    passport.authenticate('facebook'),
    function(req, res) {
      var another = res;
      another.send(200)
      res.redirect('/login');
    });


  app.post('/auth/facebook',
    passport.authenticate('facebook-token', {
      session: true
    }),
    function(req, res) {
      res.json(req.user);
    });

  // AUTHORIZE (ALREADY LOGGED IN / CONNECTING OTHER SOCIAL ACCOUNT) =============

  // locally --------------------------------
  app.get('/connect/local', function(req, res) {
    res.render('connect-local.ejs', {
      message: req.flash('loginMessage')
    });
  });
  app.post('/connect/local', passport.authenticate('local-signup', {
    successRedirect: '/profile', // redirect to the secure profile section
    failureRedirect: '/connect/local', // redirect back to the signup page if there is an error
    failureFlash: true // allow flash messages
  }));

  // facebook -------------------------------

  // send to facebook to do the authentication
  app.get('/connect/facebook', passport.authorize('facebook', {
    scope: 'email'
  }));

  // handle the callback after facebook has authorized the user
  app.get('/connect/facebook/callback',
    passport.authorize('facebook', {
      successRedirect: '/profile',
      failureRedirect: '/'
    }));

  // =============================================================================
  // UNLINK ACCOUNTS =============================================================
  // =============================================================================
  // used to unlink accounts. for social accounts, just remove the token
  // for local account, remove email and password
  // user account will stay active in case they want to reconnect in the future

  // local -----------------------------------
  app.get('/unlink/local', isLoggedIn, function(req, res) {
    var user = req.user;
    user.local.email = undefined;
    user.local.password = undefined;
    user.save(function(err) {
      res.redirect('/profile');
    });
  });

  // facebook -------------------------------
  app.get('/unlink/facebook', isLoggedIn, function(req, res) {
    var user = req.user;
    user.facebook.token = undefined;
    user.save(function(err) {
      res.redirect('/profile');
    });
  });

  //////////////
  // Listings //
  //////////////

  // Create new listing, sends back packet
  app.post('/api/listing', function(req, res) {

    Listing.create({
      userId: req.body.userID,
      category: req.body.category,
      name: req.body.name,
      description: req.body.description,
      price: req.body.price
    }, function(err, event) {
      if (err)
        res.send(err);

      Listing.find(function(err, listings) {
        if (err)
          res.send(err);

        res.json(listings);
      });
    });
  });

  var controller = require('./controllers/images.js');


  app.post('/api/listing/image', function(req, res) {
    // creates a new incoming form.
    var form = new formidable.IncomingForm();

    // parse a file upload
    form.parse(req, function(err, fields, files) {
      res.writeHead(200, {
        'content-type': 'text/plain'
      });
      res.write('Upload received :\n');
      res.end(util.inspect({
        fields: fields,
        files: files
      }));
    });
    form.on('end', function(fields, files) {
      /* Temporary location of our uploaded file */
      console.log(this.openedFiles[0]);

      var temp_path = this.openedFiles[0].path;
      /* The file name of the uploaded file */
      var file_name = this.openedFiles[0].name;
      /* Location where we want to copy the uploaded file */
      var new_location = 'uploads/';
      fs.copy(temp_path, new_location + file_name, function(err) {
        if (err) {
          console.error(err);
        } else {
          console.log("success!")
        }
      });
    });
    return;
  });

  // CREATE
  // app.post('/api/listing/image', controller.upload);
  // app.post('/upload', controller.upload);

  // RETRIEVE
  // app.get('/images/:_id', controller.detail);

  // UPDATE
  // app.put('/images/:_id', controller.update);

  // DELETE
  // app.delete('/images/:_id', controller.delete);
};

// route middleware to ensure user is logged in
function isLoggedIn(req, res, next) {
  if (req.isAuthenticated())
    return next();

  res.redirect('/');
}
