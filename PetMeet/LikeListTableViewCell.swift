//
//  LikeListTableViewCell.swift
//  PetMeet
//
//  Created by Henry Bao on 6/5/22.
//

import UIKit

class LikeListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var userId: String = ""
        
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    
}
