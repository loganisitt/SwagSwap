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

import java.util.List;

/**
 * Created by Miguel on 4/14/2015.
 */
public class SellingAdapter extends ParseQueryAdapter<ParseObject> {

    public SellingAdapter(Context context) {

        // Use the QueryFactory to construct a PQA that will only show
        // Todos marked as high-pri

        super(context, new ParseQueryAdapter.QueryFactory<ParseObject>() {

            public ParseQuery create() {

                ParseQuery query = new ParseQuery("Listing");
                query.orderByDescending("createdAt");
                query.whereEqualTo("seller", ParseUser.getCurrentUser());


                // query.whereNotEqualTo("price", 0);
                return query;

            }
        });

    }




    // Customize the layout by overriding getItemView
    @Override
    public View getItemView(ParseObject object, View v, ViewGroup parent) {
        if (v == null) {
            v = View.inflate(getContext(), R.layout.selling_temp, null);
        }

        super.getItemView(object, v, parent);


        // Add and download the image
        final ParseImageView todoImage = (ParseImageView) v.findViewById(R.id.imageView3);
        List<ParseFile> imageFile = object.getList("images");




        todoImage.setParseFile(imageFile.get(0));
        todoImage.loadInBackground();

        // Add the title view
        TextView titleTextView = (TextView) v.findViewById(R.id.sellingtitle);
        titleTextView.setText(object.getString("name"));
        TextView titleTextView2 = (TextView) v.findViewById(R.id.sellingprice);
        titleTextView2.setText("$"+object.get("price"));

        return v;
    }

}
