package com.arrowhead.parseswagswap;

import com.parse.ParseClassName;
import com.parse.ParseFile;
import com.parse.ParseObject;
import com.parse.ParseUser;

/**
 * Created by Miguel on 3/24/2015.
 */
@ParseClassName("Listing")
public class Listing extends ParseObject {
  /* private String name;
    private String desc;
    private String category;
    private Number price;
    private ParseFile images;
    */

    public Listing(){

        super();

    }

    public void setDetails(String name,String des,String cate,Number p, ParseFile img,ParseUser seller) {
       /* this.name = name;
        this.desc = des;
        this.category = cate;
        this.price = p;
        this.images = img;
        this.seller = seller;*/
    }
    public void saveDetails(String name,String des,String cate,Number p, ParseFile img,ParseUser seller) {
        put("name", name);
        put("desc", des);
        put("category", cate);
        put("price", p);
        //img.saveInBackground();
        put("images", img);
        put("seller", seller);
    }

    public String getTitle() {
        return getString("name");
    }

    public void setTitle(String title) {
        put("name", title);
    }

    public ParseUser getSeller() {
        return getParseUser("seller");
    }

    public void setSeller(ParseUser user) {
        put("seller", user);
    }

    public Number getPrice(){
        return getNumber("price");
    }

    public void setPrice(Number price){
        put("price",price);
    }

    public String getDescprition(){
        return getString("desc");
    }

    public void setDescription(String desc){
        put("desc",desc);
    }

    public String getCategory(){
        return getString("category");
    }

    public void setCategory(String cate){
        put("category",cate);
    }

    public ParseFile getPhotoFile() {
        return getParseFile("images");
    }

    public void setPhotoFile(ParseFile file) {
        put("images", file);
    }

}
/* class Listing {
    private String Title;
    private String Description;
    private double Price;
    private ArrayList<Drawable> Image;

    public Listing(String title,String description,double price,ArrayList<Drawable> image) {
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
        return Image.get(0);
    }

    public void setImage(ArrayList<Drawable> image) {
        Image = image;
    }*/

