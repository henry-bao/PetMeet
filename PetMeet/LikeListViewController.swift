//
//  LikeListViewController.swift
//  PetMeet
//
//  Created by Henry Bao on 5/24/22.
//

import UIKit
import FirebaseStorage
import Firebase

class LikeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let firestore = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    var userData: [String : Any] = [:]
    var usersLikedMyPet: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        likeListTable.delegate = self
        likeListTable.dataSource = self
        setLoadingScreen()
        loadUserData()
        
        likeListTable.refreshControl = UIRefreshControl()
        likeListTable.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @IBOutlet weak var likeListTable: UITableView!
    @IBOutlet weak var likeListSwitch: UISegmentedControl!
    
    @IBAction func didClickLikeListSwitch(_ sender: Any) {
        likeListTable.reloadData()
    }
    
    @objc private func didPullToRefresh() {
        loadUserData()
        DispatchQueue.main.async {
            self.likeListTable.refreshControl?.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if likeListSwitch.selectedSegmentIndex == 0 {
            return (userData["like list"] as? [String])?.count ?? 0
        } else {
            return usersLikedMyPet.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LikeListTableViewCell
        if let ViewOtherVC = storyboard?.instantiateViewController(withIdentifier: "ViewOtherVC") as? ViewOtherProfileViewController {
            self.navigationController?.pushViewController(ViewOtherVC, animated: true)
            ViewOtherVC.userID = cell.userId
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch likeListSwitch.selectedSegmentIndex {
        case 0:
            let cell: LikeListTableViewCell = likeListTable.dequeueReusableCell(withIdentifier: "likeListCell") as! LikeListTableViewCell
            let petId = (userData["like list"] as? [String])?[indexPath.row]
            firestore.collection("users").getDocuments { (snapshot, error) in
                if error != nil {
                    print(error.debugDescription)
                }
                if error == nil && snapshot != nil {
                    for i in 0...snapshot!.documents.count - 1 {
                        let userId = snapshot!.documents[i].documentID
                        self.firestore.collection("users").document(userId).collection("pets").getDocuments { (snapshot, error) in
                            if error == nil && snapshot != nil {
                                for j in 0...snapshot!.documents.count - 1 {
                                    if (snapshot!.documents[j].documentID == petId) {
                                        cell.userId = userId
                                        cell.nameLabel.text = (snapshot!.documents[j].data()["name"] as? String)!
                                        cell.ageLabel.text = "\((snapshot!.documents[j].data()["age"] as? String)!) years old"
                                        self.storage.child("images/\(userId).png").getData(maxSize: 3 * 1024 * 1024) { (data, error) in
                                            if error == nil {
                                                let image = UIImage(data: data!)
                                                cell.petImage.image = image
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return cell
            
        case 1:
            if usersLikedMyPet.count > 0 {
                let userId = usersLikedMyPet[indexPath.row]
                let cell: LikeListTableViewCell = likeListTable.dequeueReusableCell(withIdentifier: "likeListCell") as! LikeListTableViewCell
                firestore.collection("users").document(userId).collection("pets").getDocuments { (snapshot, error) in
                    if error == nil && snapshot != nil {
                        for j in 0...snapshot!.documents.count - 1 {
                            cell.userId = userId
                            cell.nameLabel.text = (snapshot!.documents[j].data()["name"] as? String)!
                            cell.ageLabel.text = "\((snapshot!.documents[j].data()["age"] as? String)!) years old"
                            self.storage.child("images/\(userId).png").getData(maxSize: 3 * 1024 * 1024) { (data, error) in
                                if error == nil {
                                    let image = UIImage(data: data!)
                                    cell.petImage.image = image
                                }
                            }
                        }
                    }
                }
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    private func loadUserData() {
        userData = [:]
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let docRef = firestore.collection("users").document(uid)
            docRef.getDocument { (document, error) in
                guard error == nil else {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                if let document = document, document.exists {
                    let data = document.data()
                    self.userData = data ?? [:]
                    self.getUsersLikedMyPet()
                }
            }
        }
    }

    private func getUsersLikedMyPet() {
        self.usersLikedMyPet = []
        let uid = (Auth.auth().currentUser?.uid)!
        firestore.collection("users").document(uid).collection("pets").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                let petId = snapshot?.documents[0].documentID
                self.firestore.collection("users").getDocuments { (snapshot, error) in
                    if error == nil && snapshot != nil {
                         for i in 0...snapshot!.documents.count - 1 {
                             let userId = snapshot!.documents[i].documentID
                             if (snapshot!.documents[i].data()["like list"] as? [String])?.contains(petId!) ?? false {
                                 self.usersLikedMyPet.append(userId)
                                 self.likeListTable.reloadData()
                             }
                         }
                    }
                }
            }
        }
        self.removeLoadingScreen()
    }

    
    private func setLoadingScreen() {
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (likeListTable.frame.width / 2) - (width / 2)
        let y = (likeListTable.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x - 15, y: y, width: width, height: height)

        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)

        spinner.style = UIActivityIndicatorView.Style.medium
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()

        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        likeListTable.addSubview(loadingView)

      }

    private func removeLoadingScreen() {
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
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
