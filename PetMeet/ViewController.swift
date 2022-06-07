//
//  ViewController.swift
//  PetMeet
//
//  Created by Henry Bao on 5/24/22.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore
import CryptoKit

fileprivate var currentNonce: String?

class ViewController: UIViewController {
    private let signInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    private let firedb = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // if user is already logged in, skip the login screen
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            let email = user.email
            self.firedb.collection("users").document(uid).getDocument{ (document, error) in
                if error == nil {
                    if document != nil && document!.exists {
                        let documentData = document!.data()
                        if let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? tabBarViewController {
                            tabVC.firstName = (documentData!["first name"] as? String)!
                            tabVC.lastName = (documentData!["last name"] as? String)!
                            tabVC.email = email!
                            tabVC.userID = uid
                            tabVC.zipCode = documentData!["zip code"] as! String
                            self.navigationController?.pushViewController(tabVC, animated: true)
                        }
                    }
                }
            }
        } else {
            setupView()
        }
    }
}

private extension ViewController {
    func setupView() {
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.cornerRadius = 6.0
        signInButton.addTarget(self, action: #selector(handleAppleRequest), for: .touchUpInside)
        view.addSubview(signInButton)
        
        signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -72.0).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 52.0).isActive = true
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

private extension ViewController {
    @objc func handleAppleRequest() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.performRequests()
        
        func randomNonceString(length: Int = 32) -> String {
          precondition(length > 0)
          let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
          var result = ""
          var remainingLength = length

          while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
              var random: UInt8 = 0
              let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
              if errorCode != errSecSuccess {
                fatalError(
                  "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
              }
              return random
            }

            randoms.forEach { random in
              if remainingLength == 0 {
                return
              }

              if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
              }
            }
          }

          return result
        }
        
        @available(iOS 13, *)
        func sha256(_ input: String) -> String {
          let inputData = Data(input.utf8)
          let hashedData = SHA256.hash(data: inputData)
          let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
          }.joined()

          return hashString
        }
    }
}

extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let alert = UIAlertController(title: "Error", message: "Could not sign you in", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let nonce = currentNonce else {
            return
        }
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        guard let token = credential.identityToken else {
            return
        }
        guard let tokenString = String(data: token, encoding: .utf8) else {
            return
        }
        let oAuth = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        
        Auth.auth().signIn(with: oAuth) { (result, error) in
                        
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not sign you in", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                return
            }
            
            var lastName = credential.fullName?.familyName
            var firstName = credential.fullName?.givenName
            let email = result?.user.email
            let userID = result?.user.uid
            var zipCode = ""
            let likeList: [String] = []

            // user signed in for the first time
            if firstName != nil && lastName != nil {
                let newUserDoc = self.firedb.collection("users").document(userID!)
                newUserDoc.setData(["uid": userID!, "email": email!, "first name": firstName!, "last name": lastName!, "zip code": zipCode, "like list": likeList])
                self.firedb.collection("users").document(userID!).collection("pets").document().setData(["name": "", "age":"", "category":"","breed":"","gender":""])
                self.hasAccount(firstName: firstName!, lastName: lastName!, email: email!, uid: userID!, zipCode: zipCode)
            } else {
                self.firedb.collection("users").document(userID!).getDocument{ (document, error) in
                    if error == nil {
                        if document != nil && document!.exists {
                            let documentData = document!.data()
                            firstName = documentData!["first name"] as? String
                            lastName = documentData!["last name"] as? String
                            zipCode = documentData!["zip code"] as! String
                            self.hasAccount(firstName: firstName!, lastName: lastName!, email: email!, uid: userID!, zipCode: zipCode)
                        }
                    }
                }
            }
        }
    }
    
    func hasAccount(firstName: String?, lastName: String?, email: String?, uid: String?, zipCode: String?) {
        guard ((Auth.auth().currentUser?.uid) != nil) else { return }
        if let tabVC = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? tabBarViewController {
            tabVC.firstName = firstName!
            tabVC.lastName = lastName!
            tabVC.email = email!
            tabVC.userID = uid!
            tabVC.zipCode = zipCode!
            self.navigationController?.pushViewController(tabVC, animated: true)
        }
    }
}
