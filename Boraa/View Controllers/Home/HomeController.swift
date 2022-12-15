//
//  HomeController.swift
//  Boraa
//
//  Created by Ahmed Abdeen on 11/12/2022.
//

import UIKit
import RxSwift

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
    
    // MARK: - Server Work
    
    func getLoggedUserData(){
        
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        
        let params: [String: Any] =
        [
            "device_id": (deviceId ?? "ios_device"),
            "notification_token": "notificationToken"
        ]
        
        viewModel.getCurrentUser(params: params)
            .subscribe(onSuccess: { user in
                
                Global.sharedInstance.user = user
                
                self.userName.text = user.name
                
                self.hospitalNameLabel.text = user.hospital?.name
                
                self.getMyUpcomingBooks()
                
            }, onError: { error in
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
                Utility.showAlertNew(message: "Unknown Error!", context: self)
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
                let alert = UIAlertController(title: "", message: "Appointment confirmed...", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                    
                    }
                
                alert.addAction(okAction)
                self.present(alert, animated: true)
                
            }, onError: { error in
                Utility.hideProgressDialog(view: self.view)
                Utility.showAlertNew(message: "Unknown Error!", context: self)
            })
        .disposed(by: disposeBag)
    }
    
    // MARK: - Actions

    @IBAction func didTapConfirmAppointment(_ sender: UIButton) {
        
        let confirmAlert = UIAlertController(title: "", message: "Are you sure you want to confirm this appointment?", preferredStyle: UIAlertController.Style.alert)

        confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.confirmBook(bookId: sender.tag)
        }))

        confirmAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))

        present(confirmAlert, animated: true, completion: nil)
        
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
        cell.dateTimeLabel.text = "\(book.dateFormatted!) | \(book.time!)"
        cell.clinicLabel.text = book.clinic!.name!
        
        cell.confirmAppointmentBtn.tag = book.id!
        cell.confirmAppointmentBtn.layer.cornerRadius = 17.5
        
        if book.isConfirmed! {
            cell.confirmAppointmentBtn.isHidden = true
            cell.confirmedLabel.isHidden = false
        }else{
            cell.confirmAppointmentBtn.isHidden = false
            cell.confirmedLabel.isHidden = true
        }
        
        let hospital = Global.sharedInstance.user!.hospital
        cell.hospitalLabel.text = hospital?.name
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
        
    }
 
}
