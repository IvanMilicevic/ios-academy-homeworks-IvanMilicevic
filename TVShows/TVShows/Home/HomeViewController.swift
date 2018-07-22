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
    @IBOutlet weak var homeTableView: UITableView! {
        didSet {
            homeTableView.dataSource=self
            homeTableView.delegate=self
            homeTableView.estimatedRowHeight=44
        }
    }
    
    // MARK: - Public
    weak var loginDelegate: LoginDataExchanger?
    
    // MARK: - Private
    private var loginData: LoginData?
    private var showsArray: [Show]?
    

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Shows"
        loginData=loginDelegate?.getLoginData()
        
        fetchShowsArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.hidesBackButton = true
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
                            self.homeTableView.reloadData()
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

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = showsArray?.count else {
            return 0
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(
            withIdentifier: "TVShowsCell",
            for: indexPath
        ) as! TVShowsCell

        guard let showsArray = self.showsArray else {
            return cell
        }
        
        cell.configure(with: showsArray[indexPath.row])
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
}




