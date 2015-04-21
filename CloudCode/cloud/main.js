var Algolia = require('cloud/algoliasearch-node');
var client  = new Algolia('JS58CV0B5Y', 'c4a8bd50025f151ef367f7dfe71c81b4');
var index   = client.initIndex('listings');

Parse.Cloud.define("reindex", function(request, response) {

  indexData();
  
});

var indexData = function() {
  //Array of data to index
  var toIndex = [];

  //Create a new query for Listings
  var query = new Parse.Query('Listing');

  //Find all items
  query.find({
    success: function(listings) {
      //Process each listing
      for (var i = 0; i < listings.length; i++) {
        //Convert Parse.Object to JSON
        var parseObject = listings[i].toJSON();

        //Override Algolia object ID with the Parse.Object unique ID
        parseObject.objectID = parseObject.objectId;

        //Save object for indexing
        toIndex.push(parseObject);
      }

      //Add new indices (if no matching parseObject.objectID) or update
      index.saveObjects(toIndex, function(error, content) {
        if (error)
          console.log('Got an error: ' + content.message);
      });
    },
    error: function(error) {
      console.error('Got an error: ' + error.code + ': ' + error.message);
    }
  });
};

Parse.Cloud.afterSave("Listing", function(request) {
  //Convert Parse.Object to JSON
  var parseObject = request.object.toJSON();

  //Override Algolia object ID with the Parse.Object unique ID
  parseObject.objectID = parseObject.objectId;

  //Add new index (if no matching parseObject.objectID) or update
  index.saveObject(parseObject, function(error, content) {
  	if (error)
  		console.log('Got an error: ' + content.message);
  });
});

Parse.Cloud.afterDelete('Listing', function(request) {
  //Get the Parse/Algolia objectId
  var objectId = request.object.id;

  //Remove the index from Algolia
  index.deleteObject(objectId, function(error, content) {
  	if (error)
  		console.log('Got an error: ' + content.message);
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
					alert: "New offer!"
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

});