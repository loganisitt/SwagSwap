package com.arrowhead.dropswagswap;

import java.util.Map;

/**
 * Created by Miguel on 6/3/2015.
 */


public class Listing {

    private User seller;
    private String name;
    private String description;
    private String category;
    private Number price;
    private String imagepath;

    public Listing() {

    }

    public void setListing(User seller,String name,String des,String cate,Number price,String img){
        this.seller = seller;
        this.name = name;
        this.description = des;
        this.category = cate;
        this.price = price;
        this.imagepath = img;

    }

    public void mapper(Map map){



    }
}

