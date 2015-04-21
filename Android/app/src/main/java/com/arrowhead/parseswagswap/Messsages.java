package com.arrowhead.parseswagswap;

import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentTransaction;
import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link Messsages.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link Messsages#newInstance} factory method to
 * create an instance of this fragment.
 */
public class Messsages extends Fragment {
    private ListView messages;
    private MessageAdapter  messageAdapter;
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment Messsages.
     */
    // TODO: Rename and change types and number of parameters
    public static Messsages newInstance(String param1, String param2) {
        Messsages fragment = new Messsages();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }

    public Messsages() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        MainActivity activity = (MainActivity) getActivity();
        View actionBarLayout =  activity.getLayoutInflater().inflate(
                R.layout.seller_bar,null);

        android.support.v7.app.ActionBar actionBar = activity.getSupportActionBar();

        TextView title = (TextView) actionBarLayout.findViewById(R.id.textView15);

        title.setText("Messages");



        // actionBar.setDisplayShowHomeEnabled(false);

        //actionBar.setDisplayShowTitleEnabled(false);
        actionBar.setDisplayShowCustomEnabled(true);

        actionBar.setCustomView(actionBarLayout);

        ImageButton button = (ImageButton) actionBarLayout.findViewById(R.id.sellerback);
        ImageButton button2 = (ImageButton) actionBarLayout.findViewById(R.id.addlisting);

        Log.d("TESTING!!!!!!!!!", "BEFORE ONCLICK TEST!!!!!!!!!!!!!!!!!");

        button2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //CLfrag = new CreateListing();
                //MainActivity activity = (MainActivity) getActivity();
                //View actionBarLayout =  activity.getLayoutInflater().inflate(
                // R.layout.fragment_create_listing,null);

                // FragmentManager fragmentManager = getFragmentManager();
                //FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                final FragmentTransaction transaction = getFragmentManager().beginTransaction();
                // Fragment transaction = getChildFragmentManager().findFragmentById(R.id.sellerview);
                //noinspection ConstantConditions
               // transaction.replace(((ViewGroup)getView().getParent()).getId(),CLfrag);

                //transaction.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_OPEN);
                //transaction.addToBackStack(null);
                //transaction.commit();
//                getFragmentManager().executePendingTransactions();

                //setTargetFragment(CLfrag,0);

                Log.d("TESTING!!!!!!!!!!","ADD BUTTON TEST!!!!!!!");

                //Fragment transaction = getChildFragmentManager().findFragmentById(R.id.sellerview);
                //transaction.add(R.layout.fragment_create_listing, CLfrag).commit();
            }
        });

        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MainActivity activity1 = (MainActivity) getActivity();
                View actionBarLayout2 =  activity1.getLayoutInflater().inflate(
                        R.layout.main_bar,null);


                android.support.v7.app.ActionBar actionBar = activity1.getSupportActionBar();

                actionBar.setDisplayShowCustomEnabled(true);
                actionBar.setCustomView(actionBarLayout2);


                getActivity().getFragmentManager().beginTransaction().remove(Messsages.this).commit();
            }
        });


        if (getArguments() != null) {
            mParam1 = getArguments().getString(ARG_PARAM1);
            mParam2 = getArguments().getString(ARG_PARAM2);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

       View v = inflater.inflate(R.layout.selling_view,container,false);
        v.setId(R.id.sellerview_id);

        messages = (ListView) v.findViewById(R.id.sellinglist);
        Context context = getActivity().getApplicationContext();
        messageAdapter = new MessageAdapter(context);

        messages.setAdapter(messageAdapter);

        messages.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                selectitem(position);
            }
        });
        // Inflate the layout for this fragment
        return v;
                //inflater.inflate(R.layout.fragment_messsages, container, false);
    }

    // TODO: Rename method, update argument and hook method into UI event
    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
    }

    public void selectitem(int position){


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

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

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



}
