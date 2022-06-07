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
    
    var passUserID = ""
    
    private let fStorage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
        
        db.collection("users").document(currentUserID).getDocument { (snapshot, error) in
            if error == nil && snapshot != nil {
                self.petID = snapshot!.data()!["like list"] as! [String]
            }
        }
        
        getData()
        let nameAgeButtonTitle = NSMutableAttributedString(string: "\(self.petname)  \(self.petage)yrs", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)
        ])
        self.nameAndAgeButton.setAttributedTitle(nameAgeButtonTitle, for: .normal)
        getPetNum()
        breedLabel.text = breed
        genderLabel.text = gender
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        petPhotoImage.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        petPhotoImage.addGestureRecognizer(swipeLeft)
    }
    
    func getPetNum() {
        let db = Firestore.firestore()
        self.petNum = 0
        
        db.collection("users").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                // go through all users
                for i in 0...self.userID.count-1 {
                    // go through all pets
                    db.collection("users").document(self.userID[i]).collection("pets").getDocuments { (snapshot, error) in
                        if error == nil && snapshot != nil {
                            self.petNum += 1
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer?) {
        if let swipeGesture = sender {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                if self.petIndex >=  self.petNum - 1 {
                    for gesture in petPhotoImage.gestureRecognizers! {
                        gesture.isEnabled = false
                        self.likeButton.isHidden = true
                        self.dislikeButton.isHidden = true
                    }
                } else {
                    likeButtonTouchUpInside(sender!)
                }
            case UISwipeGestureRecognizer.Direction.left:
                if self.petIndex >=  self.petNum - 1 {
                    for gesture in petPhotoImage.gestureRecognizers! {
                        gesture.isEnabled = false
                        self.likeButton.isHidden = true
                        self.dislikeButton.isHidden = true
                    }
                } else {
                    dislikeButtonTouchUpInside(sender!)
                }
            default:
                break
            }
        }
    }
    
    @IBAction func likeButtonTouchUpInside(_ sender: Any) {
        viewSwippedLeft()
        // write firebase data
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
        db.collection("users").document(self.userID[self.petIndex]).collection("pets").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                let document = snapshot!.documents[0]
                if !self.petID.contains(document.documentID) {
                    self.petID.append(document.documentID)
                    db.collection("users").document(currentUserID).updateData(["like list": self.petID])
                }
            }
        }
        
        if self.petIndex >=  self.petNum - 1 { // no more pets to view
            let alert = UIAlertController(title: "You have viewed all the pets.", message: "See what you liked in the Like List!", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
                     self.present(alert, animated: true, completion: { NSLog("The completion handler fired") })
            self.likeButton.isHidden = true
            self.dislikeButton.isHidden = true
            for gesture in petPhotoImage.gestureRecognizers! {
                gesture.isEnabled = false
            }
        } else {
            // display next pet info
            getData()
            self.petIndex += 1
        }
    }

    @IBAction func dislikeButtonTouchUpInside(_ sender: Any) {
        viewSwippedRight()
        
        // switch to next pet
        if self.petIndex >=  self.petNum - 1 {
            let alert = UIAlertController(title: "You have viewed all the pets.", message: "See what you liked in the Like List!", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
                     self.present(alert, animated: true, completion: { NSLog("The completion handler fired") })
        } else {
            getData()
            self.petIndex += 1
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
            
                    let currentUserID = Auth.auth().currentUser!.uid
                    if document.documentID != currentUserID {
                        self.userID.append(document.documentID)
                    }
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
                        let nameAgeButtonTitle = NSMutableAttributedString(string: "\(self.petname) (\(self.petage)yrs)", attributes: [
                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22),
                            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
                        ])
                        self.nameAndAgeButton.setAttributedTitle(nameAgeButtonTitle, for: .normal)
                        self.breedLabel.text = self.breed
                        self.genderLabel.text = self.gender
                        self.passUserID = self.userID[self.petIndex]
                    }
                }
                
                // fetch image
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
    
    @IBAction func seeProfile(_ sender: Any) {
        
        if let ViewOtherVC = storyboard?.instantiateViewController(withIdentifier: "ViewOtherVC") as? ViewOtherProfileViewController {
            self.navigationController?.pushViewController(ViewOtherVC, animated: true)
            ViewOtherVC.userID = passUserID
        }
    }
    
    func viewSwippedRight() {
        petPhotoImage.leftToRightAnimation()
    }
    
    func viewSwippedLeft() {
        petPhotoImage.rightToLeftAnimation()
    }
}

extension UIView {
    func leftToRightAnimation(duration: TimeInterval = 0.8, completionDelegate: AnyObject? = nil) {
        // Create a CATransition object
        let leftToRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided
        if let delegate: AnyObject = completionDelegate {
            leftToRightTransition.delegate = (delegate as! CAAnimationDelegate)
        }
        
        leftToRightTransition.type = CATransitionType.push
        leftToRightTransition.subtype = CATransitionSubtype.fromRight
        leftToRightTransition.duration = duration
        leftToRightTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        leftToRightTransition.fillMode = CAMediaTimingFillMode.removed
        
        // Add the animation to the View's layer
        self.layer.add(leftToRightTransition, forKey: "leftToRightTransition")
    }
    
    func rightToLeftAnimation(duration: TimeInterval = 0.8, completionDelegate: AnyObject? = nil) {
        // Create a CATransition object
        let rightToLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided
        if let delegate: AnyObject = completionDelegate {
            rightToLeftTransition.delegate = (delegate as! CAAnimationDelegate)
        }
        
        rightToLeftTransition.type = CATransitionType.push
        rightToLeftTransition.subtype = CATransitionSubtype.fromLeft
        rightToLeftTransition.duration = duration
        rightToLeftTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        rightToLeftTransition.fillMode = CAMediaTimingFillMode.removed
        
        // Add the animation to the View's layer
        self.layer.add(rightToLeftTransition, forKey: "rightToLeftTransition")
    }
}
