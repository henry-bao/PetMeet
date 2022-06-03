//
//  ViewOtherProfileViewController.swift
//  PetMeet
//
//  Created by Henry Bao on 5/24/22.
//

import UIKit
import FirebaseFirestore
import AuthenticationServices
import FirebaseAuth
import FirebaseStorage

class ViewOtherProfileViewController: UIViewController {

    var userID = "u7lh6BuRPtUvvz5vGLunI8BiGj33"
    private var db = Firestore.firestore()
    private let fStorage = Storage.storage().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchPetInfo()
//        fetchUserInfo()
        // Do any additional setup after loading the view.
    }
   
    /*
    func fetchUserInfo() {
            self.db.collection("users").document(userID).getDocument{ (document, error) in
                if error == nil {
                    if document != nil && document!.exists {
                       // self.userIDList =
                        let documentData = document!.data()
                        self.firstName = documentData!["first name"] as! String
                        self.lastName = documentData!["last name"] as! String
                        //self.zipCode = documentData!["zip code"] as! String
                        self.userLocation.text = documentData!["zip code"] as! String //可以这么写吗？二选1？
    //                            print("\(firstName!), \(lastName!), \(email!), \(userID!)")
                        //self.hasAccount(firstName: firstName!, lastName: lastName!, email: email!, uid: userID!, zipCode: zipCode)
                    }
                }
            }

        }

        func fetchPetInfo() {
            db.collection("users").document(userID).collection("pets").getDocuments { (snapshot, error) in
                if error == nil && snapshot != nil{
                    let document = snapshot!.documents[0]
                    let docuData = document.data()
                   // self.getPetName = docuData["name"] as! String
                    self.getPetName = docuData["name"] as! String
                    //self.getPetAge = docuData["age"] as! String
                    self.petAge.text = docuData["age"] as! String
                    //self.getPetCategory = docuData["category"] as! String
                    self.petCategory.text = docuData["category"] as! String
    //                self.getPetBreed = docuData["breed"] as! String
    //                self.getPetGender = docuData["gender"] as! String
                    self.petBreed.text = docuData["breed"] as! String
                    self.petGender.text = docuData["gender"] as! String
                    
                    print(self.petGender.text)
                }
            }
        }
    */
    
//    guard let urlString = UserDefaults.standard.value(forKey: "\(self.userID)") as? String, let url = URL(string: urlString) else {
//                return
//            }
//            URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
//                guard let data = data, error == nil else {
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    let image = UIImage(data: data)
//                    self.petPhotoImage.image = image
//                }
//            }).resume()
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
