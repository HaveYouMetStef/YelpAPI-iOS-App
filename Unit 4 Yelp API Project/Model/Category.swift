//
//  Category.swift
//  Unit 4 Yelp API Project
//
//  Created by Stef Castillo on 1/22/23.
//

import Foundation

struct Category {
    
    /*The first struct will be our model for our Category object. Create a struct titled Category that has the following properties:
     title → String
     imageName → String */
    
    var title: String
    var imageName: String
    
}

/*The second struct will hold a collection of our Category objects that match the names of the preloaded images in this lab’s starter project.*/
struct CategoryOptions {
    
    /*The second struct will be titled CategoryOptions and will hold a static variable of an array of Category objects. In your variable’s array create 8 Category objects that match the assets in your starter project’s Category folder.
     */
    static var categories: [Category] = [
    Category(title: "Tacos", imageName: "taco"),
    Category(title: "Burgers", imageName: "burger"),
    Category(title: "Sushi", imageName: "sushi"),
    Category(title: "pizza", imageName: "pizza"),
    Category(title: "Pho", imageName: "pho"),
    Category(title: "Chicken", imageName: "fried-chicken"),
    Category(title: "Cafe", imageName: "coffee"),
    Category(title: "Boba Tea", imageName: "bubble-tea")
    ]
}
