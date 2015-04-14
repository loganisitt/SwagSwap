package com.arrowhead.parseswagswap;

import android.app.Fragment;
import android.app.FragmentManager;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

import com.parse.Parse;
import com.parse.ParseFacebookUtils;
import com.parse.ParseFile;
import com.parse.ParseObject;
import com.parse.ParseQueryAdapter;
import com.parse.ui.ParseLoginBuilder;
import com.software.shell.fab.ActionButton;

import java.util.ArrayList;
import java.util.List;

import it.sephiroth.android.library.widget.AdapterView;
import it.sephiroth.android.library.widget.HListView;


public class MainActivity extends ActionBarActivity implements CreateListing.OnFragmentInteractionListener,Listinginfo.OnFragmentInteractionListener ,AdapterView.OnItemClickListener {
    private CreateListing CLfrag;
    private Listinginfo infofrag;
    private List<ParseObject> myListing = new ArrayList<ParseObject>();
    private boolean madelisting = false;
    private HListView Scroll;
    private CustomAdapter urgentTodosAdapter;
    ParseObject temp;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        final ActionButton actionButton = (ActionButton) findViewById(R.id.action_button);
        actionButton.setButtonColor(getResources().getColor(R.color.fab_material_red_500));
        actionButton.setImageResource(R.drawable.fab_plus_icon);

        ParseObject.registerSubclass(Listing.class);

        Parse.initialize(this, getString(R.string.parse_app_id),
                getString(R.string.parse_client_key));
        ParseFacebookUtils.initialize(getString(R.string.facebook_app_id));

        //ParseInstallation install = ParseInstallation.getCurrentInstallation();


        ParseLoginBuilder builder = new ParseLoginBuilder(MainActivity.this);
        startActivityForResult(builder.build(), 0);




        android.support.v7.app.ActionBar bar = getSupportActionBar();
        bar.setBackgroundDrawable(new ColorDrawable(Color.parseColor("#CE002B")));


        populateListingView();
        Scroll.setOnItemClickListener(this);





        actionButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                CLfrag = new CreateListing();


                setFragment(CLfrag);


            }
        });



    }

    public void saveListing(Listing temp){

        myListing.add(temp);
    }



    public void selectItem(int position){


       Scroll.setItemChecked(position, true);
        Log.d("Listing Position", String.valueOf(position));
        Log.d("Actual Lisiting position", String.valueOf(myListing.size()));
        temp = myListing.get(position);

        Log.d("TEMP INFO!!!!!!!!!!",temp.getString("name"));
        Log.d("TEMP INFO",""+temp.getDouble("price"));
        Log.d("TEMP INFO",""+temp.getParseFile("images"));

        infofrag = new Listinginfo();
        List<ParseFile> IMG = temp.getList("images");

        infofrag.setPobject(temp);


      infofrag.setinfo(temp.getString("name"),(temp.getDouble("price")),temp.getString("desc"),IMG);


        setFragment(infofrag);








        //setTitle(NAV_ITEMS[position]);
    }

    public ParseObject getTemp(){
        return temp;
    }

    public void populateListingView() {
        ParseQueryAdapter<ParseObject> mainAdapter = new ParseQueryAdapter<ParseObject>(this, "Listing");
        mainAdapter.setTextKey("names");



        urgentTodosAdapter = new CustomAdapter(this);
        urgentTodosAdapter.setTextKey("names");


         Scroll = (HListView) findViewById(R.id.listView);

        Scroll.setAdapter(urgentTodosAdapter);
       urgentTodosAdapter.loadObjects();
        myListing.clear();
        urgentTodosAdapter.addOnQueryLoadListener(new ParseQueryAdapter.OnQueryLoadListener<ParseObject>() {
            @Override
            public void onLoading() {

            }

            @Override
            public void onLoaded(List<ParseObject> objects, Exception e) {
                for(int i = 0; i < objects.size();i++){
                    myListing.add(objects.get(i));
                }

            }
        });




    }

    public void setFragment(Fragment frag) {
        FragmentManager fm = getFragmentManager();
        if (fm.findFragmentById(R.id.action_bar_container) == null) {
            fm.beginTransaction().add(R.id.action_bar_container, frag).commit();
        }

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


    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {


        selectItem(i);
    }
    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
        super.onPrepareOptionsMenu(menu);

        MenuItem item3  = menu.findItem(R.id.back_arrow);
        item3.setVisible(false);
        return false;
    }

}



