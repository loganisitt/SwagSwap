package com.arrowhead.parseswagswap;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Fragment;
import android.content.DialogInterface;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;

import com.parse.ParseException;
import com.parse.ParseFile;
import com.parse.ParseImageView;
import com.parse.ParseObject;
import com.parse.ParseUser;
import com.parse.SaveCallback;

import java.util.ArrayList;
import java.util.List;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link Listinginfo.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link Listinginfo#newInstance} factory method to
 * create an instance of this fragment.
 */
public class Listinginfo extends Fragment {
    ParseImageView IMG;
    TextView tit;
    TextView Title;
    TextView des;
    TextView Description;
    TextView p;
    TextView price;
    TextView cate;
    TextView category;
    TextView offer;
    String temptit;
    String tempprice;
    String tempdes;
    ParseFile tempimg;
    private List<ParseObject> myListingtemp = new ArrayList<ParseObject>();

    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;

   /* *
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param //param1 Parameter 1.
     * @param //param2 Parameter 2.
     * @return A new instance of fragment Listinginfo.
     */
    // TODO: Rename and change types and number of parameters
    public static Listinginfo newInstance(String param1, String param2) {
        Listinginfo fragment = new Listinginfo();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }

    public Listinginfo() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        MainActivity activity = (MainActivity) getActivity();
        final ViewGroup actionBarLayout = (ViewGroup) activity.getLayoutInflater().inflate(
                R.layout.temp_actionbar,
                null);

        android.support.v7.app.ActionBar actionBar = activity.getSupportActionBar();

        actionBar.setDisplayShowHomeEnabled(false);
        actionBar.setDisplayShowTitleEnabled(false);
        actionBar.setDisplayShowCustomEnabled(true);
        actionBar.setCustomView(actionBarLayout);

        ImageButton actionbarbutton = (ImageButton) actionBarLayout.findViewById(R.id.backbtn);

        actionbarbutton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MainActivity activity1 = (MainActivity) getActivity();
                View actionBarLayout2 =  activity1.getLayoutInflater().inflate(
                        R.layout.main_bar,null);


                android.support.v7.app.ActionBar actionBar = activity1.getSupportActionBar();

                actionBar.setDisplayShowCustomEnabled(true);
                actionBar.setCustomView(actionBarLayout2);

                getActivity().getFragmentManager().beginTransaction().remove(Listinginfo.this).commit();
            }
        });




        //setHasOptionsMenu(true);
        if (getArguments() != null) {
            mParam1 = getArguments().getString(ARG_PARAM1);
            mParam2 = getArguments().getString(ARG_PARAM2);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_listing_info,container,false);
        IMG = (ParseImageView) v.findViewById(R.id.imageView);
        tit = (TextView) v.findViewById(R.id.textView);
        Title = (TextView) v.findViewById(R.id.textView2);
        des = (TextView) v.findViewById(R.id.textView3);
        Description = (TextView) v.findViewById(R.id.textView4);
        p = (TextView) v.findViewById(R.id.textView5);
        price = (TextView) v.findViewById(R.id.textView6);
        cate = (TextView) v.findViewById(R.id.textView7);
        category= (TextView) v.findViewById(R.id.textView8);
        offer = (Button) v.findViewById(R.id.button3);




        Title.setText(temptit);
        Description.setText(tempdes);
        price.setText(tempprice);
        category.setText("testing");
        IMG.setParseFile(tempimg);
        IMG.loadInBackground();


        offer.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final AlertDialog alertDialog = new AlertDialog.Builder(getActivity()).create();
                alertDialog.setTitle("Make Offer");


                final EditText edittext= new EditText(getActivity().getApplicationContext());
                alertDialog.setView(edittext);
                alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
// here you can add functions
                        Double Value = Double.parseDouble(String.valueOf(edittext.getText()));
                        ParseObject offertemp = ParseObject.create("Offer");
                        offertemp.put("listing", myListingtemp.get(0));
                        offertemp.put("Value", Value);
                        offertemp.put("bidder", ParseUser.getCurrentUser());
                        Log.d("LISTING!!!!",myListingtemp.get(0).getObjectId()+"!!!!!!!!!");
                        Log.d("VALUE!!!!", Value+"!!!!!!!!!");
                        Log.d("BIDDER!!!!",ParseUser.getCurrentUser().getObjectId()+"!!!!!!!!!");

                        offertemp.saveInBackground(new SaveCallback() {
                            @Override
                            public void done(ParseException e) {
                                if(e == null){

                                    Log.d("MADE OFFER!!!!","OFFER WORKS!!!!!!!!!");

                                }
                                else{
                                    Log.d("MADE NOT OFFER!!!!","OFFER NOT WORKS!!!!!!!!!");
                                    System.out.print("THIS IS THE ERROR!!!!!! "+e);
                                }
                            }
                        });
                    }
                });
                alertDialog.setIcon(R.drawable.ic_launcher);
                alertDialog.show();


            }
        });

        return v;
    }

    public void setPobject(ParseObject temp){
        myListingtemp.add(temp);

    }

    public void setinfo(String t, Number p,String Des,List<ParseFile> img){
        Log.d("TITLE!!!!!!!!", t);
        temptit = t;
        tempdes = Des;
        tempprice = String.valueOf(p);

        if (img != null) {
            tempimg = img.get(0);

        }


    }
    // TODO: Rename method, update argument and hook method into UI event
    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        try {
            mListener = (OnFragmentInteractionListener) activity;
        } catch (ClassCastException e) {
            throw new ClassCastException(activity.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }

    /*@Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }*/

    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p/>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnFragmentInteractionListener {
        // TODO: Update argument type and name
        public void onFragmentInteraction(Uri uri);
    }
   /* public void onPrepareOptionsMenu(Menu menu){
        super.onPrepareOptionsMenu(menu);

        MenuItem item3  = menu.findItem(R.id.back_arrow);

        item3.setVisible(true);

    }
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
       // getActivity().getFragmentManager().beginTransaction().remove(Listinginfo.this).commit();
        return super.onOptionsItemSelected(item);
    }*/

}
