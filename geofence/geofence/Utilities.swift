//
//  Utilities.swift
//  geofence
//
//  Created by Zachary Browne on 3/17/16.
//  Copyright © 2016 zbrowne. All rights reserved.
//

import Foundation
import UIKit
import MapKit

// MARK: Helper Functions

func showSimpleAlertWithTitle(title: String!, message: String, viewController: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
    alert.addAction(action)
    viewController.presentViewController(alert, animated: true, completion: nil)
}
