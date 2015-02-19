package com.arrowhead.ss.swagswap;


//  Created by Miguel Morales on 1/19/15.
//  Copyright (c) 2014 MiguelMorales. All rights reserved.

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.view.Menu;
import android.view.MenuItem;
public class MainActivity extends FragmentActivity {
    private MainFragment mainFragment;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        ////Un-comment to get your keyHash from LogCat, Make sure to change package name appropriately
        // try {
        // PackageInfo info = getPackageManager().getPackageInfo(
        // "com.code2care.demos.code2careDemo",
        // PackageManager.GET_SIGNATURES);
        // for (Signature signature : info.signatures) {
        // MessageDigest md = MessageDigest.getInstance("SHA");
        // md.update(signature.toByteArray());
        // System.out.println("KeyHash : "+ Base64.encodeToString(md.digest(),
        // Base64.DEFAULT));
        // }
        // } catch (NameNotFoundException e) {
        // } catch (NoSuchAlgorithmException e) {
        // }
        if (savedInstanceState == null) {
            // Add the fragment on initial activity setup
            mainFragment = new MainFragment();
            getSupportFragmentManager().beginTransaction()
                    .add(android.R.id.content, mainFragment).commit();
        } else {
            // Or set the fragment from restored state info
            mainFragment = (MainFragment) getSupportFragmentManager()
                    .findFragmentById(android.R.id.content);
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
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}