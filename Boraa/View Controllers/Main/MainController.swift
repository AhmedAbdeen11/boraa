//
//  ViewController.swift
//  Boraa
//
//  Created by Ahmed Abdeen on 11/12/2022.
//

import UIKit

class MainController: UIViewController {

    @IBOutlet weak var homeContainer: UIView!
    
    @IBOutlet weak var appointmentContainer: UIView!
    
    @IBOutlet weak var medicalFileContainer: UIView!
    
    @IBOutlet weak var homeImage: UIImageView!
    
    @IBOutlet weak var appointmentsImage: UIImageView!
    
    @IBOutlet weak var medicalFileImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func didTapHome(_ sender: Any) {
        homeContainer.isHidden = false
        appointmentContainer.isHidden = true
        medicalFileContainer.isHidden = true
        
        homeImage.image = UIImage(named: "home_selected")
        appointmentsImage.image = UIImage(named: "appointments")
        medicalFileImage.image = UIImage(named: "medical_file")
    }

    @IBAction func didTapAppointment(_ sender: Any) {
        homeContainer.isHidden = true
        appointmentContainer.isHidden = false
        medicalFileContainer.isHidden = true
        
        homeImage.image = UIImage(named: "home")
        appointmentsImage.image = UIImage(named: "appointments_selected")
        medicalFileImage.image = UIImage(named: "medical_file")
    }
    
    @IBAction func didTapMedicalFile(_ sender: Any) {
        homeContainer.isHidden = true
        appointmentContainer.isHidden = true
        medicalFileContainer.isHidden = false
        
        homeImage.image = UIImage(named: "home")
        appointmentsImage.image = UIImage(named: "appointments")
        medicalFileImage.image = UIImage(named: "medical_file_selected")
    }
    
    
    
}

