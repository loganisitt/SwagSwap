package com.arrowhead.parseswagswap;

import android.content.Context;
import android.content.Intent;

import com.parse.ParseBroadcastReceiver;

/**
 * Created by Miguel on 4/18/2015.
 */
public class ParseBroadcastReciever extends ParseBroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        context.startActivity(new Intent(context, MainActivity.class));
    }
}
