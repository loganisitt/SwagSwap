'use strict';

var express = require('express');
var controller = require('../controllers/ListingController');

var router = express.Router();

router.get('/', controller.index);
router.post('/', controller.create);
router.get('/search', controller.search)

module.exports = router;