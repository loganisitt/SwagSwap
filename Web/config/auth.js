

module.exports = {

	'facebookAuth' : {
		'clientID' 		: '742900129109809',
		'clientSecret' 	: 'a36db94e433328f66f2b7737539daccc',
		'callbackURL' 	: process.env.NODE_ENV == "production" ? process.env.PRO_CALLBACK : process.env.DEV_CALLBACK
	}

};
