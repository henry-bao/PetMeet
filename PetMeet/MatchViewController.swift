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
    @IBOutlet weak var petPhotoImage: UIImageView!
    
    var petname = ""
    var petage = ""
    var breed = ""
    var gender = ""
    var petimg = ""
    var userID: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        nameAndAgeLabel.text = "\(petname) \(petage)"
        breedLabel.text = breed
        genderLabel.text = gender
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
                db.collection("users").document(self.userID[0]).collection("pets").getDocuments { (snapshot, error) in
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
                guard let urlString = UserDefaults.standard.value(forKey: "\(self.userID[0])") as? String, let url = URL(string: urlString)
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
