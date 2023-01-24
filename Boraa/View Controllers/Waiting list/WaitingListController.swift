//
//  WaitingListController.swift
//  Boraa
//
//  Created by Ahmed Abdeen on 25/12/2022.
//

import UIKit
import FSCalendar
import RxSwift

class WaitingListController: UIViewController {

    // MARK: - View Model
    
    var viewModel = WaitingListViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    @IBOutlet weak var selectClinicBackground: UIView!
    
    @IBOutlet weak var btnBookAtWaitingListBtn: UIButton!
    
    @IBOutlet weak var clinicsTableView: UITableView!
    
    @IBOutlet weak var selectClinicLabel: UILabel!
    
    @IBOutlet weak var calendarView: FSCalendar!
    
    // MARK: - Variables
    
    var clinics = [Clinic]()
    
    var formatter = DateFormatter()
    
    var selectedClinic: Clinic? = nil
    
    var selectedDate = ""
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        getClinics()
    }
    
    private func initViews(){
        btnBookAtWaitingListBtn.layer.cornerRadius = 20
        selectClinicBackground.layer.cornerRadius = 10
        selectClinicBackground.addShadow()
        
        clinicsTableView.layer.cornerRadius = 10
        clinicsTableView.addShadow()
        
        formatter.dateFormat = "yyyy-MM-dd"
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSelectClinic(_ sender: Any) {
        if clinicsTableView.isHidden {
            clinicsTableView.isHidden = false
            calendarView.isHidden = true
            btnBookAtWaitingListBtn.isHidden = true
        }else{
            clinicsTableView.isHidden = true
            calendarView.isHidden = false
            btnBookAtWaitingListBtn.isHidden = false
        }
    }

    @IBAction func didTapBookAtWaitingListBtn(_ sender: Any) {
        
        if selectedClinic == nil {
            Utility.showAlertNew(message: NSLocalizedString("select_clinic", comment: ""), context: self)
        } else if selectedDate.isEmpty {
            Utility.showAlertNew(message: NSLocalizedString("select_date", comment: ""), context: self)
        } else {
            saveBook()
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
                Utility.showAlert(message: NSLocalizedString("unknown_error", comment: ""))
            })
        .disposed(by: disposeBag)
    }

    func saveBook(){
        Utility.showProgressDialog(view: self.view)
        
        let params: [String: Any] =
            ["date": selectedDate,
             "clinic_id": selectedClinic!.id!
        ]
        
        viewModel.bookAtWaitingList(params: params)
            .subscribe(onCompleted: {
                Utility.hideProgressDialog(view: self.view)
                let alert = UIAlertController(title: "", message: NSLocalizedString("added_to_waiting_list_message", comment: ""), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: NSLocalizedString("okay", comment: ""), style: UIAlertAction.Style.default) {
                        UIAlertAction in
                    self.navigationController?.popToRootViewController(animated: true)
                    }
                
                alert.addAction(okAction)
                self.present(alert, animated: true)
                
            }, onError: { error in
                Utility.hideProgressDialog(view: self.view)
                Utility.showAlertNew(message: NSLocalizedString("unknown_error", comment: ""), context: self)
            })
        .disposed(by: disposeBag)
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

extension WaitingListController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.clinics.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedClinic = self.clinics[indexPath.row]
        self.selectClinicLabel.text = self.selectedClinic?.name
        self.clinicsTableView.isHidden = true
        calendarView.isHidden = false
        btnBookAtWaitingListBtn.isHidden = false
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

extension WaitingListController: FSCalendarDelegate, FSCalendarDataSource {
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date().dayAfter
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = formatter.string(from: date)
    }
    
}
