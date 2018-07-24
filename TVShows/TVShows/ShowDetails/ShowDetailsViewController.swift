//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 23/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class ShowDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
   
    @IBOutlet weak var showDetailsTableView: UITableView! {
        didSet {
            showDetailsTableView.dataSource=self
            showDetailsTableView.delegate=self
            showDetailsTableView.estimatedRowHeight=100
            showDetailsTableView.rowHeight=UITableViewAutomaticDimension
        }
    }
    
    // MARK: - Public
    var loginData: LoginData?
    var showID: String?
    
    // MARK: - Private
    private var showDetails: ShowDetails?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchShowDetails()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Private Functions
    private func fetchShowDetails() {
        guard
            let token=loginData?.token
            else {
                return
        }
        let headers = ["Authorization": token]
        
        SVProgressHUD.show()
        
        Alamofire
            .request("https://api.infinum.academy/api/shows/\(showID!)",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                (response: DataResponse<ShowDetails>) in
                switch response.result {
                case .success(let details):
                    SVProgressHUD.dismiss()
                    print("Show Details fetched: \(details)")
                    self.showDetails=details
//                    self.homeTableView.reloadData()
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("Fetching show details went wrong: \(error)")
                    let alertController = UIAlertController(title: "Error",
                                                            message: error.localizedDescription,
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel){
                        (action:UIAlertAction) in
                        self.returnToHomeScreen()
                    })
                    self.present(alertController, animated: true, completion: nil)
                    
                }
        }
    }
    
    private func returnToHomeScreen(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController_Login")
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}

extension ShowDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let numberOfRows = showsArray?.count else {
//            return 0
//        }
//        return numberOfRows
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        switch indexPath.row {
        case 0:
            cell = showDetailsTableView.dequeueReusableCell(
                withIdentifier: "TVShowsImageCell",
                for: indexPath
            )
        case 1:
            cell = showDetailsTableView.dequeueReusableCell(
                withIdentifier: "TVShowsDescriptionCell",
                for: indexPath
            )
            
        default:
            cell = showDetailsTableView.dequeueReusableCell(
                withIdentifier: "TVShowsEpisodeCell",
                for: indexPath
            )
        }

        return cell
    }
    
}

extension ShowDetailsViewController: UITableViewDelegate {
    
}
