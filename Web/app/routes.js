var Listing = require('./models/listing');
var User = require('./models/user');
var formidable = require('formidable'),
  http = require('http'),
  util = require('util'),
  fs = require('fs-extra');

var uuid = require('node-uuid');

module.exports = function(app, passport) {

  app.get('/', function(req, res) {
    res.status(200);
    res.render('../index.html', {
      locals: {
        title: 'Your Page Title',
        description: 'Your Page Description',
        author: 'Your Name',
        analyticssiteid: 'XXXXXXX'
      }
    });
  });

  app.get('/login', function(req, res) {
    res.status(200);
    res.render('../index.html', {
      locals: {
        title: 'Your Page Title',
        description: 'Your Page Description',
        author: 'Your Name',
        analyticssiteid: 'XXXXXXX'
      }
    });
  });

  app.get('/signup', function(req, res) {
    res.status(200);
    res.render('../index.html', {
      locals: {
        title: 'Your Page Title',
        description: 'Your Page Description',
        author: 'Your Name',
        analyticssiteid: 'XXXXXXX'
      }
    });
  });

  app.get('/home', function(req, res) {
    res.status(200);
    res.render('../index.html', {
      locals: {
        title: 'Your Page Title',
        description: 'Your Page Description',
        author: 'Your Name',
        analyticssiteid: 'XXXXXXX'
      }
    });
  });

  app.get('/users', function(req, res) {
    res.status(200);
    res.render('../index.html', {
      locals: {
        title: 'Your Page Title',
        description: 'Your Page Description',
        author: 'Your Name',
        analyticssiteid: 'XXXXXXX'
      }
    });
  });


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

  // route for facebook authentication and login
  app.get('/auth/facebook',
    passport.authenticate('facebook', {
      session: false,
      scope: ['email']
    })
  );

  // handle the callback after facebook has authenticated the user
  app.get('/auth/facebook/callback',
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
    }
  );


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
  // app.post('/api/listing', function(req, res) {
  //
  //   Listing.create({
  //     userId: req.body.userID,
  //     category: req.body.category,
  //     name: req.body.name,
  //     description: req.body.description,
  //     price: req.body.price
  //   }, function(err, event) {
  //     if (err)
  //       res.send(err);
  //
  //     Listing.find(function(err, listings) {
  //       if (err)
  //         res.send(err);
  //
  //       res.json(listings);
  //     });
  //   });
  // });

  // Returns all of the listings
  app.get('/api/listing', function(req, res) {
    Listing.find(function(err, listings) {
      if (err)
        res.send(err);

      res.status(200);
      res.json(listings);
    });
  });

  // Creates a new listing
  app.post('/api/listing', function(req, res) {
    // creates a new incoming form.
    var form = new formidable.IncomingForm();

    var d = new Date();
    var m = d.getUTCMilliseconds() + 1;
    var n = m
    var str = n + ''

    while (str.length < 12) {
      n *= m;
      str = n + '';
    }
    var new_location = './public/static/uploads/' + str.substr(0, 12) + '/';

    var passFields;

    form.parse(req, function(err, fields, files) {
      passFields = fields;
    });

    form.on('progress', function(byteReceived, byteExpected) {
      // console.log('Uploaded: ' + Math.round(byteReceived / byteExpected * 100) + '%');
    });

    form.on('end', function(fields, files) {
      var filepaths = new Array();

      for (var i = 0; i < this.openedFiles.length; i++) {
        filepaths.push(new_location + uuid.v4() + '.png');
      }

      for (var i = 0; i < this.openedFiles.length; i++) {

        var temp_path = this.openedFiles[i].path;

        /* Location where we want to copy the uploaded file */
        fs.copy(temp_path, filepaths[i], function(err) {
          if (err) {
            console.error(err);
          } else {
            console.log('Success!')
          }
        });

        Listing.create({
          userId: passFields.userID,
          category: passFields.category,
          name: passFields.name,
          description: passFields.description,
          price: passFields.price,
          image_paths: filepaths
        }, function(err, event) {
          if (err)
            res.send(err);

          Listing.find(function(err, listings) {
            if (err)
              res.send(err);

            console.log('Listing Success!')

            res.json(listings);

          });
        });
      }
    });

    return;
  });


  // Returns all of the events that have active dates after or on our current day.
  app.get('/api/users', function(req, res) {
    User.find(function(err, users) {
      if (err)
        res.send(err);

      res.json(users);
    });
  });

};

// route middleware to ensure user is logged in
function isLoggedIn(req, res, next) {
  if (req.isAuthenticated())
    return next();

  res.redirect('/');
}
