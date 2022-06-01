//
//  MatchViewController.swift
//  PetMeet
//
//  Created by Henry Bao on 5/24/22.
//

import UIKit
import Firebase

class MatchViewController: UIViewController {
    @IBOutlet weak var nameAndAgeLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var nameAndAge = ""
    var breed = ""
    var gender = ""
    var img = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameAndAgeLabel.text = nameAndAge
        breedLabel.text = breed
        genderLabel.text = gender
    }
    
//    func getData() {
//        // get reference
//        let db = Firestore.firestore()
//        
//        // read
//        db.collection("users").getDocuments { snapshot, error in
//            // check for errors
//            if error == nil {
//                if let snapshot = snapshot {
//                    // get all documents
//
//                }
//            } else {
//
//            }
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
