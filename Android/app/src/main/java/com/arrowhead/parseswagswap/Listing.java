package com.arrowhead.parseswagswap;

import android.graphics.drawable.Drawable;

/**
 * Created by Miguel on 3/24/2015.
 */
public class Listing {
    private String Title;
    private String Description;
    private double Price;
    private Drawable Image;

    public Listing(String title,String description,double price,Drawable image) {
        this.Title = title;
        this.Description = description;
        this.Price = price;
        this.Image= image;
    }

    public String getTitle() {
        return Title;
    }

    public void setTitle(String title) {
        Title = title;
    }


    public String getDescription() {
        return Description;
    }

    public void setDescription(String description) {
        Description = description;
    }

    public double getPrice() {
        return Price;
    }

    public void setPrice(double price) {
        Price = price;
    }

    public Drawable getImage() {
        return Image;
    }

    public void setImage(Drawable image) {
        Image = image;
    }
}
