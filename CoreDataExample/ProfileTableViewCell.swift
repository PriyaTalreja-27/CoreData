//
//  ProfileTableViewCell.swift
//  CoreDataExample
//
//  Created by Priya Talreja on 04/06/17.
//  Copyright © 2017 Priya Talreja. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
