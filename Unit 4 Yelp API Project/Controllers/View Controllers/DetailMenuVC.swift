//
//  DetailMenuVC.swift
//  Unit 4 Yelp API Project
//
//  Created by Stef Castillo on 1/19/23.
//

import UIKit
import CoreLocation

class DetailMenuVC: UIViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak var addButton: IRButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var seeAllPhotosLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var viewMapsLabel: UILabel!
    @IBOutlet weak var callLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    
    var business: Business?
    
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        styleButtons()
        styleDismissButton()
        businessImageView.insetsLayoutMarginsFromSafeArea = false
        
    }
    
    
    
    //MARK: - Helper Methods
    //stars func
    func setStars(rating: Double) -> String {
        var starRating: String = ""
        switch rating.rounded(.towardZero) {
        case 1:
            starRating = "⭐️"
        case 2:
            starRating = "⭐️⭐️"
        case 3:
            starRating = "⭐️⭐️⭐️"
        case 4:
            starRating = "⭐️⭐️⭐️⭐️"
        case 5:
            starRating = "⭐️⭐️⭐️⭐️⭐️"
        default:
            break
        }
        
        if floor(rating) != rating {
            starRating.append(contentsOf: "½")
        }
        return starRating
    }
    
    func styleButtons() {
        phoneNumberButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        phoneNumberButton.tintColor = .label

        
        addressButton.tintColor = .label
        addressButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        
        reviewButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        reviewButton.tintColor = .label
    }
    
    func styleDismissButton () {
        dismissButton.setImage(UIImage(systemName: "x.circle",
                                       withConfiguration: UIImage.SymbolConfiguration(pointSize: 32,
                                                                                      weight: .medium, scale: .default)), for: .normal)
        dismissButton.backgroundColor = UIColor(named: "Accent")
    }
    
    
    /*Create a function that takes in a bool value and returns a string value. This function will take in the business object’s isOpen property and return either the string “Open” or “Closed” depending on the bool value.*/
    
    func businessStatus(openLabel: Bool) -> String {
        return openLabel ? "Open" : "Closed"
    }
    
    func updateViews() {
        guard let business = business else { return }
        openLabel.text = "Open now"
        nameLabel.text = "\(business.name)"
        
        nameLabel.textColor = .black
        
        priceLabel.text = "\(business.price ?? "") \((business.categories.map {$0.title}).joined(separator: ", "))"
        
        businessImageView.load(yelp: business.imageURL ?? "")
        
        ratingLabel.text = "\(setStars(rating: business.rating)) - \(business.reviewCount)"
        
        ratingLabel.textColor = .black
        
        let attributedString = NSMutableAttributedString(string: nameLabel.text ?? "")
        
        attributedString.addAttribute(NSAttributedString.Key.kern, value:CGFloat(3.0), range: NSRange(location: 0, length: attributedString.length))
        
        nameLabel.attributedText = attributedString
        
        seeAllPhotosLabel.textColor = .black
        callLabel.textColor = .black
        viewMapsLabel.textColor = .black
        reviewsLabel.textColor = .black
        
    }
    
    
    //MARK: Action Outlets
    /*Create an action IBOutlet for the top right button. The functions body includes code to dismiss the modal presentation when the button is tapped.*/
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*Create an action IBOutlet for the bottom right “Add to cart” button. We’ll come back to this button later in the lab. For now, simply leave it as-is.*/
    @IBAction func addButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("addToOrder"), object: nil)
    }
    
    @IBAction func phoneNumberTapped(_ sender: Any) {
        guard let business = business else {
            return
        }
        
        print(business.phone)
        if let url = URL(string: "tel://\(business.phone)") {
            
            UIApplication.shared.open(url, options: [:]) { success in
                if !success {
                let phoneNotAvailable = AlertController.presentAlertControllerWith(alertTitle: "Unable to place call", alertMessage: "Ensure you are on a physical device that allows phone calls and not an Xcode simulator", dismissActionTitle: "Dismiss")
                DispatchQueue.main.async {
                    self.present(phoneNotAvailable, animated: true)
                }
            }
                
            }
        } else {
            print("hello")
        }
        
    }
    
    @IBAction func addressButtonTapped(_ sender: Any) {
        guard let business = business else {return}
        
        guard let myAddress =
                business.location?.displayAddress.joined(separator: " ") else {return}
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(myAddress) { (placemarks, error ) in
            guard let placemarks = placemarks?.first else { return }
            let location = placemarks.location?.coordinate ?? CLLocationCoordinate2D()
            guard let url = URL(string: "http://maps.apple.com/maps?saddr=\(location.latitude),\(location.longitude)") else { return }
            UIApplication.shared.open(url)
        }
    }
        
        @IBAction func reviewButtonTaped(_ sender: Any) {
            guard let business = business else {
                return
            }
            
            if let url = URL(string: business.url) {
                UIApplication.shared.open(url)
            } else {
                let phoneNotAvailable =
                AlertController.presentAlertControllerWith(alertTitle: "Unable to complete request", alertMessage: "Please try again later", dismissActionTitle: "Dismiss")
                DispatchQueue.main.async {
                    self.present(phoneNotAvailable, animated: true)
                }
            }
        }
    }
