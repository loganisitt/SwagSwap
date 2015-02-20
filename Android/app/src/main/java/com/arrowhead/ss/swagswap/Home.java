package com.arrowhead.ss.swagswap;

//  Created by Miguel Morales on 2/5/15.
//  Copyright (c) 2014 MiguelMorales. All rights reserved.
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBarDrawerToggle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.facebook.Session;


public class Home extends ActionBarActivity implements AdapterView.OnItemClickListener {
private DrawerLayout drawerLayout;
    private ListView listView;
    private MyAdapter myAdapter;

    private ActionBarDrawerToggle drawerListner;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);



        drawerLayout= (DrawerLayout) findViewById(R.id.drawerLayout);
        listView = (ListView) findViewById(R.id.drawerList);

        myAdapter = new MyAdapter(this);
        listView.setAdapter(myAdapter);
        listView.setOnItemClickListener(this);
        drawerListner = new ActionBarDrawerToggle(this,drawerLayout,R.string.drawer_open,R.string.drawer_close){
            @Override
            public void onDrawerOpened(View drawerView) {
                super.onDrawerOpened(drawerView);
            }

            @Override
            public void onDrawerClosed(View drawerView) {
                super.onDrawerClosed(drawerView);
            }
        };
        drawerLayout.setDrawerListener(drawerListner);
        getSupportActionBar().setHomeButtonEnabled(true);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

    }
    @Override
    public void onConfigurationChanged(Configuration newConfig){
        super.onConfigurationChanged(newConfig);
        drawerListner.onConfigurationChanged(newConfig);


}
    @Override
    protected void onPostCreate(Bundle savedInstanceState){

        super.onPostCreate(savedInstanceState);
        drawerListner.syncState();
}


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_home, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        if(drawerListner.onOptionsItemSelected(item)){
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        //Toast.makeText(this,NAV_ITEMS[position]+" was selected ",Toast.LENGTH_LONG).show();
        selectItem(position);
    }
    public void selectItem(int position){

        listView.setItemChecked(position,true);
        if(position == 7){

            logout();
        }
        //setTitle(NAV_ITEMS[position]);
    }

    public void setTitle(String title){

        getSupportActionBar().setTitle(title);
    }
    private void logout(){
        // find the active session which can only be facebook in my app
        Session session = Session.getActiveSession();
        // run the closeAndClearTokenInformation which does the following
        // DOCS : Closes the local in-memory Session object and clears any persistent
        // cache related to the Session.
        session.closeAndClearTokenInformation();
        // return the user to the login screen
        startActivity(new Intent(getApplicationContext(), MainActivity.class));
        // make sure the user can not access the page after he/she is logged out
        // clear the activity stack
        finish();
    }
}
class MyAdapter extends BaseAdapter{
    private Context context;
    String[] NAV_ITEMS;

    int[] images =  {R.drawable.home,R.drawable.browse,R.drawable.watching,
    R.drawable.account,R.drawable.inbox,R.drawable.settings
    ,R.drawable.help,R.drawable.signout};


    MyAdapter(Context context) {
        this.context = context;
        NAV_ITEMS = context.getResources().getStringArray(R.array.Nav_drawer_items);
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
            row = inflater.inflate(R.layout.custom_row,parent,false);

        }
        else{
            row = convertView;


        }
        TextView titleTextView=(TextView)row.findViewById(R.id.textView1);
        ImageView titleImageView = (ImageView) row.findViewById(R.id.imageView1);
        titleTextView.setText(NAV_ITEMS[position]);
        titleImageView.setImageResource(images[position]);
        return row;
    }
}
