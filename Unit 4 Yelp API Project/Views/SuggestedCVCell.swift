//
//  SuggestedCVCell.swift
//  Unit 4 Yelp API Project
//
//  Created by Stef Castillo on 1/16/23.
//

import UIKit

class SuggestedCVCell: UICollectionViewCell {
    
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func updateViews(business: Business?)  {
        guard let business = business else { return }
        nameLabel.text = business.name
        priceLabel.text = "Price \(business.price ?? "")"
        ratingLabel.text = "\(business.location?.city ?? ""),\(business.location?.state ?? "")"
    }
    
}
