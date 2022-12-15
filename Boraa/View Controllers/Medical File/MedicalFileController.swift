//
//  MedicalFileController.swift
//  Boraa
//
//  Created by Ahmed Abdeen on 11/12/2022.
//

import UIKit
import RxSwift

class MedicalFileController: UIViewController {

    // MARK: - View Model
    
    var viewModel = MedicalFileViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    @IBOutlet weak var viewLabResults: UIView!
    
    @IBOutlet weak var viewRadiologyResult: UIView!
    
    @IBOutlet weak var viewMedicinesPre: UIView!
    
    @IBOutlet weak var viewSickLeave: UIView!
    
    @IBOutlet weak var viewMedicalReport: UIView!
    
    // MARK: - Variables
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }
    
    private func initViews(){
        viewLabResults.layer.cornerRadius = 10
        viewRadiologyResult.layer.cornerRadius = 10
        viewMedicinesPre.layer.cornerRadius = 10
        viewSickLeave.layer.cornerRadius = 10
        viewMedicalReport.layer.cornerRadius = 10
    }
    
    // MARK: - Server Work
    
    
    
    // MARK: - Actions
    
    @IBAction func didTapLabResults(_ sender: Any) {
        self.performSegue(withIdentifier: "showSlideshowController", sender: 1)
    }
    
    @IBAction func didTapRadiologyResult(_ sender: Any) {
        self.performSegue(withIdentifier: "showSlideshowController", sender: 2)
    }
    
    @IBAction func didTapMedicinesPre(_ sender: Any) {
        self.performSegue(withIdentifier: "showSlideshowController", sender: 3)
    }
    
    @IBAction func didTapSickLeaves(_ sender: Any) {
        self.performSegue(withIdentifier: "showSlideshowController", sender: 4)
    }
    
    @IBAction func didTapMedicalReport(_ sender: Any) {
        self.performSegue(withIdentifier: "showSlideshowController", sender: 5)
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showSlideshowController" {
            
            let slideShowController = segue.destination as? SlideshowController
            
            slideShowController?.type = sender as! Int
            
        }
        
    }

}
