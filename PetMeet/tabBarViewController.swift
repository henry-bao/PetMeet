//
//  tabBarViewController.swift
//  PetMeet
//
//  Created by Henry Bao on 5/24/22.
//

import UIKit

class tabBarViewController: UITabBarController {
    var firstName = ""
    var lastName = ""
    var email = ""
    var userID = ""
    var zipCode = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1
        navigationItem.hidesBackButton = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
