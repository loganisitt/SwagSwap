package com.arrowhead.parseswagswap;

import android.app.Fragment;
import android.app.FragmentManager;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.parse.Parse;
import com.parse.ParseFacebookUtils;
import com.parse.ParseUser;
import com.parse.ui.ParseLoginBuilder;
import com.software.shell.fab.ActionButton;

import java.util.ArrayList;
import java.util.List;

import it.sephiroth.android.library.widget.AdapterView;
import it.sephiroth.android.library.widget.HListView;


public class MainActivity extends ActionBarActivity implements CreateListing.OnFragmentInteractionListener {
    private CreateListing CLfrag;
    private List<Listing> myListing = new ArrayList<Listing>();
    private boolean madelisting = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        final ActionButton actionButton = (ActionButton) findViewById(R.id.action_button);
        actionButton.setButtonColor(getResources().getColor(R.color.fab_material_red_500));
        actionButton.setImageResource(R.drawable.fab_plus_icon);

        Parse.initialize(this, getString(R.string.parse_app_id),
                getString(R.string.parse_client_key));
        ParseFacebookUtils.initialize(getString(R.string.facebook_app_id));

        ParseLoginBuilder builder = new ParseLoginBuilder(MainActivity.this);
        startActivityForResult(builder.build(), 0);

        ParseUser CurrentUser = ParseUser.getCurrentUser();

       // populateListingView();
        //registerclickcallback();





        actionButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                CLfrag = new CreateListing();

                //Now you can set the fragment to be visible here
                setFragment(CLfrag);

               // madelisting = true;

               /* myListing.add(CLfrag.getListingContent());
                populateListingView();
                registerclickcallback();*/

            }
        });
        /*if(madelisting == true){
            myListing.add(CLfrag.getListingContent());
            populateListingView();
            registerclickcallback();

        }*/


        /*ActionButton.State state = actionButton.getState();

        if(state == ActionButton.State.PRESSED){
            actionButton.setState(ActionButton.State.NORMAL);
            CLfrag = new CreateListing();

            //Now you can set the fragment to be visible here
            setFragment(CLfrag);

        }*/
    }



public void getlisting(){

    myListing.add(CLfrag.getListingContent());
}
    public void populateListingView() {
        ArrayAdapter<Listing> adapter = new MyListAdapter();
       HListView Scroll = (HListView) findViewById(R.id.listView);
        Scroll.setAdapter(adapter);
    }

    public void setFragment(Fragment frag)
    {
        FragmentManager fm = getFragmentManager();
        if (fm.findFragmentById(R.id.action_bar_container) == null) {
            fm.beginTransaction().add(R.id.action_bar_container, frag).commit();
        }

    }
    public void registerclickcallback() {

        HListView list = (HListView) findViewById(R.id.listView);
        list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View viewClicked, int position, long id) {

            }

        });

    }



    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onFragmentInteraction(Uri uri) {

    }

    private class MyListAdapter extends ArrayAdapter<Listing> {
        public MyListAdapter(){
            super(MainActivity.this,R.layout.listing_view,myListing);
        }

        @Override
        public View getView(int position,View convertView,ViewGroup parent){
            View itemView = convertView;
            if(itemView == null){
                itemView = getLayoutInflater().inflate(R.layout.listing_view,parent,false);

            }

            Listing currentListing = myListing.get(position);

            ImageView imgview = (ImageView) itemView.findViewById(R.id.listing_image);
            imgview.setImageDrawable(currentListing.getImage());

            TextView title = (TextView) itemView.findViewById(R.id.listing_title);
            title.setText(currentListing.getTitle());

            TextView price = (TextView) itemView.findViewById(R.id.listing_price);
            price.setText("$"+(currentListing.getPrice()));

            return itemView;


            //return super.getView(position,convertView,parent);
        }
    }
}
