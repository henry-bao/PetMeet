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
import FirebaseStorage

class MyProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let firedb = Firestore.firestore()
    private let fStorage = Storage.storage().reference()
    
    final let catBreedList = ["Domestic Shorthair", "American Longhair", "Domestic Longhair", "Siamese", "Russian Blue", "Ragdoll", "Bombay", "Persian", "British Shorthair", "American Curl", "Nebelung"]
    final let dogBreedList = ["Siberian Husky", "Golden Retriever", "Labrador Retriever", "French Bulldog", "Beagle", "German Shepherd dog", "Poodle", "Yorkshire Terriers", "Shetland Sheepdog"]
    
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
    
    @IBOutlet weak var appNameToolbar: UIBarButtonItem!
    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var userFirstNameField: UITextField!
    @IBOutlet weak var userLastNameField: UITextField!
    @IBOutlet weak var userZipCodeField: UITextField!
    @IBOutlet weak var petNameField: UITextField!
    @IBOutlet weak var petAgeField: UITextField!
    @IBOutlet weak var petCategorySeg: UISegmentedControl!
    @IBOutlet weak var petGenderSeg: UISegmentedControl!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var petBreedField: UITextField!
    @IBOutlet weak var petPhotoImage: UIImageView!
    @IBOutlet weak var uploadPhoto: UIButton!
    
    @IBAction func uploadPetPhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            petPhotoImage.image = image
            guard let imageData = image.pngData() else {
                return
            }
                        
            fStorage.child("images/\(self.userID).png").putData(imageData, metadata: nil, completion: { _, error in
                guard error == nil else {
                    print("Failed to upload iamge")
                    return
                }
                self.fStorage.child("images/\(self.userID).png").downloadURL(completion: {url, error in
                    guard let url = url, error == nil else {
                        return
                    }
                    let urlString = url.absoluteString
                    print("url: \(urlString)")
                    UserDefaults.standard.set(urlString, forKey: "\(self.userID)")
                })
            })
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    var petBreedPickerView = UIPickerView()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if petCategorySeg.selectedSegmentIndex == 0 {
            return catBreedList.count
        } else {
            return dogBreedList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if petCategorySeg.selectedSegmentIndex == 0 {
            return catBreedList[row]
        } else {
            return dogBreedList[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if petCategorySeg.selectedSegmentIndex == 0 {
            petBreedField.text = catBreedList[row]
        } else {
            petBreedField.text = dogBreedList[row]
        }
        petBreedField.resignFirstResponder()
        
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
                self.petBreedField.text = self.petBreed
                if self.petGender == "female" {
                    self.petGenderSeg.selectedSegmentIndex = 0
                } else {
                    self.petGenderSeg.selectedSegmentIndex = 1
                }
            } else {
                print("error fetching pets data")
            }
        }

        guard let urlString = UserDefaults.standard.value(forKey: "\(self.userID)") as? String, let url = URL(string: urlString) else {
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
    
    func disableUserInteraction() {
        userEmailField.isUserInteractionEnabled = false
        userFirstNameField.isUserInteractionEnabled = false
        userLastNameField.isUserInteractionEnabled = false
        userZipCodeField.isUserInteractionEnabled = false
        petAgeField.isUserInteractionEnabled = false
        petGenderSeg.isUserInteractionEnabled = false
        petNameField.isUserInteractionEnabled = false
        petCategorySeg.isUserInteractionEnabled = false
        petBreedField.isUserInteractionEnabled = false
        uploadPhoto.isEnabled = false
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
        petBreedField.isUserInteractionEnabled = true
        uploadPhoto.isEnabled = true
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
        newPetBreed = petBreedField.text!
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
        
        petBreedPickerView.delegate = self
        petBreedPickerView.dataSource = self
        petBreedField.inputView = petBreedPickerView
        petBreedField.tintColor = .clear
        
        self.hideKeyboardWhenTappedAround()
//        self.navigationItem.hidesBackButton = true
        confirmBtn.isEnabled = false
        
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
