//
//  YelpData.swift
//  Unit 4 Yelp API Project
//
//  Created by Stef Castillo on 1/13/23.
//

import Foundation

//Model Yelp API
struct YelpData: Decodable {
    var businesses: [Business]
}

struct Categories: Decodable {
    var title: String
}

struct Location: Decodable {
    var city: String
    var state: String
    var displayAddress: [String]
    
    enum CodingKeys: String, CodingKey {
        case city = "city"
        case state = "state"
        case displayAddress = "display_address"
    }
}

struct Business: Decodable {
    var name: String
    var imageURL: String?
    var url: String
    var reviewCount: Int
    var categories: [Categories]
    var rating: Double
    var price: String?
    var location: Location?
    var phone: String
    var displayPhone: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case imageURL = "image_url"
        case url = "url"
        case reviewCount = "review_count"
        case categories = "categories"
        case rating = "rating"
        case price = "price"
        case location = "location"
        case phone = "phone"
        case displayPhone = "display_phone"
    }
}

