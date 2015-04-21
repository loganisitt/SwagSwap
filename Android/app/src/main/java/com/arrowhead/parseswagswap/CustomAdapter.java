package com.arrowhead.parseswagswap;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.parse.ParseFile;
import com.parse.ParseImageView;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseQueryAdapter;
import com.parse.ParseUser;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Miguel on 3/30/2015.
 */

    public class CustomAdapter extends ParseQueryAdapter<ParseObject> {
    public List<ParseObject>adapterListing = new ArrayList<ParseObject>();


        public CustomAdapter(Context context) {

            // Use the QueryFactory to construct a PQA that will only show
            // Todos marked as high-pri

            super(context, new ParseQueryAdapter.QueryFactory<ParseObject>() {

                public ParseQuery create() {

                    ParseQuery query = new ParseQuery("Listing");
                    query.orderByDescending("createdAt");
                    query.whereNotEqualTo("seller", ParseUser.getCurrentUser());



                    // query.whereNotEqualTo("price", 0);
                    return query;
                }
            });
        }


        // Customize the layout by overriding getItemView
        @Override
        public View getItemView(ParseObject object, View v, ViewGroup parent) {
            if (v == null) {
                v = View.inflate(getContext(), R.layout.listing_view, null);
            }

            super.getItemView(object, v, parent);


            // Add and download the image
            final ParseImageView todoImage = (ParseImageView) v.findViewById(R.id.listing_image);
            List<ParseFile> imageFile = object.getList("images");

            //imageFile.get(0)

            if (imageFile != null) {
                todoImage.setParseFile(imageFile.get(0));
                todoImage.loadInBackground();
            }





            // Add the title view
            TextView titleTextView = (TextView) v.findViewById(R.id.listing_title);
            titleTextView.setText(object.getString("name"));

            // Add a reminder of how long this item has been outstanding
            TextView priceView = (TextView) v.findViewById(R.id.listing_price);
            priceView.setText(String.valueOf(object.getDouble("price")));
            String des = object.getString("desc");
            String seller = String.valueOf(object.getParseUser("seller"));
               ParseObject temp = ParseObject.create("Listing");
                temp.put("name",titleTextView.getText());
            temp.put("desc",des);
            temp.put("price",priceView.getText());
            temp.put("seller",seller);
            temp.put("images",imageFile.get(0));

                adapterListing.add(temp);
            return v;
        }


}
