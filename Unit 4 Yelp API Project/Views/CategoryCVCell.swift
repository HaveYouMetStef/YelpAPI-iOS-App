//
//  CategoryCVCell.swift
//  Unit 4 Yelp API Project
//
//  Created by Stef Castillo on 1/22/23.
//

import UIKit

class CategoryCVCell: UICollectionViewCell {
    
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    var category: Category? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let category = category else {return}
        categoryTitle.text = category.title
        categoryImageView.image = UIImage(named: category.imageName)
    }
}
