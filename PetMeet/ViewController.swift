//
//  ViewController.swift
//  PetMeet
//
//  Created by Henry Bao on 5/24/22.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
import CryptoKit

fileprivate var currentNonce: String?

class ViewController: UIViewController {
    private let signInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
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
        print(error)
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
            
            let firstName = credential.fullName?.givenName
            let lastName = credential.fullName?.familyName
            let email = credential.email
            
            self.hasAccount(firstName: firstName, lastName: lastName, email: email)
        }
    }
    
    func hasAccount(firstName: String?, lastName: String?, email: String?) {
        guard ((Auth.auth().currentUser?.uid) != nil) else { return }
//        let vc = UIViewController()
//        vc.view.backgroundColor = .orange
//        navigationController?.pushViewController(vc, animated: true)
    }
}
