//
//  MatchViewController.swift
//  PetMeet
//
//  Created by Henry Bao on 5/24/22.
//

import UIKit
import Firebase
import FirebaseAuth

class MatchViewController: UIViewController {
    @IBOutlet weak var nameAndAgeLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var petPhotoImage: UIImageView!
    
    var petname = ""
    var petage = ""
    var breed = ""
    var gender = ""
    var petimg = ""
    var userID: [String] = []
    var petIndex = 1
    var petNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        getPetNum()
        nameAndAgeLabel.text = "\(petname) \(petage)"
        breedLabel.text = breed
        genderLabel.text = gender
    }
    
    func getPetNum() {
        let db = Firestore.firestore()
        self.petNum = 0
        
        db.collection("users").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                // go through all users
                for i in 0...snapshot!.documents.count-1 {
                    // go through all pets
                    db.collection("users").document(self.userID[i]).collection("pets").getDocuments { (snapshot, error) in
                        if error == nil && snapshot != nil {
                            self.petNum += 1
                        }
                        //print(self.petNum)
                    }
                }
                //print("*****\(self.petNum)")
            }
        }
    }
    
    @IBAction func likeButtonTouchUpInside(_ sender: Any) {
        // switch to next pet
        petIndex += 1
        
        if self.petIndex ==  self.petNum {
            self.petIndex = 1
        }
        getData()
        
        // write firebase data
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
        let petID = ["xphVR8umHxZPyWjtM47C"]
        
        db.collection("users").document(currentUserID).updateData(["like list": petID])
    }

    @IBAction func dislikeButtonTouchUpInside(_ sender: Any) {
        // switch to next pet
        self.petIndex += 1

        if self.petIndex ==  self.petNum {
            self.petIndex = 1
        }
        getData()
    }
    
    func getData() {
        // get reference
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                // get all userids
                for i in 0...snapshot!.documents.count-1 {
                    let document = snapshot!.documents[i]
                    self.userID.append(document.documentID)
                }
                
                // fetch pet info
                db.collection("users").document(self.userID[self.petIndex]).collection("pets").getDocuments { (snapshot, error) in
                    if error == nil && snapshot != nil {
                        let document = snapshot!.documents[0]
                        let docuData = document.data()
                        self.petname = docuData["name"] as! String
                        self.petage = docuData["age"] as! String
                        self.breed = docuData["breed"] as! String
                        self.gender = docuData["gender"] as! String
                        self.nameAndAgeLabel.text = "\(self.petname)  \(self.petage) yrs"
                        self.breedLabel.text = self.breed
                        self.genderLabel.text = self.gender
                    }
                }
                
                // fetch image
                guard let urlString = UserDefaults.standard.value(forKey: "\(self.userID[self.petIndex])") as? String, let url = URL(string: urlString)
                    else {
                            return
                    }

                URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }

                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.petPhotoImage.image = image
                    }
                }).resume()
            }
        }
    }
}
