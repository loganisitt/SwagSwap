package com.arrowhead.parseswagswap;

import com.parse.ParseObject;
import com.parse.ParseUser;

import java.io.Serializable;
import java.util.HashMap;

/**
 * Created by Miguel on 4/8/2015.
 */

    public class ParseProxyObject extends ParseObject implements Serializable {

        private static final long serialVersionUID = 1L;
        private HashMap<String, Object> values = new HashMap<String, Object>();

        public HashMap<String, Object> getValues() {
            return values;
        }

        public void setValues(HashMap<String, Object> values) {
            this.values = values;
        }

        public ParseProxyObject(ParseObject object) {

            // Loop the keys in the ParseObject
            for(String key : object.keySet()) {
                @SuppressWarnings("rawtypes")
                Class classType = object.get(key).getClass();
                if(classType == byte[].class || classType == String.class ||
                        classType == Integer.class || classType == Boolean.class) {
                    values.put(key, object.get(key));
                } else if(classType == ParseUser.class) {
                    ParseProxyObject parseUserObject = new ParseProxyObject((ParseObject)object.get(key));
                    values.put(key, parseUserObject);
                } else {
                    // You might want to add more conditions here, for embedded ParseObject, ParseFile, etc.
                }
            }
        }

        public String getString(String key) {
            if(has(key)) {
                return (String) values.get(key);
            } else {
                return "";
            }
        }

        public int getInt(String key) {
            if(has(key)) {
                return (Integer)values.get(key);
            } else {
                return 0;
            }
        }

        public boolean getBoolean(String key) {
            if(has(key)) {
                return (Boolean)values.get(key);
            } else {
                return false;
            }
        }

        public byte[] getBytes(String key) {
            if(has(key)) {
                return (byte[])values.get(key);
            } else {
                return new byte[0];
            }
        }

        public ParseUser getParseUser(String key) {
            if(has(key)) {
                return (ParseUser) values.get(key);
            } else {
                return null;
            }
        }

        public boolean has(String key) {
            return values.containsKey(key);
        }
    }

