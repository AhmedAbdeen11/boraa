import UIKit
import RxSwift

class AppointmentsController: UIViewController {

    // MARK: - View Model
    
    var viewModel = AppointmentsViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    @IBOutlet weak var bookAppointmentView: UIView!
    
    @IBOutlet weak var waitingListView: UIView!
    
    @IBOutlet weak var appointmentsTableView: UITableView!
    
    // MARK: - Variables
    
    var books = [Book]()
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getMyBooks()
    }

    private func initViews(){
        bookAppointmentView.layer.cornerRadius = 10
        waitingListView.layer.cornerRadius = 10
    }
    
    // MARK: - Actions
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        let confirmAlert = UIAlertController(title: "", message: "Are you sure you want to cancel this appointment?", preferredStyle: UIAlertController.Style.alert)

        confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.cancelBook(bookId: sender.tag)
        }))

        confirmAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))

        present(confirmAlert, animated: true, completion: nil)
    }
    
    @IBAction func didTapReschedule(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showRescheduleController", sender: sender.tag)
    }
    
    
    // MARK: - Server Work
    
    func getMyBooks(){
        viewModel.myBooks()
            .subscribe(onSuccess: { books in
                self.books.removeAll()
                self.books.append(contentsOf: books)
                self.appointmentsTableView.reloadData()
            }, onError: { error in
                Utility.showAlertNew(message: "Unknown Error!", context: self)
            })
        .disposed(by: disposeBag)
    }
    
    func cancelBook(bookId: Int){
        Utility.showProgressDialog(view: self.view)
        
        let params: [String: Any] =
            ["book_id": bookId
        ]
        
        viewModel.cancelBook(params: params)
            .subscribe(onCompleted: {
                Utility.hideProgressDialog(view: self.view)
                self.getMyBooks()
                let alert = UIAlertController(title: "", message: "Appointment cancelled...", preferredStyle: .alert)
                
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRescheduleController" {
            let selectDateTimeController = segue.destination as? SelectDateTimeController
            selectDateTimeController?.book = books[sender as! Int]
        }
    }

}

extension AppointmentsController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.books.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentCell
        
        let book = books[indexPath.row]
        
        cell.rootView.backgroundColor = .white
        cell.rootView.layer.cornerRadius = 13
        cell.dayLabel.text = book.day!
        cell.dateTimeLabel.text = "\(book.dateFormatted!) | \(book.time!)"
        cell.clinicLabel.text = book.clinic!.name!
        
        cell.cancelBtn.tag = book.id!
        cell.rescheduleBtn.tag = indexPath.row
        
        let hospital = Global.sharedInstance.user!.hospital
        cell.hospitalLabel.text = hospital?.name
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
        
    }
 
}
