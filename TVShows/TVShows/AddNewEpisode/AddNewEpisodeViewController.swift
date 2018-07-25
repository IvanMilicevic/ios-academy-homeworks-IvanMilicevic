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

class AddNewEpisodeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var episodeTitle: UITextField!
    @IBOutlet weak var seasonN: UITextField!
    @IBOutlet weak var episodeN: UITextField!
    @IBOutlet weak var episodeDescription: UITextField!
    
    // MARK: - Public
    var loginData: LoginData?
    var showID: String?
    
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
            print("Api sucks...")
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - objC Functions
    @objc func didSelectCancel() {
        returnToShowDetails()
    }
    
    @objc func didSelectAdd() {
        if !allFieldsAreOk() {
            return
        }
        
        guard
            let token=loginData?.token
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
            .responseJSON { dataResponse in
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                    
                    case .success(let response):
                        print ("Sucess \(response)")
                        self.returnToShowDetails()
                    case .failure(let error):
                        print("Adding episode went wrong: \(error)")
                }
        }
    }
    

    
    // MARK: - Private functions
    private func configureNavigationBar() {
        self.title="Add Episode"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didSelectCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didSelectAdd))
    }
    
    private func returnToShowDetails() {
        let storyboard = UIStoryboard(name: "ShowDetails", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController_ShowDetails")
            as! ShowDetailsViewController
        
        viewController.loginData=loginData
        viewController.showID=showID
        
        let navigationController = UINavigationController.init(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
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
