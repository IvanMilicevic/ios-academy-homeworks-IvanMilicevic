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

    
    @IBOutlet weak var episodeTitle: UITextField!
    @IBOutlet weak var seasonN: UITextField!
    @IBOutlet weak var episodeN: UITextField!
    @IBOutlet weak var episodeDescription: UITextField!
    
    var loginData: LoginData?
    var showID: String?
    
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
        
        SVProgressHUD.show()
        let parameters = ["showId": showID!,
                          "mediaId": "mediaID",
                          "title": episodeTitle.text!,
                          "description": episodeDescription.text!,
                          "episodeNumber": episodeN.text!,
                          "season": seasonN.text!
        ]
        
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func uploadPhoto(_ sender: Any) {
        let alertController = UIAlertController(title: "Oops",
                                                message: "This feature is not implemented yet.",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel){
            (action:UIAlertAction) in
            print("Api sucks...")
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func configureNavigationBar() {
        self.title="Add Episode"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didSelectCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didSelectAdd))
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
        if episodeTitle.text!.isEmpty {
            episodeTitle.setBottomBorderRed()
            fieldsAreOk = false
        } else {
            episodeTitle.setBottomBorderDefault()
        }
        if seasonN.text!.isEmpty {
            seasonN.setBottomBorderRed()
            fieldsAreOk = false
        } else {
            seasonN.setBottomBorderDefault()
        }
        if episodeN.text!.isEmpty {
            episodeN.setBottomBorderRed()
            fieldsAreOk = false
        } else {
            episodeN.setBottomBorderDefault()
        }
        if episodeDescription.text!.isEmpty {
            episodeDescription.setBottomBorderRed()
            fieldsAreOk = false
        } else {
            episodeDescription.setBottomBorderDefault()
        }

        return fieldsAreOk
    }
    

}
