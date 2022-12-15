//
//  SelectDateTimeController.swift
//  Boraa
//
//  Created by Ahmed Abdeen on 12/12/2022.
//

import UIKit
import FSCalendar
import RxSwift

class SelectDateTimeController: UIViewController {

    // MARK: - View Model
    
    var viewModel = SelectDateTimeViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    @IBOutlet weak var calendarView: FSCalendar!
    
    @IBOutlet weak var btnBook: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var timesCollectionView: UICollectionView!
    
    // MARK: - Variables
    
    var availableTimes = [String]()
    
    var formatter = DateFormatter()
    
    var selectedDate = ""
    
    var selectedTime: String? = nil
    
    var selectedClinic = 1
    
    var book: Book? = nil
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        getAvailableTimes()
    }

    private func initViews(){
        calendarView.layer.cornerRadius = 10
        calendarView.addShadow()
        
        btnBack.layer.cornerRadius = 20
        btnBook.layer.cornerRadius = 20
        
        timesCollectionView.isScrollEnabled = false
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        formatter.dateFormat = "yyyy-MM-dd"
        selectedDate = formatter.string(from: Date())
    }
    
    // MARK: - Actions
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapBookBtn(_ sender: Any) {
        if selectedTime != nil {
            if book == nil {
                saveBook()
            }else{
                rescheduleBook()
            }
        }else{
            Utility.showAlertNew(message: "Please select time", context: self)
        }
    }
    
    // MARK: - Server Work
    
    func getAvailableTimes(){
        Utility.showProgressDialog(view: self.view)
        
        let params: [String: Any] =
            ["date": selectedDate,
             "clinic_id": selectedClinic
        ]
        
        viewModel.getAvailableTimes(params: params)
            .subscribe(onSuccess: { availableTimes in
                Utility.hideProgressDialog(view: self.view)
                self.availableTimes.removeAll()
                self.availableTimes.append(contentsOf: availableTimes)
                self.timesCollectionView.reloadData()
            }, onError: { error in
                Utility.hideProgressDialog(view: self.view)
                Utility.showAlertNew(message: "Unknown Error!", context: self)
            })
        .disposed(by: disposeBag)
    }
    
    func saveBook(){
        Utility.showProgressDialog(view: self.view)
        
        let params: [String: Any] =
            ["date": selectedDate,
             "time": selectedTime!,
             "clinic_id": selectedClinic
        ]
        
        viewModel.book(params: params)
            .subscribe(onCompleted: {
                Utility.hideProgressDialog(view: self.view)
                let alert = UIAlertController(title: "", message: "Appointment booked", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                    self.navigationController?.popToRootViewController(animated: true)
                    }
                
                alert.addAction(okAction)
                self.present(alert, animated: true)
                
            }, onError: { error in
                Utility.hideProgressDialog(view: self.view)
                Utility.showAlertNew(message: "Unknown Error!", context: self)
            })
        .disposed(by: disposeBag)
    }
    
    func rescheduleBook(){
        Utility.showProgressDialog(view: self.view)
        
        let params: [String: Any] =
            ["date": selectedDate,
             "time": selectedTime!,
             "book_id": book!.id!
        ]
        
        viewModel.rescheduleBook(params: params)
            .subscribe(onCompleted: {
                Utility.hideProgressDialog(view: self.view)
                let alert = UIAlertController(title: "", message: "Appointment rescheduled", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                    self.navigationController?.popToRootViewController(animated: true)
                    }
                
                alert.addAction(okAction)
                self.present(alert, animated: true)
                
            }, onError: { error in
                Utility.hideProgressDialog(view: self.view)
                Utility.showAlertNew(message: "Unknown Error!", context: self)
            })
        .disposed(by: disposeBag)
    }
    
}

//MARK: - Extensions

extension SelectDateTimeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.availableTimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.timesCollectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as! TimeCell
        
        cell.timeLabel.text = availableTimes[indexPath.row]
        cell.rootView.layer.cornerRadius = 15
        
        if selectedTime == availableTimes[indexPath.row] {
            cell.rootView.backgroundColor = UIColor(named: "Primary")
        }else{
            cell.rootView.backgroundColor = .white
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedTime = availableTimes[indexPath.row]
        self.timesCollectionView.reloadData()
    }
    
//    //To make this work. You have to make Estimate size = none for collection view in storyboard
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: CGFloat(100), height: CGFloat(50))
//    }
    
    //Fixes collectionview paging
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension SelectDateTimeController: FSCalendarDelegate, FSCalendarDataSource {
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = formatter.string(from: date)
        self.getAvailableTimes()
    }
    
}
