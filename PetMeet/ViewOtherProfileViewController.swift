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
 
    //var userID = "u7lh6BuRPtUvvz5vGLunI8BiGj33"
    private var db = Firestore.firestore()
    private let fStorage = Storage.storage().reference()
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userLocation: UILabel!
   
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petAge: UILabel!
    @IBOutlet weak var petBreed: UILabel!
    @IBOutlet weak var petCategory: UILabel!
    @IBOutlet weak var petGender: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    var firstName = ""
    var lastName = ""
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPetInfo()
        fetchUserInfo()
        // Do any additional setup after loading the view.
    }
   
    
    func fetchUserInfo() {
            self.db.collection("users").document(userID).getDocument{ (document, error) in
                if error == nil {
                    if document != nil && document!.exists {
                        let documentData = document!.data()
                        self.firstName = documentData!["first name"] as! String
                        self.lastName = documentData!["last name"] as! String
                        self.userEmail.text = documentData!["email"] as? String
                        self.userLocation.text = documentData!["zip code"] as? String
                        self.userName.text = ("\(self.firstName), \(self.lastName)")
                    }
                }
            }
        }
 
        func fetchPetInfo() {
            db.collection("users").document(userID).collection("pets").getDocuments { (snapshot, error) in
                if error == nil && snapshot != nil{
                    let document = snapshot!.documents[0]
                    let docuData = document.data()
                    self.petName.text = docuData["name"] as? String
                    self.petAge.text = docuData["age"] as? String
                    self.petCategory.text = docuData["category"] as? String
                    self.petBreed.text = docuData["breed"] as? String
                    self.petGender.text = docuData["gender"] as? String
                    //print(self.petGender.text)
                }
            }
            
            //fetch image
            let getImage = self.fStorage.child("images/\(self.userID).png")
 
            getImage.getData(maxSize: 3 * 1024 * 1024){ data, error in
 
              if let error = error {
                print(error)
              }
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    self.petImage.image = image
                }
            }
            
        }
    
    @IBAction func backBtn(_ sender: Any) {
        if let matchVC = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? tabBarViewController {
              self.navigationController?.pushViewController(matchVC, animated: true)

             }
        let matchVC = self.storyboard?.instantiateViewController(withIdentifier: "matchVC") as! MatchViewController

      // You can create your own animation

    }
}
