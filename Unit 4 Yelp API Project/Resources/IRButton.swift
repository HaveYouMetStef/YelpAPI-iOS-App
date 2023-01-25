//
//  IRButton.swift
//  Unit 4 Yelp API Project
//
//  Created by Stef Castillo on 1/22/23.
//

import UIKit

class IRButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        setTitleColor(.white, for: .normal)
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 9.0
        layer.masksToBounds = true
        backgroundColor = #colorLiteral(red: 0.9761943221, green: 0.4330539703, blue: 0.3638819456, alpha: 1)
        titleLabel?.font = .boldSystemFont(ofSize: 20)
        layer.cornerRadius = 15
    }
}
