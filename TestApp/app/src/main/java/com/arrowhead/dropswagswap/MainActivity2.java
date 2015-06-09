
package com.arrowhead.dropswagswap;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v7.app.ActionBarActivity;
import android.util.Base64;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;

import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;


public class MainActivity2 extends ActionBarActivity {

    private EditText title;
    private EditText description;
    private EditText price;

    private ImageView imgPreview;
    private Button btnCapturePicture;
    private Button createListing;

    public String fbname;
    public String fbid;
    public String fbtoken;
    public String fbemail;

    private File tempfile;

    public File imageFile;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_activity2);

        Bundle bundle = getIntent().getExtras();

//Extract the data…
        //fbname = bundle.getString("name");
        fbid = bundle.getString("id");
        fbtoken = bundle.getString("token");
        //fbemail = bundle.getString("email");
        //fbtoken = bundle.getString("token");

        //Log.v("GOT DATA!!!!!!!!", fbname);
        Log.v("GOT DATA!!!!!!!!", fbid);
        //Log.v("GOT DATA!!!!!!!!", fbemail);
        //Log.v("GOT DATA!!!!!!!!", fbtoken);

        imgPreview = (ImageView) findViewById(R.id.imgPreview);
        btnCapturePicture = (Button) findViewById(R.id.button);
        title = (EditText) findViewById(R.id.create_title);
        description = (EditText) findViewById(R.id.create_description);
        price = (EditText) findViewById(R.id.create_price);

        createListing = (Button) findViewById(R.id.button2);

        createListing.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setMyListing();

                //MainActivity activity = (MainActivity) getActivity();

                // activity.populateListingView();
                // activity.saveListing(myListing);

                // View actionBarLayout2 =  activity.getLayoutInflater().inflate(
                //         R.layout.main_bar,null);


                // android.support.v7.app.ActionBar actionBar = activity.getSupportActionBar();

                // actionBar.setDisplayShowCustomEnabled(true);
                //actionBar.setCustomView(actionBarLayout2);

                // getActivity().getFragmentManager().beginTransaction().remove(CreateListing.this).commit();
                // getActivity().getFragmentManager().beginTransaction().remove(SellingList.).commit();

            }
        });

        btnCapturePicture.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                selectImage();
            }
        });


    }

    private void selectImage() {

        final CharSequence[] options = {"Take Photo", "Choose from Gallery", "Cancel"};

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Add Photo!");
        builder.setItems(options, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int item) {
                if (options[item].equals("Take Photo")) {
                    Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                    File f = new File(android.os.Environment.getExternalStorageDirectory(), "temp.jpg");
                    intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(f));
                    startActivityForResult(intent, 1);
                } else if (options[item].equals("Choose from Gallery")) {
                    Intent intent = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                    startActivityForResult(intent, 2);

                } else if (options[item].equals("Cancel")) {
                    dialog.dismiss();
                }
            }
        });
        builder.show();
    }

    public static Bitmap rotateBitmap(Bitmap bitmap, int orientation) {

        Matrix matrix = new Matrix();
        switch (orientation) {
            case ExifInterface.ORIENTATION_NORMAL:
                return bitmap;
            case ExifInterface.ORIENTATION_FLIP_HORIZONTAL:
                matrix.setScale(-1, 1);
                break;
            case ExifInterface.ORIENTATION_ROTATE_180:
                matrix.setRotate(180);
                break;
            case ExifInterface.ORIENTATION_FLIP_VERTICAL:
                matrix.setRotate(180);
                matrix.postScale(-1, 1);
                break;
            case ExifInterface.ORIENTATION_TRANSPOSE:
                matrix.setRotate(90);
                matrix.postScale(-1, 1);
                break;
            case ExifInterface.ORIENTATION_ROTATE_90:
                matrix.setRotate(90);
                break;
            case ExifInterface.ORIENTATION_TRANSVERSE:
                matrix.setRotate(-90);
                matrix.postScale(-1, 1);
                break;
            case ExifInterface.ORIENTATION_ROTATE_270:
                matrix.setRotate(-90);
                break;
            default:
                return bitmap;
        }
        try {
            Bitmap bmRotated = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
            bitmap.recycle();
            return bmRotated;
        } catch (OutOfMemoryError e) {
            e.printStackTrace();
            return null;
        }

    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == 1) {
                File f = new File(Environment.getExternalStorageDirectory().toString());
                for (File temp : f.listFiles()) {
                    if (temp.getName().equals("temp.jpg")) {
                        f = temp;
                        break;
                    }
                }
                try {


                    Bitmap bitmap;

                    BitmapFactory.Options bitmapOptions = new BitmapFactory.Options();

                    bitmap = BitmapFactory.decodeFile(f.getAbsolutePath(),
                            bitmapOptions);
                        //file = f;

                    int nh = (int) (bitmap.getHeight() * (512.0 / bitmap.getWidth()));
                    bitmap = Bitmap.createScaledBitmap(bitmap, 512, nh, true);
                    ExifInterface exif = null;
                    try {
                        exif = new ExifInterface(f.getAbsolutePath());
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    int orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_UNDEFINED);

                    Bitmap bmRotated = rotateBitmap(bitmap, orientation);
                    imgPreview.setImageBitmap(bmRotated);

                    String path = android.os.Environment
                            .getExternalStorageDirectory()
                            + File.separator
                            + "Phoenix" + File.separator + "default";
                    f.delete();
                    OutputStream outFile = null;
                    File file = new File(path, String.valueOf(System.currentTimeMillis()) + ".jpg");
                    tempfile = file;

                    persistImage(bmRotated,String.valueOf(System.currentTimeMillis()));

                    try {
                        outFile = new FileOutputStream(file);
                        //ByteArrayOutputStream bos = new ByteArrayOutputStream();
                        bitmap.compress(Bitmap.CompressFormat.JPEG, 85, outFile);
                        //byte[] bitmapdata = bos.toByteArray();
                       // FileOutputStream fos = new FileOutputStream(tempfile);
                       // fos.write(bitmapdata);
                        outFile.flush();
                        outFile.close();
                    } catch (FileNotFoundException e) {
                        e.printStackTrace();
                    } catch (IOException e) {
                        e.printStackTrace();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else if (requestCode == 2) {


                Uri selectedImage = data.getData();
                String[] filePath = {MediaStore.Images.Media.DATA};
                Cursor c = this.getContentResolver().query(selectedImage, filePath, null, null, null);
                c.moveToFirst();
                int columnIndex = c.getColumnIndex(filePath[0]);
                String picturePath = c.getString(columnIndex);
                c.close();
                Bitmap thumbnail = (BitmapFactory.decodeFile(picturePath));
                //int nh = (int) (thumbnail.getHeight() * (512.0 / thumbnail.getWidth()));
                thumbnail = Bitmap.createScaledBitmap(thumbnail, 200, 200, true);
                ExifInterface exif = null;
                try {
                    exif = new ExifInterface(picturePath);
                } catch (IOException e) {
                    e.printStackTrace();
                }

                int orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_UNDEFINED);

                Bitmap bmRotated = rotateBitmap(thumbnail, orientation);
                imgPreview.setImageBitmap(bmRotated);


            }
        }
    }


    private void setMyListing() {
      final String  t2 = String.valueOf((title.getText()));
        final String   d = String.valueOf(description.getText());

        final double  p = Double.parseDouble(String.valueOf(price.getText()));
        Drawable img = imgPreview.getDrawable();
        Bitmap img2 = ((BitmapDrawable) img).getBitmap();

        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        //img2.reconfigure(20,20, Bitmap.Config.ARGB_8888);
       // final byte[] data = stream.toByteArray();

       // Bitmap img3 = Bitmap.createScaledBitmap(img2, 20, 20, true);
       // img3.compress(Bitmap.CompressFormat.PNG, 25, stream);
       // final byte[] data = stream.toByteArray();
        img2.compress(Bitmap.CompressFormat.PNG, 25, stream);
        final byte[] data = stream.toByteArray();

        final String data2 = stream.toString();

        final String data3 = Base64.encodeToString(data, Base64.DEFAULT);




        Log.v("TESTING DATA",t2);
        Log.v("TESTING DATA",d);
        Log.v("TESTING DATA",""+p);
        Log.v("TESTING DATA",data2);

        Log.v("TESTING DATA",fbid);
        String baseUrl = "http://192.168.0.100:8080";
        // "http://10.132.33.139:8080";

        //RequestQueue queue = Volley.newRequestQueue(this);
        String url = baseUrl+ "/api/listing";



        final JSONObject request=new JSONObject();
        try {
            request.put("seller", "556646cc2f534a380ec39d5c");
            request.put("name", t2);
            request.put("description", d);
            request.put("price", "" + p);
            request.put("image_paths",  data3);
            request.put("category", "test");
        } catch (JSONException e) {
            e.printStackTrace();
        }

        Map<String, String> jsonParams = new HashMap<String, String>();
        jsonParams.put("seller", "556646cc2f534a380ec39d5c");
        jsonParams.put("name", t2);
        jsonParams.put("description", d);
        jsonParams.put("price", "" + p);
        jsonParams.put("image_paths",  data3);
        jsonParams.put("category", "test");

        final RequestQueue queue = Volley.newRequestQueue(this);

        JsonObjectRequest jsonObjReq = new JsonObjectRequest(
                Request.Method.POST,url, request,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                       // Log.d(TAG, response.toString());

                        //msgResponse.setText(response.toString());
                        //hideProgressDialog();
                    }
                }, new Response.ErrorListener() {

            @Override
            public void onErrorResponse(VolleyError error) {
                //VolleyLog.d(TAG, "Error: " + error.getMessage());
                //hideProgressDialog();
                Log.v("ERRROR!!!!!!!!!", String.valueOf(error.networkResponse));
                Log.v("ERRROR!!!!!!!!!", error.toString());
            }
        }) {

            /**
             * Passing some request headers
             */
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                HashMap<String, String> headers = new HashMap<String, String>();
                headers.put("Content-Type", "application/json; charset=utf-8");
                return headers;
            }


        };
        jsonObjReq.setRetryPolicy(new DefaultRetryPolicy( 5000, 1, 1.0f));


            queue.add(jsonObjReq);



       /* JsonObjectRequest myRequest = new JsonObjectRequest(
                Request.Method.POST,
                url,
                new JSONObject(jsonParams),

                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        //verificationSuccess(response);
                        Log.v("RESPONSE",response.toString());
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        //verificationFailed(error);
                        Log.v("ERROR!!!!!!", error.toString());
                    }
                }) {

            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                HashMap<String, String> headers = new HashMap<String, String>();
                headers.put("Content-Type", "multipart/form-data;boundary=");
                headers.put( "charset", "utf-8");
                return headers;
            }
        };

        myRequest.setRetryPolicy(new DefaultRetryPolicy(
                30000,
                DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));*/
       // queue.add(myRequest);

        /*JsonObjectRequest jsObjRequest = new JsonObjectRequest(Request.Method.POST,url,request,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        //System.out.println(response);
                        Log.v("LISTING TEST","IT WORKS!!!!!!!!!!!");
                        //hideProgressDialog();
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Log.v("LISTING TEST","IT DOESNT WORKS!!!!!!!!!!!");
                       // hideProgressDialog();
                    }





                });
        queue.add(jsObjRequest);*/

        //add to the request queue
       // requestqueu.AddToRequestQueue(stringReq);

     /*  RequestQueue queue = Volley.newRequestQueue(this);
        StringRequest jsonObjRequest = new StringRequest(Request.Method.POST,
                url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {

                        Log.v("LISTING TEST","IT WORKS!!!!!!!!!!!");

                       // MyFunctions.toastShort(LoginActivity.this, response);
                    }
                }, new Response.ErrorListener() {

            @Override
            public void onErrorResponse(VolleyError error) {
                Log.v("LISTING TEST","IT DOENST WORKS!!!!!!!!!!!");
                //VolleyLog.d("volley", "Error: " + error.getMessage());
                //error.printStackTrace();
               // MyFunctions.croutonAlert(LoginActivity.this,
                //        MyFunctions.parseVolleyError(error));
                //loading.setVisibility(View.GONE);
            }
        }) {

            @Override
            public String getBodyContentType() {
                return "application/x-www-form-urlencoded; charset=UTF-8";
            }

            @Override
            protected Map<String, String> getParams() throws AuthFailureError {
                Map<String, String> params = new HashMap<String, String>();
                params.put("seller", "556646cc2f534a380ec39d5c");
                params.put("name", t2);
                params.put("description", d);
                params.put("price", "" + p);
                params.put("image_paths",  data3);
                params.put("category", "test");
                return params;
            }

        };

       queue.add(jsonObjRequest);*/

       // Response.Listener<JSONObject> reponseListener = null;
       // Response.ErrorListener errorListener = null;

       // RequestQueue requestQueue = Volley.newRequestQueue(this);
       // CustomRequest jsObjRequest = new CustomRequest(Request.Method.POST, url, params, reponseListener, errorListener);

       // requestQueue.add(jsObjRequest);
