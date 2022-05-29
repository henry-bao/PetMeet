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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
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
