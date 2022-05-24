//
//  ViewController.swift
//  PetMeet
//
<<<<<<< HEAD
//  Created by Henry Bao on 5/22/22.
//

import UIKit
import GoogleSignIn
import Firebase

class ViewController: UIViewController {

    @IBOutlet var signInButton: GIDSignInButton!
    
=======
//  Created by Henry Bao on 5/24/22.
//

import UIKit

class ViewController: UIViewController {

>>>>>>> 2ef088c (Initial Commit)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
<<<<<<< HEAD
    
    @IBAction func handleLogin(_ sender: Any) {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }

            let config = GIDConfiguration(clientID: clientID)
            
            GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) {
                user, error in
                
                if let error = error {
                    print(error.localizedDescription)
                  return
                }

                guard
                  let authentication = user?.authentication,
                  let idToken = authentication.idToken
                else {
                  return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: authentication.accessToken)
                
                Auth.auth().signIn(with: credential) {
                    result, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    guard let user = result?.user else {
                        return
                    }
                    print("User UID: \(user.uid)\nUser Name: \(user.displayName ?? "No Name Provided")\nUser Email: \(user.email ?? "No Email Provided")")
                }
            }
        }
    }

extension ViewController {
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
=======


}

>>>>>>> 2ef088c (Initial Commit)
