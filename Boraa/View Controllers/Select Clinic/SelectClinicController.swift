//
//  SelectClinicController.swift
//  Boraa
//
//  Created by Ahmed Abdeen on 12/12/2022.
//

import UIKit
import RxSwift

class SelectClinicController: UIViewController {

    // MARK: - View Model
    
    var viewModel = SelectClinicViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    @IBOutlet weak var selectClinicBackground: UIView!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var clinicsTableView: UITableView!
    
    @IBOutlet weak var selectClinicLabel: UILabel!
    
    // MARK: - Variables
    
    var clinics = [Clinic]()
    
    var selectedClinic: Clinic? = nil
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        getClinics()
    }
    
    private func initViews(){
        btnContinue.layer.cornerRadius = 20
        selectClinicBackground.layer.cornerRadius = 10
        selectClinicBackground.addShadow()
        
        clinicsTableView.layer.cornerRadius = 10
        clinicsTableView.addShadow()
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSelectClinic(_ sender: Any) {
        if clinicsTableView.isHidden {
            clinicsTableView.isHidden = false
        }else{
            clinicsTableView.isHidden = true
        }
    }

    @IBAction func didTapContinueBtn(_ sender: Any) {
        if selectedClinic != nil {
            self.performSegue(withIdentifier: "showSelectDateTimeSegue", sender: nil)
        }
    }
    
    // MARK: - Server Work
    
    func getClinics(){
        Utility.showProgressDialog(view: self.view)
        viewModel.getClincs()
            .subscribe(onSuccess: { clinics in
                Utility.hideProgressDialog(view: self.view)
                self.clinics.removeAll()
                self.clinics.append(contentsOf: clinics)
                self.clinicsTableView.reloadData()
            }, onError: { error in
                Utility.hideProgressDialog(view: self.view)
                Utility.showAlert(message: "Unknown Error!")
            })
        .disposed(by: disposeBag)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectDateTimeController = segue.destination as? SelectDateTimeController {
            selectDateTimeController.selectedClinic = selectedClinic!.id!
        }
    }


}

extension SelectClinicController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.clinics.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedClinic = self.clinics[indexPath.row]
        self.selectClinicLabel.text = self.selectedClinic?.name
        self.clinicsTableView.isHidden = true
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var clinic = self.clinics[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClinicCell", for: indexPath) as! ClinicCell
        
        cell.nameLabel.text = clinic.name
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
        
    }
 
}
