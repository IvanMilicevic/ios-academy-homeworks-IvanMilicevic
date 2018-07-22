//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 18/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var testOutlet: UITextView!
    
    // MARK: - Public
    weak var loginDelegate: LoginDataExchanger?
    
    // MARK: - Private
    private var loginData: LoginData?
    private var showsArray: [Show]?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loginData=loginDelegate?.getLoginData()
        
        fetchShowsArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
     // MARK: - Private Functions
    private func fetchShowsArray() {
        guard
            let token=loginData?.token
            else {
                self.returnToLoginScreen()
                return
        }
        let headers = ["Authorization": token]
        
        SVProgressHUD.show()
        Alamofire
            .request("https://api.infinum.academy/api/shows",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                (response: DataResponse<[Show]>) in
                    switch response.result {
                        case .success(let shows):
                            SVProgressHUD.dismiss()
                            print("Shows fetched: \(shows)")
                            self.showsArray = shows
                        case .failure(let error):
                            SVProgressHUD.dismiss()
                            print("Fetching shows went wrong: \(error)")
                            let alertController = UIAlertController(title: "Error",
                                                                    message: error.localizedDescription,
                                                                    preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .cancel){
                                (action:UIAlertAction) in
                                self.returnToLoginScreen()
                            })
                            self.present(alertController, animated: true, completion: nil)
                    
                    
                }
        }
    }
    
    private func returnToLoginScreen(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController_Login")
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
