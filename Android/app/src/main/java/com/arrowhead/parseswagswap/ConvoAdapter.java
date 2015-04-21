package com.arrowhead.parseswagswap;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseQueryAdapter;
import com.parse.ParseUser;

/**
 * Created by Miguel on 4/21/2015.
 */
public class ConvoAdapter extends ParseQueryAdapter<ParseObject> {

    public ConvoAdapter(Context context,  final ParseUser seller) {

        // Use the QueryFactory to construct a PQA that will only show
        // Todos marked as high-pri

        super(context, new ParseQueryAdapter.QueryFactory<ParseObject>() {

            public ParseQuery create() {

                ParseQuery query = new ParseQuery("Message");
                query.orderByAscending("createdAt");
                query.whereEqualTo("recipient", ParseUser.getCurrentUser());
                query.whereEqualTo("sender",seller);
                query.whereEqualTo("recipient",seller);
                query.whereEqualTo("sender",ParseUser.getCurrentUser());

                // query.whereNotEqualTo("price", 0);
                return query;

            }
        });

    }




    // Customize the layout by overriding getItemView
    @Override
    public View getItemView(ParseObject object, View v, ViewGroup parent) {
        if (v == null) {
            v = View.inflate(getContext(), R.layout.convo, null);
        }

        super.getItemView(object, v, parent);


        // Add and download the image
        //final ParseImageView todoImage = (ParseImageView) v.findViewById(R.id.listing_image);
        // List<ParseFile> imageFile = object.getList("images");

        //imageFile.get(0)




        // Add the title view
        final TextView titleTextView = (TextView) v.findViewById(R.id.textView18);
       // final ParseImageView pro = (ParseImageView) v.findViewById(R.id.pro_pic);
        // titleTextView.setText(object.getString("sender"));
       titleTextView.setText(object.getString("content"));



        return v;
    }

}

