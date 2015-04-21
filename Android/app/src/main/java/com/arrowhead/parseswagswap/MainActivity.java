package com.arrowhead.parseswagswap;

import android.app.Fragment;
import android.app.FragmentManager;
import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.parse.Parse;
import com.parse.ParseAnalytics;
import com.parse.ParseFacebookUtils;
import com.parse.ParseFile;
import com.parse.ParseObject;
import com.parse.ParseQueryAdapter;
import com.parse.PushService;

import java.util.ArrayList;
import java.util.List;

import it.sephiroth.android.library.widget.AdapterView;
import it.sephiroth.android.library.widget.HListView;


public class MainActivity extends ActionBarActivity implements CreateListing.OnFragmentInteractionListener,Listinginfo.OnFragmentInteractionListener ,SellingList.OnFragmentInteractionListener,AdapterView.OnItemClickListener, Messsages.OnFragmentInteractionListener {
    private CreateListing CLfrag;
    private Listinginfo infofrag;
    private Messsages messfrag;
    private SellingList SLfrag;
    private List<ParseObject> myListing = new ArrayList<ParseObject>();
    private boolean madelisting = false;
    private HListView Scroll;
    private ListView MENULIST;
    private MenuAdapter menuadpater;
    private CustomAdapter urgentTodosAdapter;
    ParseObject temp;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


       // final ActionButton actionButton = (ActionButton) findViewById(R.id.action_button);
       // actionButton.setButtonColor(getResources().getColor(R.color.fab_material_red_500));
       // actionButton.setImageResource(R.drawable.fab_plus_icon);

        ParseObject.registerSubclass(Listing.class);


        Parse.initialize(this, getString(R.string.parse_app_id),
                getString(R.string.parse_client_key));
        ParseFacebookUtils.initialize(getString(R.string.facebook_app_id));



        //ParseLoginBuilder builder = new ParseLoginBuilder(MainActivity.this);
        //startActivityForResult(builder.build(), 0);
        Context context = this.getApplicationContext();
        PushService.startServiceIfRequired(context);
        ParseAnalytics.trackAppOpenedInBackground(getIntent());





        android.support.v7.app.ActionBar bar = getSupportActionBar();
        bar.setBackgroundDrawable(new ColorDrawable(Color.parseColor("#CE002B")));

        View actionBarLayout2 =  getLayoutInflater().inflate(
                R.layout.main_bar,null);


        bar.setDisplayShowCustomEnabled(true);
        bar.setCustomView(actionBarLayout2);


        Scroll = (HListView) findViewById(R.id.listView);
        Scroll.setOnItemClickListener(this);

        MENULIST = (ListView) findViewById(R.id.menuList);
        MENULIST.setOnItemClickListener(new android.widget.AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(android.widget.AdapterView<?> parent, View view, int position, long id) {
                selectItem2(position);
            }
        });


        populateListingView();


        createmenu();




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


      infofrag.setinfo(temp.getString("name"),(temp.getDouble("price")),temp.getString("desc"),IMG,temp.getParseUser("seller"));


        setFragment(infofrag);


        //setTitle(NAV_ITEMS[position]);
    }

    public ParseObject getTemp(){
        return temp;
    }

    public void createmenu(){

       // MENULIST = (ListView) findViewById(R.id.menuList);


        Context context = getApplicationContext();
        menuadpater = new MenuAdapter(context);

        MENULIST.setAdapter(menuadpater);


    }

    public void populateListingView() {
        ParseQueryAdapter<ParseObject> mainAdapter = new ParseQueryAdapter<ParseObject>(this, "Listing");
        mainAdapter.setTextKey("names");



        urgentTodosAdapter = new CustomAdapter(this);
        urgentTodosAdapter.setTextKey("names");


         //Scroll = (HListView) findViewById(R.id.listView);

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



    public void selectItem2(int i){
    MENULIST.setItemChecked(i,true);

    if(i == 1){
        SLfrag = new SellingList();
        setFragment(SLfrag);

    }
    else if(i == 3){
        messfrag = new Messsages();
        setFragment(messfrag);
    }


}

    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {

            selectItem(i);
    }



    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
        super.onPrepareOptionsMenu(menu);

        MenuItem item3  = menu.findItem(R.id.back_arrow);
        //MenuItem item4 = menu.findItem(R.id.seller_back);
        //MenuItem item5 = menu.findItem(R.id.add_listing);

        item3.setVisible(false);
        //item4.setVisible(false);
        //item5.setVisible(false);

        return false;
    }



    public class MenuAdapter extends BaseAdapter {

        private Context context;
        String[] NAV_ITEMS ={"\uf07a","\uf02b","\uf06e","\uf01c","\uf0f3","\uf085"};

        String[] names = {"BUYING","SELLING","WATCHING","INBOX","NOTIFICATIONS","SETTINGS"};


        MenuAdapter(Context context) {
            this.context = context;

            //NAV_ITEMS = context.getResources().getStringArray(R.Nav_drawer_items);
            //ims = context.getResources().getIntArray(R.array.Nav_drawer_icons);
            // images[0] = setColorFilter(R.drawable.home);
        }

        @Override
        public int getCount() {
            return NAV_ITEMS.length;
        }

        @Override
        public Object getItem(int position) {
            return NAV_ITEMS[position];
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            View row = null;
            if(convertView== null){
                LayoutInflater inflater = (LayoutInflater)
                        context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                row = inflater.inflate(R.layout.menu_temp,parent,false);


            }
            else{
                row = convertView;


            }
           // MainActivity activity = null;
            //activity.font;
            Typeface font =  Typeface.createFromAsset(getAssets(), "font/fontawesome-webfont.ttf");
            TextView titleImageView=(TextView)row.findViewById(R.id.imgmenu);
            TextView titleTextView = (TextView) row.findViewById(R.id.menutxt);
            titleTextView.setText(names[position]);
            titleImageView.setTypeface(font);
            titleImageView.setText(NAV_ITEMS[position]);
            return row;
        }
    }

}



