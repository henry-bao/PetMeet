//
//  ViewOtherProfileViewController.swift
//  PetMeet
//
//  Created by Henry Bao on 5/24/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import AuthenticationServices
//import FirebaseDatabase

class ViewOtherProfileViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petAge: UILabel!
    @IBOutlet weak var petBreed: UILabel!
    @IBOutlet weak var petCategory: UILabel!
    @IBOutlet weak var petGender: UILabel!
    @IBOutlet weak var petName: UILabel!
    
    
    private var db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
//    static func getUserInfo() {
//        self.db.collection("users").document(userID!).getDocument{ (document, error) in
//            if error == nil {
//                if document != nil && document!.exists {
//                    let documentData = document!.data()
//                    firstName = documentData!["first name"] as? String
//                    lastName = documentData!["last name"] as? String
//                    zipCode = documentData!["zip code"] as! String
////                            print("\(firstName!), \(lastName!), \(email!), \(userID!)")
//                    self.hasAccount(firstName: firstName!, lastName: lastName!, email: email!, uid: userID!, zipCode: zipCode)
//                }
//            }
//        }
//
//    }
//
//    static func getPetInfo() {
//        db.collection("users").document(userID).collection("pets").getDocuments { (snapshot, error) in
//            if error == nil && snapshot != nil{
//                let document = snapshot!.documents[0]
//                let docuData = document.data()
//                self.petName = docuData["name"] as! String
//                self.petAge = docuData["age"] as! String
//                self.petCategory = docuData["category"] as! String
//                self.petBreed = docuData["breed"] as! String
//                self.petGender = docuData["gender"] as! String
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
