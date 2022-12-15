//
//  AppointmentCell.swift
//  Boraa
//
//  Created by Ahmed Abdeen on 15/12/2022.
//

import UIKit

class AppointmentCell: UITableViewCell {
    
    @IBOutlet weak var rootView: UIView!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var clinicLabel: UILabel!
    
    @IBOutlet weak var hospitalLabel: UILabel!

    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var rescheduleBtn: UIButton!
    
}
