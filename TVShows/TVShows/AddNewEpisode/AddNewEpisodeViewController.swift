//
//  AddNewEpisodeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 24/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

protocol TVShowDetailsDelegate: class {
    func reloadEpisodes()
}

class AddNewEpisodeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var episodeTitleTextField: UITextField!
    @IBOutlet weak var seasonNumberTextField: UITextField!
    @IBOutlet weak var episodeNumberTextField: UITextField!
    @IBOutlet weak var episodeDescriptionTextField: UITextField!
    
    // MARK: - Public
    var loginData: LoginData?
    var showID: String?
    weak var delegate: TVShowDetailsDelegate?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTextFieldBorders()
    }
    
    // MARK: - IBActions
    @IBAction func uploadPhoto(_ sender: Any) {
        alertUser(title: "Oops",
                  message: "This feature is not implemented yet.",
                  warning: "Api sucks...")
    }
    
    // MARK: - objC Functions
    @objc func didSelectCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didSelectAdd() {
        guard
            let showID = showID,
            let token = loginData?.token,
            let episodeTitle = episodeTitleTextField.text,
            let seasonNumber = seasonNumberTextField.text,
            let episodeNumber = episodeNumberTextField.text,
            let episodeDescription = episodeDescriptionTextField.text
        else {
            return
        }
        
        if !allFieldsAreOk() {
            return
        }
        
        let headers = ["Authorization": token]
        let parameters = ["showId": showID,
                          "mediaId": "mediaID",
                          "title": episodeTitle,
                          "description": episodeDescription,
                          "episodeNumber": episodeNumber,
                          "season": seasonNumber
        ]
        
        SVProgressHUD.show()
        Alamofire.request("https://api.infinum.academy/api/episodes",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .validate()
            .responseJSON {  [weak self]  dataResponse in
                SVProgressHUD.dismiss()
                
                guard let `self` = self else { return }
                
                switch dataResponse.result {
                    
                    case .success(let response):
                        SwiftyLog.info("Sucess \(response)")
                        self.delegate?.reloadEpisodes()
                        self.dismiss(animated: true, completion: nil)
                    case .failure(let error):
                        self.alertUser(title: "Error",
                                       message: "Episode is not added: \(error.localizedDescription)",
                                       warning: "Failed to add episode")
                }
        }
    }
    

    
    // MARK: - Private functions
    private func configureNavigationBar() {
        self.title = "Add Episode"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didSelectCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didSelectAdd))
    }
    
    private func configureTextFieldBorders() {
        episodeTitleTextField.setBottomBorderDefault()
        seasonNumberTextField.setBottomBorderDefault()
        episodeNumberTextField.setBottomBorderDefault()
        episodeDescriptionTextField.setBottomBorderDefault()
    }
    
    private func alertUser(title: String, message: String, warning: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel) {
            (action:UIAlertAction) in
            SwiftyLog.warning(warning)
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    private func allFieldsAreOk() -> Bool {
        var fieldsAreOk = true
        
        fieldsAreOk = checkField(field: episodeTitleTextField) ? fieldsAreOk : false
        fieldsAreOk = checkField(field: seasonNumberTextField) ? fieldsAreOk : false
        fieldsAreOk = checkField(field: episodeNumberTextField) ? fieldsAreOk : false
        fieldsAreOk = checkField(field: episodeDescriptionTextField) ? fieldsAreOk : false
        
        return fieldsAreOk
    }
    
    private func checkField (field: UITextField!) -> Bool {
        if field.text!.isEmpty {
            field.setBottomBorderRed()
            field.shake()
            return false
        } else {
            field.setBottomBorderDefault()
            return true
        }
    }
    

}
