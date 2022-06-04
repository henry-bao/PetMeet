//
//  MatchViewController.swift
//  PetMeet
//
//  Created by Henry Bao on 5/24/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class MatchViewController: UIViewController {
    @IBOutlet weak var nameAndAgeButton: UIButton!
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
    var petID: [String] = []
    var petIndex = 0
    var petNum = 0
    
    private let fStorage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        getPetNum()
        nameAndAgeButton.setTitle("\(petname) \(petage)", for: .normal)
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
        self.petIndex += 1
        
        if self.petIndex >=  self.petNum - 1 {
            let alert = UIAlertController(title: "My Alert", message: "This is an alert.", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
                     self.present(alert, animated: true, completion: { NSLog("The completion handler fired") })
        } else {
            getData()
        }
        
        // write firebase data
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
        
        db.collection("users").document(self.userID[self.petIndex]).collection("pets").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                let document = snapshot!.documents[0]
                self.petID.append(document.documentID)
            }
        }
        
        db.collection("users").document(currentUserID).updateData(["like list": petID])
    }

    @IBAction func dislikeButtonTouchUpInside(_ sender: Any) {
        // switch to next pet
        self.petIndex += 1
        
        if self.petIndex >=  self.petNum - 1 {
            let alert = UIAlertController(title: "You have viewed all the pets.", message: "See what you liked in the Like List!", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
                     self.present(alert, animated: true, completion: { NSLog("The completion handler fired") })
        } else {
            getData()
        }
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
                        self.nameAndAgeButton.setTitle("\(self.petname) \(self.petage)", for: .normal)
                        self.breedLabel.text = self.breed
                        self.genderLabel.text = self.gender
                    }
                }
                
                // fetch image
//                guard let urlString = UserDefaults.standard.value(forKey: "\(self.userID[self.petIndex])") as? String, let url = URL(string: urlString) else {
//                        return
//                }
//
//                URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
//                    guard let data = data, error == nil else {
//                        return
//                    }
//
//                    DispatchQueue.main.async {
//                        let image = UIImage(data: data)
//                        self.petPhotoImage.image = image
//                    }
//                }).resume()
                
                let islandRef = self.fStorage.child("images/\(self.userID[self.petIndex]).png")
                islandRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
                  if let error = error {
                    print(error)
                  } else {
                      DispatchQueue.main.async {
                          let image = UIImage(data: data!)
                          self.petPhotoImage.image = image
                      }
                  }
                }
            }
        }
    }
}
