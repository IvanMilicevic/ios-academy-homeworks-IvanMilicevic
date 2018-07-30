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
import Kingfisher

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
    private let placeholderImg: UIImage = UIImage(named: "ic-camera")!
    
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
    
    @IBAction func didGoToComments(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Comments", bundle: nil)
        let addEpViewController = storyboard.instantiateViewController(withIdentifier: "ViewController_Comments")
            as! CommentsViewController
        
//        CommentsViewController.sth = sth
//        CommentsViewController.sth = sth
        
        let navigationController = UINavigationController.init(rootViewController: addEpViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Public
    func configure(id: String, login: LoginData) {
        loginData =  login
        episodeID = id
    }
    
    // MARK: - Private
    private func configureScrollView() {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
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
        guard
            let title = episodeDetails?.title,
            let description = episodeDetails?.description,
            let episodeNumber = episodeDetails?.episodeNumber,
            let season = episodeDetails?.season,
            let imageUrl = episodeDetails?.imageUrl,
            let token = loginData?.token
            else {
                return
        }
        seasonAndEpisodeNumberLabel.text = getSeasonAndNumber(episodeNumber: episodeNumber, season: season)
        setUpImageView(imageView: episodeImageView, imageUrl: imageUrl, auth:token)
        titleLabel.text=title
        descriptionLabel.text=description
    }
    
    private func getSeasonAndNumber(episodeNumber: String, season: String) -> String{
        var episodeNum = "?"
        var seasonNum = "?"
        if isNumber(string: episodeNumber) {
            episodeNum = String(Int(episodeNumber)!) //get rid of possible 0 before number
        }
        if isNumber(string: season) {
            seasonNum = String(Int(season)!) //get rid of possible 0 before number
        }
        return "S\(seasonNum) Ep\(episodeNum)"
    }
    
    private func isNumber (string: String) -> Bool {
        let num = Int(string);
        
        if num != nil {
            return true
        } else {
            return false
        }
    }
    
    private func setUpImageView(imageView: UIImageView, imageUrl: String, auth: String) {
        let url = URL(string: "https://api.infinum.academy\(imageUrl)");
        let modifier = AnyModifier { request in
            var r = request
            r.setValue(auth, forHTTPHeaderField: "Authorization")
            return r
        }
        imageView.kf.setImage(with: url, placeholder: placeholderImg, options: [.requestModifier(modifier)])
    }
    
    
}
