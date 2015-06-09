package com.arrowhead.dropswagswap;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.login.widget.LoginButton;

import java.util.Arrays;
import java.util.Collection;


public class MainActivity extends ActionBarActivity {
    CallbackManager callbackManager;

    private boolean logged_in = false;
    Intent in;
    public String fbname;
    public String fbid;
    public String fbtoken;
    public String fbemail;
    String baseUrl = "http://192.168.0.100:8080";
            //"http://10.132.33.139:8080";

    LoginButton fbtn;
    TextView txt;
    private Thread thread;

    LoginManager loginManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        FacebookSdk.sdkInitialize(getApplicationContext());
        setContentView(R.layout.activity_main);

        callbackManager = CallbackManager.Factory.create();

        fbtn = (LoginButton) findViewById(R.id.fbtn);
        txt = (TextView) findViewById(R.id.txt1);

        /*fbtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (logged_in == false) {
                    start();
                    thread = new Thread() {
                        @Override
                        public void run() {
                            try {
                                synchronized (this) {
                                    wait(10000);
                                    vlogin();
                                }
                            } catch (InterruptedException ex) {
                            }


                        }
                    };

                    thread.start();


                   /* if (logged_in == true) {
                        vlogin();
                    }
                } else {

                }*/
        fbtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                fblogin();
            }
        });


    }

    public  void fblogin(){

        loginManager = LoginManager.getInstance();

        loginManager.registerCallback(callbackManager,
                new FacebookCallback<LoginResult>() {
                    @Override
                    public void onSuccess(LoginResult loginResult) {
                        fbtoken = loginResult.getAccessToken().getToken();
                        fbid = loginResult.getAccessToken().getUserId();
                        // App code
                        //Toast.makeText(getApplicationContext(), loginResult.getAccessToken().toString(), Toast.LENGTH_SHORT).show();
                        String url = baseUrl + "/auth/facebook?access_token=" + fbtoken;

                        // Instantiate the RequestQueue.
                        RequestQueue queue = Volley.newRequestQueue(getApplicationContext());
                        //String url ="http://www.google.com";

// Request a string response from the provided URL.
                        StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                                new Response.Listener<String>() {
                                    @Override
                                    public void onResponse(String response) {
                                        // Display the first 500 characters of the response string.
                                        System.out.print("Response is!!!!!!: " + response.substring(0, 300));
                                        //logged_in = true;
                                        txt.setText("LOGGED IN");
                                        in = new Intent(MainActivity.this, MainActivity2.class);
                                        Bundle bundle = new Bundle();

//Add your data to bundle
                                        // bundle.putString("name", fbname);
                                        bundle.putString("id", fbid);
                                        // bundle.putString("email", fbemail);
                                         bundle.putString("token", fbtoken);

                                        in.putExtras(bundle);
                                        startActivity(in);
                                        // in.putExtra("name",fbname);
                                        // in.putExtra("id",fbid);
                                        // in.putExtra("email",fbemail);
                                        // in.putExtra("token",fbtoken);


                                    }
                                }, new Response.ErrorListener() {
                            @Override
                            public void onErrorResponse(VolleyError error) {
                                txt.setText("That didn't work!");
                                //logged_in = false;
                            }
                        });
// Add the request to the RequestQueue.
                        queue.add(stringRequest);
                    }

                    @Override
                    public void onCancel() {
                        // App code
                    }

                    @Override
                    public void onError(FacebookException exception) {
                        // App code
                    }
                });

        Collection<String> permissions = Arrays.asList("public_profile", "user_friends");

        loginManager.logInWithReadPermissions(this, permissions); // Null Pointer Exception here
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
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        callbackManager.onActivityResult(requestCode, resultCode, data);
    }
}
       /* fbtn.setReadPermissions(Arrays.asList("public_profile, email, user_birthday"));
        fbtn.registerCallback(callbackManager, new FacebookCallback<LoginResult>() {
            @Override
            public void onSuccess(final LoginResult loginResult) {
                GraphRequest request = GraphRequest.newMeRequest(
                        loginResult.getAccessToken(),
                        new GraphRequest.GraphJSONObjectCallback() {
                            @Override
                            public void onCompleted(
                                    JSONObject object,
                                    GraphResponse response) {
                                // Application code
                                Log.v("LoginActivity", response.toString());
                                try {
                                    Log.v("TEST!!!!!!", object.getString("name"));
                                    Log.v("TEST!!!!!!", object.getString("id"));
                                    Log.v("TEST!!!!!!", object.getString("email"));
                                    Log.v("TEST!!!!!!", object.getString("token"));
                                    fbname = object.getString("name");
                                    fbid = object.getString("id");
                                    // fbtoken = object.getString("token");
                                    fbemail = object.getString("email");
                                    fbtoken = "" + loginResult.getAccessToken().getToken();

                                    // tempuser.setUser(fbid,fbname,fbemail,fbtoken);

                                    logged_in = true;
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }


                            }
                        });
                Bundle parameters = new Bundle();
                parameters.putString("fields", "id,name,email");
                request.setParameters(parameters);
                request.executeAsync();

                 fbtoken = loginResult.getAccessToken().getToken();

//                tempuser.setUser(fbid,fbname,fbemail,fbtoken);
                logged_in = true;
                // return logged_in;

                String url = baseUrl + "/auth/facebook?access_token=" + fbtoken;

                // Instantiate the RequestQueue.
                RequestQueue queue = Volley.newRequestQueue(getApplicationContext());
                //String url ="http://www.google.com";

// Request a string response from the provided URL.
                StringRequest stringRequest = new StringRequest(Request.Method.POST, url,
                        new Response.Listener<String>() {
                            @Override
                            public void onResponse(String response) {
                                // Display the first 500 characters of the response string.
                                System.out.print("Response is!!!!!!: " + response.substring(0, 300));
                                //logged_in = true;
                                txt.setText("LOGGED IN");
                                in = new Intent(MainActivity.this, MainActivity2.class);
                                Bundle bundle = new Bundle();

//Add your data to bundle
                                bundle.putString("name", fbname);
                                bundle.putString("id", fbid);
                                bundle.putString("email", fbemail);
                                bundle.putString("token", fbtoken);

                                in.putExtras(bundle);
                                startActivity(in);
                                // in.putExtra("name",fbname);
                                // in.putExtra("id",fbid);
                                // in.putExtra("email",fbemail);
                                // in.putExtra("token",fbtoken);


                            }
                        }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        txt.setText("That didn't work!");
                        //logged_in = false;
                    }
                });
// Add the request to the RequestQueue.
                queue.add(stringRequest);
            }

            @Override
            public void onCancel() {

            }

            @Override
            public void onError(FacebookException error) {

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
}
*/












