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

protocol TVShowDetails_Delegate: class {
    func reloadEpisodes()
}

class AddNewEpisodeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var episodeTitle: UITextField!
    @IBOutlet weak var seasonN: UITextField!
    @IBOutlet weak var episodeN: UITextField!
    @IBOutlet weak var episodeDescription: UITextField!
    
    // MARK: - Public
    var loginData: LoginData?
    var showID: String?
    weak var delegate: TVShowDetails_Delegate?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        episodeTitle.setBottomBorderDefault()
        seasonN.setBottomBorderDefault()
        episodeN.setBottomBorderDefault()
        episodeDescription.setBottomBorderDefault()
    }
    
    
    // MARK: - IBActions
    @IBAction func uploadPhoto(_ sender: Any) {
        let alertController = UIAlertController(title: "Oops",
                                                message: "This feature is not implemented yet.",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel) {
            (action:UIAlertAction) in
            SwiftyLog.warning("Api sucks...")
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - objC Functions
    @objc func didSelectCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didSelectAdd() {
        if !allFieldsAreOk() {
            return
        }
        
        guard
            let token = loginData?.token
            else {
                return
        }
        
        let headers = ["Authorization": token]
        let parameters = ["showId": showID!,
                          "mediaId": "mediaID",
                          "title": episodeTitle.text!,
                          "description": episodeDescription.text!,
                          "episodeNumber": episodeN.text!,
                          "season": seasonN.text!
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
                        self.dismiss(animated: true, completion: nil)
                        self.delegate?.reloadEpisodes()
                    case .failure(let error):
                        SwiftyLog.error("Adding episode went wrong - \(error)")
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
    
    private func allFieldsAreOk() -> Bool {
        var fieldsAreOk = true;
        
        fieldsAreOk = checkField(field: episodeTitle) ? fieldsAreOk : false
        fieldsAreOk = checkField(field: seasonN) ? fieldsAreOk : false
        fieldsAreOk = checkField(field: episodeN) ? fieldsAreOk : false
        fieldsAreOk = checkField(field: episodeDescription) ? fieldsAreOk : false
        
        return fieldsAreOk
    }
    
    private func checkField (field: UITextField!) -> Bool {
        if field.text!.isEmpty {
            field.setBottomBorderRed()
            return false
        } else {
            field.setBottomBorderDefault()
            return true
        }
    }
    

}
