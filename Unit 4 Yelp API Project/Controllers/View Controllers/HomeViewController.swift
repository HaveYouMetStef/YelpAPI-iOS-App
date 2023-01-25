//
//  HomeViewController.swift
//  Unit 4 Yelp API Project
//
//  Created by Stef Castillo on 1/16/23.
//

import UIKit

class HomeViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource  {
    
    
    
    //MARK: - Outlets
    @IBOutlet weak var OrderNowView: UIView!
    @IBOutlet weak var orderButton: IRButton!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var suggestionCollectionView: UICollectionView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationIconImage: UIImageView!
    
    let networkManager = NetworkManager()
    /*Create a variable titled “tally” with a default value of zero in the “HomeVC” file.*/
    var tally: Int = 0
    
    
    //Property observer and reloading data once the network call has successfully updated the Yelp Data object
    private var yelpData : YelpData? = nil {
        didSet {
            DispatchQueue.main.async {
                self.suggestionCollectionView.reloadData()
            }
        }
    }

    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        suggestionCollectionView.delegate = self
        suggestionCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        fetch()
        newFetch()
        OrderButtonStyle()
        updateLocationLabel()
        styleBackgroundElements()
        orderButton.setTitle("No Orders", for: .normal)
        //Note: - Alternative to notification center would be the protocol and delegate pattern
        NotificationCenter.default.addObserver(self, selector: #selector((self.addToOrder(notification:))), name: Notification.Name("addToOrder"), object: nil)

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /*Utilizing a communication pattern, set up the functionality of when the DeailMenuVC ‘s “Add to cart” button is tapped, the tally count in the HomeVC increments by 1.*/
    @objc func addToOrder(notification: Notification) {
        tally += 1
        DispatchQueue.main.async {
            self.orderButton.setTitle("Order Now \(self.tally)", for: .normal)
        }
    }
    
    func updateLocationLabel() {
        locationIconImage.image = UIImage(systemName: "location")
        locationLabel.text = "Austin, TX"
        locationLabel.font = UIFont(name: "secondary", size: 12)
    }
    
    func OrderButtonStyle() {
        orderButton.setTitle(tally > 0 ? "Order Now \(tally)" : "No Orders", for: .normal)
    }
    
    func styleBackgroundElements() {
        suggestionCollectionView.backgroundColor = .clear
        OrderNowView.layer.cornerRadius = 15
    }
    
    func fetch() {
        networkManager.fetchBusiness(type: "popular food") { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let yelpBusiness):
                self.yelpData = yelpBusiness
                //Print statement for testing purposes
                print("[MainVC] - fetch:\(yelpBusiness.businesses)")
                for i in yelpBusiness.businesses {
                    print("item: \(i)")
                }
            }
        }
    }
    
    func newFetch() {
        Task {
            do {
                let info = try await networkManager.newFetchBusiness()
                
                yelpData = info
            } catch {
                printContent("Request failed with error: \(error)")
            }
        }
    }
        
        //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*add a conditional statement that checks if your collectionView is equal to the category collection view. Inside the body of that conditional statement return the array variable’s count in your CategoryOptions file*/
        if collectionView == categoryCollectionView {
            return CategoryOptions.categories.count
        }
        
        return yelpData?.businesses.count ?? 0
        
        
    }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            /*In the cellForItemAt add a similar conditional statement like the one you crated above but this time return category cell object. See helper code for example.*/
            if collectionView == categoryCollectionView {
                guard let categoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCVCell", for: indexPath) as? CategoryCVCell else { return UICollectionViewCell()}
                let category = CategoryOptions.categories[indexPath.row]
                categoryCell.category = category
                
                return categoryCell
                
            }
            
            
            guard let suggestionCell = suggestionCollectionView.dequeueReusableCell(withReuseIdentifier: "suggestionCell", for: indexPath) as? SuggestedCVCell else {return UICollectionViewCell()}
            
            let business = yelpData?.businesses[indexPath.row]
            suggestionCell.updateViews(business: business)
            suggestionCell.businessImageView.load(yelp: business?.imageURL ?? "")
            
            return suggestionCell
        }
    
    func orderPlaced() {
        guard tally > 0 else {
            DispatchQueue.main.async {
                self.driverImage.shake()
            }
            return
        }
        DispatchQueue.main.async {
            self.animateOffScreen(imageView: self.driverImage)
        }

    }
    
    //MARK: - Actions
    
    @IBAction func orderButtonPressed(_ sender: Any) {
        orderPlaced()
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Passes a selected suggestion to business object to the DetailMenuVC
//        print(segue.identifier)
        if segue.identifier == "toDetailView" {
            guard let destinationVC = segue.destination as? DetailMenuVC,
                  
                    let cell = sender as? SuggestedCVCell,
                  
                    let indexPath = self.suggestionCollectionView.indexPath(for: cell),
                  
                    let businessDetails = yelpData?.businesses[indexPath.row] else {return}
            
            destinationVC.business = businessDetails
        }
        /*In your HomeVC ‘s, prepare for the segue method and include a conditional statement. That conditional statement will run the code in its body if the segue identifier equals your new HomeVC to the CategoryTVC segue identifier.
         With that setup, include code to pass a selected Category object to the CategoryTVC.*/
        if segue.identifier == "toCategoryVC" {
            guard let destinationVC = segue.destination as? CategoryTVC else { return }
            
            guard let cell = sender as? CategoryCVCell else { return }
            
            guard let indexPath = self.categoryCollectionView.indexPath(for: cell) else { return }
            
            let selectedCategory = CategoryOptions.categories[indexPath.row]
            
            destinationVC.selectedCategory = selectedCategory
        }
  
        
    }
    

}

//Create your shake animation
extension UIView {
    
    func shake() {
        let translateRight = CGAffineTransform(translationX: 4.0, y: 0)
        let translateLeft = CGAffineTransform(translationX: -4.0, y: 0)
        
        self.transform = translateRight
        
        UIView.animate(withDuration: 0.07, delay: 0.01, options: [.autoreverse,.repeat]) {
            
            UIView.modifyAnimations(withRepeatCount: 2, autoreverses: true) {
                self.transform = translateLeft
            }
        } completion: { _ in
            self.transform = CGAffineTransform.identity
        }
    }
}

extension HomeViewController {
    func animateOffScreen(imageView: UIImageView) {
        let originalCenter = imageView.center
        UIView.animateKeyframes(withDuration: 1.5, delay: 0.0, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                imageView.center.x -= 80.0
                imageView.center.y += 10.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4) {
                imageView.transform = CGAffineTransform(rotationAngle: -.pi / 80)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                imageView.center.x -= 100.0
                imageView.center.y += 50.0
                imageView.alpha = 0.0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.01) {
                imageView.transform = .identity
                imageView.center = CGPoint(x: 900.0, y: 100.0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45) {
                imageView.center = originalCenter
                imageView.alpha = 1.0
            }
        }, completion: { (_) in
            self.tally = 0
            self.orderButton.setTitle("No Orders", for: .normal)
        })
    }
}
