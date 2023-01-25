//
//  AlertController.swift
//  Unit 4 Yelp API Project
//
//  Created by Stef Castillo on 1/21/23.
//

import UIKit

class AlertController {
    static func presentAlertControllerWith(alertTitle: String, alertMessage: String?, dismissActionTitle: String) -> UIViewController {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: dismissActionTitle, style: .cancel, handler: nil)
        alertController.addAction(dismissAction)
        
        return alertController
    }
}
