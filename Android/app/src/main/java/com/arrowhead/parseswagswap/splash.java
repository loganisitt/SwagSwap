package com.arrowhead.parseswagswap;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;

import com.parse.Parse;
import com.parse.ParseFacebookUtils;
import com.parse.ParseUser;
import com.parse.ui.ParseLoginBuilder;


public class splash extends ActionBarActivity {
    ParseUser currentuser;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);

        Parse.initialize(this, getString(R.string.parse_app_id),
                getString(R.string.parse_client_key));
        ParseFacebookUtils.initialize(getString(R.string.facebook_app_id));



        ParseLoginBuilder builder = new ParseLoginBuilder(splash.this);

        startActivityForResult(builder.build(),0 );






       // <action android:name="android.intent.action.BOOT_COMPLETED" />
     //   <action android:name="android.intent.action.USER_PRESENT" />




    }
    @Override
    public void onStart(){
        super.onStart();

         currentuser = ParseUser.getCurrentUser();
        if(currentuser != null) {
            Intent in = new Intent(this, MainActivity.class);
            startActivity(in);
        }
        else{


            }

        }



public void jump(){

    Intent in = new Intent(this, MainActivity.class);
    startActivity(in);
}

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_splash, menu);
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
}