/*
        RequestQueue queue = Volley.newRequestQueue(this);
        JsonObjectRequest jsObjRequest = new JsonObjectRequest(
                Request.Method.POST,url,
                createUserMapperObejct(),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        //pd.dismiss();
                        Log.v("MAKING LISTING ", "IT WORKS!!!!!!!!!!!!!!!!");


                    }

    }, new Response.ErrorListener() {

        @Override
        public void onErrorResponse(VolleyError error) {
            Log.v("MAKING LISTING ", "IT DOESNT WORKS!!!!!!!!!!!!!!!!");
        }
    });
    queue.add(jsObjRequest);*/







        /*final ParseFile imgFile = new ParseFile("image.png",data);


        final ParseUser seller = ParseUser.getCurrentUser();

        //final Listing imageObj = new Listing();



        final ParseObject imageObj = ParseObject.create("Listing");
        //ParseObject category = ParseObject.create("Category");
        ParseQuery query = new ParseQuery("Category");

        query.getInBackground("1Ye9EYfXAo",new GetCallback() {
            @Override
            public void done(ParseObject parseObject, ParseException e) {
                imageObj.put("name", t2);
                imageObj.put("desc", d);
                imageObj.put("category", parseObject);
                imageObj.put("price", p);

                imageObj.put("seller", seller);


                try {
                    imgFile.save();
                } catch (ParseException e1) {
                    e1.printStackTrace();
                }


                //imageObj.put("images",imgFile);
                imageObj.add("images", imgFile);
                //imageObj.setDetails(t2,d,"testing",p,imgFile,seller);
                //imageObj.saveDetails();
                imageObj.saveInBackground();
                myListing = (Listing)imageObj;
            }
        });*/




    }
    private  void persistImage(Bitmap bitmap, String name) {
        File filesDir = getApplicationContext().getFilesDir();
         imageFile = new File(filesDir, name + ".jpg");

        OutputStream os;
        try {
            os = new FileOutputStream(imageFile);
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, os);
            os.flush();
            os.close();
        } catch (Exception e) {
            Log.e(getClass().getSimpleName(), "Error writing bitmap", e);
        }
    }






    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main_activity2, menu);
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