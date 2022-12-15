//
//  LoginController.swift
//  Boraa
//
//  Created by Ahmed Abdeen on 11/12/2022.
//

import UIKit
import RxSwift

class LoginController: UIViewController {

    // MARK: - View Model
    
    var viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    @IBOutlet weak var medicalNumberTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    
    // MARK: - Variables
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Validate
    
    private func validateForm() -> Bool {
        
        if(medicalNumberTextField.text!.isEmpty || phoneNumberTextField.text!.isEmpty){
            Utility.showAlertNew(message: "Please enter your email and password", context: self)
            return false
        }
        
        return true
        
    }
    
    // MARK: - Network
    
    private func login(){
                
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        
        Utility.showProgressDialog(view: self.view)
        
        let params: [String: Any] =
            ["medical_number": (medicalNumberTextField.text ?? ""),
             "phone_number": (phoneNumberTextField.text ?? ""),
             "device_id": (deviceId ?? "ios_device"),
             "notification_token": "notificationToken"
        ]
        
        viewModel.login(params: params)
            .subscribe(onSuccess: { message in
                
                Utility.hideProgressDialog(view: self.view)
                
                let alert = UIAlertController(title: "", message: "Login success...", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        Utility.openMainPageController()
                    }
                
                alert.addAction(okAction)
                self.present(alert, animated: true)
                
            }, onError: { (error) in
                Utility.hideProgressDialog(view: self.view)
                Utility.showAlertNew(message: "Login failed. Please make sure of the medical number and the phone number", context: self)
            })
        .disposed(by: disposeBag)
    }
    
    // MARK: - Actions

    @IBAction func didTapLoginBtn(_ sender: Any) {
        if validateForm() {
            login()
        }
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
