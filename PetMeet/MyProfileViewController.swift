//
//  MyProfileViewController.swift
//  PetMeet
//
//  Created by Henry Bao on 5/24/22.
//

import UIKit

//class profile {
//    var section: String?
//    var detail: [String]?
//
//    init(section: String, detail: [String]) {
//        self.section = section
//        self.detail = detail
//    }
//
//}

class MyProfileViewController: UIViewController{

    
    
    
    
//    let contactInfo = [("Email"), ("Phone Number"), ("Zip Code")]
//    let petInfo = [("Name+age"), ("Breed"), ("Gender")]
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return contactInfo.count
//        } else {
//            return petInfo.count
//        }
//    }
//
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell = UITableViewCell()
//
//        if indexPath.section == 0{
//            var userDetail = contactInfo[indexPath.row]
//            cell.textLabel?.text = userDetail
//        } else {
//            var petDetail = petInfo[indexPath.row]
//            cell.textLabel?.text = petDetail
//        }
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Contact Information"
//        } else {
//            return "Pet"
//        }
//    }
    
//    var personalInfo = [profile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        tableView.delegate = self
//        tableView.dataSource = self
//        personalInfo.append(profile.init(section: "Contact Information", detail: ["Email", "Phone Number", "Zip Code"]))
//        personalInfo.append(profile.init(section: "Pet", detail: ["Name + Age", "Breed", "Gender"]))
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

//extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return personalInfo.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return 3
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = personalInfo[indexPath.section].detail?[indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return personalInfo[section].section
//    }
//
//
//}
