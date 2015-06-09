package com.arrowhead.dropswagswap;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by Miguel on 6/3/2015.
 */
public class User {

    private String id;
    private String name;
    private String email;
    private String token;

    public User() {
        this.id = "";
        this.name = "";
        this.email = "";
        this.token = "";
    }
    public void newUser(User user){
        this.id = user.getId();
        this.name = user.getName();
        this.email = user.getEmail();
        this.token = user.getToken();


    }
    public void setUser(String id,String name,String email,String token){
        this.id = id;
        this.name = name;
        this.email = email;
        this.token = token;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getToken() {
        return token;
    }

    public JSONObject makejson(){

        JSONObject jb =new JSONObject();
        try {
            jb.put("id",this.id);
            jb.put("name",this.name);
            jb.put("email",this.email);
            jb.put("token",this.token);

        } catch (JSONException e) {
            e.printStackTrace();
        }
return jb;
    }
}
