var express = require('express');
var app = express();
var server = require('http').createServer(app);
var io = require('socket.io').listen(server);

var env = require('node-env-file');
env(__dirname + '/.env');

var port = process.env.NODE_ENV == "production" ? process.env.PRO_PORT : process.env.DEV_PORT;

server.listen(port, function () {
  console.log('Server listening at port %d', port);
});

var mongoose = require('mongoose');
var passport = require('passport');
var flash    = require('connect-flash');

var morgan       = require('morgan');
var path         = require('path');
var cookieParser = require('cookie-parser');
var bodyParser   = require('body-parser');
var session      = require('express-session');

var configDB = require('./config/database.js');

// connect to our database
mongoose.connect(configDB.url);

require('./config/passport')(passport); // pass passport for configuration

app.set('views', __dirname + '/public/views');
app.engine('html', require('ejs').renderFile);
app.set('view engine', 'html');

// set up our express application
app.use(morgan('dev')); // log every request to the console
app.use(cookieParser()); // read cookies (needed for auth)
app.use(bodyParser.json()); // get information from html forms
app.use(bodyParser.urlencoded({ extended: true }));

// required for passport
app.use(session({ secret:'thisisahugesecret'})); // session secret
app.use(passport.initialize());
app.use(passport.session()); // persistent login sessions
app.use(flash()); // use connect-flash for flash messages stored in session

app.use(express.static(__dirname + '/public'));

require('./app/routes.js')(app, passport);
require('./app/socketio.js')(app, io);
