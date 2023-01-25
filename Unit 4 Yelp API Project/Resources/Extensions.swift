//
//  Extensions.swift
//  Unit 4 Yelp API Project
//
//  Created by Stef Castillo on 1/20/23.
//

import UIKit



extension UIImageView {
    func load(yelp imageURL: String) {
        DispatchQueue.global().async {
            [weak self] in
            guard let urlString = URL(string: imageURL) else { return }
            if let data = try? Data(contentsOf: urlString) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
