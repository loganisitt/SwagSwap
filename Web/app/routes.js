var passport = require('passport')

module.exports = function(app) {

    app.get('/', renderIndex);
    app.get('/login', renderIndex);
    app.get('/signup', renderIndex);
    app.get('/home', renderIndex);
    app.get('/users', renderIndex);

    function renderIndex(req, res) {
        res.status(200);
        res.render('../index.html');
    }

    app.use('/auth', require('./auth'));

    app.use('/api/listing', require('./api/listing'));
    app.use('/api/user', require('./api/user'));
};