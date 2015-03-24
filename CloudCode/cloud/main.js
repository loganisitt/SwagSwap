
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
	var query = new Parse.Query(Parse.Installation);
	query.equalTo('userId', 'itdpLcJx5F');

	Parse.Push.send({
  		where: query, // Set our Installation query
  		data: {
  			alert: "Willie Hayes injured by own pop fly."
  		}
  	}, 
  	{
  		success: function() {
    		response.success("Congrats")
    },
    error: function(error) {
    		response.error(error)
    	}
    });
});


// Notify User that another User has placed an offer on one of their listings.
Parse.Cloud.afterSave("Offer", function(request) {

	var listingQuery = new Parse.Query("Listing");
	listingQuery.equalTo('objectId', request.object.get("listing").id);
	listingQuery.find({
        success: function(results) {
        	if (results.length > 1) {
        		console.error("Too many results");	
        	}

        	var pushQuery = new Parse.Query(Parse.Installation);
        	pushQuery.equalTo('userId', results[0].get("seller").id);

        	Parse.Push.send({
  				where: pushQuery, 
  				data: {
  					alert: "Snap, Crackle, Pop"
  				}
  			}, 
  			{
  				success: function() {
    				response.success("Congrats")
    			},
    			error: function(error) {
    				response.error(error)
    			}
    		});
        },
        error: function(error) {
        	console.error(error)
        }
    });
});