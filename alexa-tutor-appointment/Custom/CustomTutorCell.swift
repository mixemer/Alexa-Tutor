//
//  CustomTutorCell.swift
//  alexa-tutor-appointment
//
//  Created by Mehmet Sahin on 4/20/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import UIKit

class CustomTutorCell: UITableViewCell {

    @IBOutlet weak var tutorName: UILabel!
    @IBOutlet weak var classCode: UILabel!
    @IBOutlet weak var availability: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
