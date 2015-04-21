package com.arrowhead.parseswagswap;

import android.app.Application;
import android.content.Context;
import android.test.ApplicationTestCase;

import com.parse.Parse;
import com.parse.ParseFacebookUtils;

/**
 * <a href="http://d.android.com/tools/testing/testing_android.html">Testing Fundamentals</a>
 */
public class ApplicationTest extends ApplicationTestCase<Application> {
    public ApplicationTest() {

        super(Application.class);
        Context context = getContext();

        Parse.initialize(context, "FYYc6l6Fi8XTNiH0lybpzsob6tZcTd8luLDiZR1l",
                "smiuvnfGa8CW8H5radVT8TZcy7OOU3HR4PrWIOgF");
        ParseFacebookUtils.initialize("742900129109809");


    }
}