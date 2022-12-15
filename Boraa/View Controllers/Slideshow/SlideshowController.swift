//
//  SlideshowController.swift
//  Boraa
//
//  Created by Ahmed Abdeen on 15/12/2022.
//

import UIKit
import RxSwift
import ImageSlideshow

class SlideshowController: UIViewController {

    // MARK: - View Model
    
    var viewModel = SlideshowViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    @IBOutlet weak var slideShow: ImageSlideshow!
    
    // MARK: - Variables
    
    var medicalFiles = [MedicalFile]()
    
    var type = 1
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getMedicalFiles(type: type)
    }
    
    
    // MARK: - Actions
    
    // MARK: - Server Work

    func getMedicalFiles(type: Int){
        Utility.showProgressDialog(view: self.view)
        
        let params: [String: Any] =
            ["type": type]
        
        viewModel.getMedicalFiles(params: params)
            .subscribe(onSuccess: { medicalFiles in
                Utility.hideProgressDialog(view: self.view)
                self.medicalFiles.removeAll()
                self.medicalFiles.append(contentsOf: medicalFiles)
                
                var imgs = [AlamofireSource]()
                
                for medicalFile in self.medicalFiles {
                    imgs.append(AlamofireSource(urlString: medicalFile.image!)!)
                }
                
                self.slideShow.contentScaleMode = .scaleToFill
                self.slideShow.setImageInputs(imgs)
                
            }, onError: { error in
                Utility.hideProgressDialog(view: self.view)
                Utility.showAlertNew(message: "Unknown Error!", context: self)
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

//MARK: - Extensions
