//
//  HomeController.swift
//  Boraa
//
//  Created by Ahmed Abdeen on 11/12/2022.
//

import UIKit
import RxSwift
import LocalizationSystem
import SwiftKeychainWrapper
import OneSignal

class HomeController: UIViewController {

    // MARK: - View Model
    
    var viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    @IBOutlet weak var upcomingAppointmentsView: UIView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var hospitalNameLabel: UILabel!
    
    @IBOutlet weak var upcomingBooksTableView: UITableView!
    
    // MARK: - Variables
    
    var books = [Book]()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        getLoggedUserData()
    }
    
    private func initViews(){
        upcomingAppointmentsView.layer.cornerRadius = 10
    }
    
    private func clearUserData(){
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "accessToken")
        Global.sharedInstance.user = nil
        if removeSuccessful {
            Utility.openLogin()
        }
    }
    
    // MARK: - Server Work
    
    func getLoggedUserData(){
        
        Utility.showProgressDialog(view: self.view)
        
        let playerId = OneSignal.getDeviceState()?.userId
        
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        
        let params: [String: Any] =
        [
            "device_id": (deviceId ?? "ios_device"),
            "notification_token": playerId ?? "notificationToken",
            "time_zone": localTimeZoneIdentifier,
            "language": LocalizationSystem.sharedInstance().language() ?? "en"
        ]
        
        viewModel.getCurrentUser(params: params)
            .subscribe(onSuccess: { user in
                
                Utility.hideProgressDialog(view: self.view)
                
                Global.sharedInstance.user = user
                
                self.userName.text = user.name
                
                self.hospitalNameLabel.text = user.hospital?.name
                
                self.getMyUpcomingBooks()
                
            }, onError: { error in
                Utility.hideProgressDialog(view: self.view)
                Utility.openLogin()
            })
        .disposed(by: disposeBag)
        
    }
    
    func getMyUpcomingBooks(){
        viewModel.myUpcomingBooks()
            .subscribe(onSuccess: { books in
                self.books.removeAll()
                self.books.append(contentsOf: books)
                self.upcomingBooksTableView.reloadData()
            }, onError: { error in
                Utility.showAlertNew(message: NSLocalizedString("unknwon_error", comment: ""), context: self)
            })
        .disposed(by: disposeBag)
    }
    
    func confirmBook(bookId: Int){
        Utility.showProgressDialog(view: self.view)
        
        let params: [String: Any] =
            ["book_id": bookId
        ]
        
        viewModel.confirmBook(params: params)
            .subscribe(onCompleted: {
                Utility.hideProgressDialog(view: self.view)
                self.getMyUpcomingBooks()
                let alert = UIAlertController(title: "", message: NSLocalizedString("appointment_confirmed", comment: ""), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: NSLocalizedString("okay", comment: ""), style: UIAlertAction.Style.default) {
                        UIAlertAction in
                    
                    }
                
                alert.addAction(okAction)
                self.present(alert, animated: true)
                
            }, onError: { error in
                Utility.hideProgressDialog(view: self.view)
                Utility.showAlertNew(message: NSLocalizedString("unknown_error", comment: ""), context: self)
            })
        .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    
    @IBAction func didTapMenuBtn(_ sender: UIButton) {
        
        var uiActions = [UIAction]()
        
        if LocalizationSystem.sharedInstance().language() == "ar" {
            
            uiActions.append(UIAction(title: "تغيير اللغة", handler: { action in
                self.didTapUpdateLanguage()
            }))
            
            uiActions.append(UIAction(title: "تسجيل الخروج", handler: { action in
                self.logout()
            }))
            
            
            
        }else{
            uiActions.append(UIAction(title: "Update language", handler: { action in
                self.didTapUpdateLanguage()
            }))
            
            uiActions.append(UIAction(title: "Logout", handler: { action in
                self.logout()
            }))
        }
        
        
        if #available(iOS 14.0, *) {
            sender.showsMenuAsPrimaryAction = true
            sender.menu = UIMenu(title: "", children: uiActions)
        }
        
    }
    
    @IBAction func didTapConfirmAppointment(_ sender: UIButton) {
        
        let confirmAlert = UIAlertController(title: "", message: NSLocalizedString("confirm_appointment", comment: ""), preferredStyle: UIAlertController.Style.alert)

        confirmAlert.addAction(UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default, handler: { (action: UIAlertAction!) in
            self.confirmBook(bookId: sender.tag)
        }))

        confirmAlert.addAction(UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .default, handler: nil))

        present(confirmAlert, animated: true, completion: nil)
        
    }
    
    func didTapUpdateLanguage() {
        let alert = UIAlertController(title: NSLocalizedString("change_language", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "English", style: .default, handler: { (action) in
            LocalizationSystem.sharedInstance().setLanguage("en")
            Utility.showAlertNew(message:
                                    NSLocalizedString("restart_application", comment: ""),
                                 context: self)
        }))
        alert.addAction(UIAlertAction(title: "العربية", style: .default, handler: { (action) in
            LocalizationSystem.sharedInstance().setLanguage("ar")
            Utility.showAlertNew(message: NSLocalizedString("restart_application", comment: ""),
                                 context: self)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func logout(){
        let alert = UIAlertController(title: "", message: NSLocalizedString("logout_msg", comment: ""), preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: UIAlertAction.Style.default) {
                UIAlertAction in
            self.clearUserData()
            }
        
        let noAction = UIAlertAction(title: NSLocalizedString("no", comment: ""), style: UIAlertAction.Style.destructive) {
                UIAlertAction in
            alert.dismiss(animated: true)
            }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true)
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

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingAppointmentCell", for: indexPath) as! UpcomingAppointmentCell
        
        let book = books[indexPath.row]
        
        cell.rootView.backgroundColor = .white
        cell.rootView.layer.cornerRadius = 13
        cell.dayLabel.text = book.day!
        cell.dateTimeLabel.text = "\(book.dateFormatted!) | \(book.timeFormatted!)"
        cell.clinicLabel.text = book.clinic!.name!
        
        cell.confirmAppointmentBtn.tag = book.id!
        cell.confirmAppointmentBtn.layer.cornerRadius = 17.5
        
        if book.isConfirmed == 0 {
            cell.confirmAppointmentBtn.isHidden = false
            cell.confirmedLabel.isHidden = true
        }else if book.isConfirmed == 1 {
            cell.confirmAppointmentBtn.isHidden = true
            cell.confirmedLabel.isHidden = false
            cell.confirmedLabel.text = "Confirmed"
            cell.confirmedLabel.textColor = UIColor(named: "Primary")
        }else if book.isConfirmed == 2 {
            cell.confirmAppointmentBtn.isHidden = true
            cell.confirmedLabel.isHidden = false
            cell.confirmedLabel.text = "Cancelled"
            cell.confirmedLabel.textColor = .red
        }
        
        let hospital = Global.sharedInstance.user!.hospital
        cell.hospitalLabel.text = hospital?.name
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
        
    }
 
}
