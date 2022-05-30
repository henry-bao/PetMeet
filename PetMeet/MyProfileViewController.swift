//
//  MyProfileViewController.swift
//  PetMeet
//
//  Created by Henry Bao on 5/24/22.
//

import UIKit
import FirebaseFirestore
import AuthenticationServices
import FirebaseAuth

class MyProfileViewController: UIViewController{
    private let firedb = Firestore.firestore()
    var firstName = ""
    var lastName = ""
    var email = ""
    var userID = ""
    var zipCode = ""
    var petName = ""
    var petAge = ""
    var petCategory = ""
    var petBreed = ""
    var petGender = ""
    
    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var userFirstNameField: UITextField!
    @IBOutlet weak var userLastNameField: UITextField!
    @IBOutlet weak var userZipCodeField: UITextField!
    @IBOutlet weak var petNameField: UITextField!
    @IBOutlet weak var petAgeField: UITextField!
    @IBOutlet weak var petCategorySeg: UISegmentedControl!
    @IBOutlet weak var petGenderSeg: UISegmentedControl!
    @IBOutlet weak var petBreedBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBAction func petBreedBtnPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func editBtnPressed(_ sender: Any) {
        enableUserInteraction()
        editBtn.isEnabled = false
        confirmBtn.isEnabled = true
    }
    
    
    func displayUserInfo() {
        let tabBarVC = tabBarController as! tabBarViewController
        firstName = tabBarVC.firstName
        lastName = tabBarVC.lastName
        email = tabBarVC.email
        userID = tabBarVC.userID
        zipCode = tabBarVC.zipCode
        userEmailField.text = email
        userFirstNameField.text = firstName
        userLastNameField.text = lastName
        userZipCodeField.text = zipCode
        firedb.collection("users").document(userID).collection("pets").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil{
                let document = snapshot!.documents[0]
                let docuData = document.data()
                self.petName = docuData["name"] as! String
                self.petAge = docuData["age"] as! String
                self.petCategory = docuData["category"] as! String
                self.petBreed = docuData["breed"] as! String
                self.petGender = docuData["gender"] as! String
                self.petNameField.text = self.petName
                self.petAgeField.text = self.petAge
                if self.petCategory == "cat" {
                    self.petCategorySeg.selectedSegmentIndex = 0
                } else {
                    self.petCategorySeg.selectedSegmentIndex = 1
                }
                self.petBreedBtn.titleLabel?.text = self.petBreed
                if self.petGender == "female" {
                    self.petGenderSeg.selectedSegmentIndex = 0
                } else {
                    self.petGenderSeg.selectedSegmentIndex = 1
                }
            } else {
                print("error fetching pets data")
            }
            
        }
    }
    
    func disableUserInteraction() {
        userEmailField.isUserInteractionEnabled = false
        userFirstNameField.isUserInteractionEnabled = false
        userLastNameField.isUserInteractionEnabled = false
        userZipCodeField.isUserInteractionEnabled = false
        petAgeField.isUserInteractionEnabled = false
        petGenderSeg.isUserInteractionEnabled = false
        petNameField.isUserInteractionEnabled = false
        petCategorySeg.isUserInteractionEnabled = false
        petBreedBtn.isUserInteractionEnabled = false
    }
    
    func enableUserInteraction() {
        userEmailField.isUserInteractionEnabled = true
        userFirstNameField.isUserInteractionEnabled = true
        userLastNameField.isUserInteractionEnabled = true
        userZipCodeField.isUserInteractionEnabled = true
        petAgeField.isUserInteractionEnabled = true
        petGenderSeg.isUserInteractionEnabled = true
        petNameField.isUserInteractionEnabled = true
        petCategorySeg.isUserInteractionEnabled = true
        petBreedBtn.isUserInteractionEnabled = true
    }
    
    @IBAction func confirmBtnPressed(_ sender: Any) {
        disableUserInteraction()
        confirmBtn.isEnabled = false
        editBtn.isEnabled = true
        let newUserEmail = userEmailField.text
        let newUserFirstName = userFirstNameField.text
        let newUserLastName = userLastNameField.text
        let newUserZipCode = userZipCodeField.text
        let newPetName = petNameField.text
        let newPetAge = petAgeField.text
        var newPetCategory = ""
        var newPetGender = ""
        var newPetBreed = ""
        if petCategorySeg.selectedSegmentIndex == 0 {
            newPetCategory = "cat"
        } else {
            newPetCategory = "dog"
        }
        if petGenderSeg.selectedSegmentIndex == 0 {
            newPetGender = "female"
        } else {
            newPetGender = "male"
        }
        newPetBreed = petBreedBtn.titleLabel!.text!
        firedb.collection("users").document(userID).setData(["email": newUserEmail!, "first name": newUserFirstName!, "last name": newUserLastName!, "zip code": newUserZipCode!])
        firedb.collection("users").document(userID).collection("pets").getDocuments{ (snapshot, error) in
            if error == nil && snapshot != nil {
                let document = snapshot!.documents[0]
                document.reference.setData(["age": newPetAge!, "breed": newPetBreed, "category": newPetCategory, "gender": newPetGender, "name": newPetName!])
            }
        }
    }
//    @IBAction func signout(_ sender: Any) {
//        do {
//            try
//            Auth.auth().signOut()
//        } catch {
//            print("error signing out")
//        }
//        if let signInVC = storyboard?.instantiateViewController(withIdentifier: "signInVC") as? ViewController {
//
//            self.navigationController?.pushViewController(signInVC, animated: true)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        confirmBtn.isEnabled = false
        navigationItem.hidesBackButton = true
        displayUserInfo()
        disableUserInteraction()
        
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
