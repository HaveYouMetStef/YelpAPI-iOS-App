//
//  CategoryTVC.swift
//  Unit 4 Yelp API Project
//
//  Created by Stef Castillo on 1/22/23.
//

import UIKit

class CategoryTVC: UITableViewController {
    
    var selectedCategory: Category?
    private var yelpData: YelpData? = nil {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        
    }
    
    func fetch() {
        NetworkManager.shared.fetchBusiness(type: selectedCategory?.title ?? "food") {
            [self] results in
            switch results {
            case .success(let data):
                yelpData = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        yelpData?.businesses.count ?? 0
    }
    
    
    /*In your cellForRowAt method, include functionality to populate your table view with the following items:
     content.text → business.name
     content.secondaryText → business.rating
     content.image → selectedCaegory.imageName*/
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryListCell", for: indexPath)
        
        guard let business = yelpData?.businesses[indexPath.row] else { return UITableViewCell()}
        
        var content = cell.defaultContentConfiguration()
        
        content.text = business.name
        content.textProperties.color = .label
        content.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
        content.textToSecondaryTextVerticalPadding = 4
        
        content.secondaryText = "\(business.rating)"
        content.textProperties.color = .secondaryLabel
        content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        content.image = UIImage(named: selectedCategory?.imageName ?? "")
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        
        cell.contentConfiguration = content
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    // MARK: - Navigation
    
    /*Include in your CategoryTVC file a prepare to segue function that sends a selected cell’s data to your DetailMenuVC.*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        guard let detailMenuVC = segue.destination as? DetailMenuVC,
              let indexPath = self.tableView.indexPathForSelectedRow else { return }
        
        let business = yelpData?.businesses[indexPath.row]
        detailMenuVC.business = business
        
    }
}
