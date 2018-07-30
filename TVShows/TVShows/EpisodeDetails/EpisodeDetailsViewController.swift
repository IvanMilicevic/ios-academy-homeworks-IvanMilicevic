//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 30/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import Spring

class EpisodeDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seasonAndEpisodeNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Public
    var loginData: LoginData!
    var episodeID: String!
    
    // MARK: - Private
    private var episodeDetails: EpisodeDetails?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScrollView()
        fetchEpisodeDetails()
    }

    // MARK: - IBActions
    @IBAction func didGoBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Public
    func configure(id: String, login: LoginData) {
        loginData =  login
        episodeID = id
    }
    
    // MARK: - Private
    private func configureScrollView() {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
    }
    
    
    private func fetchEpisodeDetails() {
        let headers = ["Authorization": loginData.token]
        
        SVProgressHUD.show()
        Alamofire
            .request("https://api.infinum.academy/api/episodes/\(episodeID!)",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<EpisodeDetails>) in
                
                guard let `self` = self else { return }
                
                switch response.result {
                    case .success(let details):
                        self.episodeDetails = details
                        SwiftyLog.info("Episode details fetched - \(details)")
                        self.setUpView()
                        SVProgressHUD.dismiss()
                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        SwiftyLog.error("Fetching episode details went wrong - \(error)")
                        self.callAlertControler(error: error)
                }
        }
    }
    
    private func callAlertControler (error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel){ [weak self]
            (action:UIAlertAction) in
            
            guard let `self` = self else { return }
            
            self.navigationController?.popViewController(animated: true)
        })
        present(alertController, animated: true, completion: nil)
    }
    
    private func setUpView() {
        
        
    }
    
    
}
