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


Parse.Cloud.afterSave("Message", function(request) {

  // var listingQuery = new Parse.Query("Listing");
  // listingQuery.equalTo('objectId', request.object.get("recipient").id);
  // listingQuery.find({
  //       success: function(results) {



          var pushQuery = new Parse.Query(Parse.Installation);
          pushQuery.equalTo('userId', request.object.get("recipient").id);

          Parse.Push.send({
          where: pushQuery, 
          data: {
              alert: "Message",
              content: request.object.get("content")
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


    //     },
    //     error: function(error) {
    //       console.error(error)
    //     }
    // });
});