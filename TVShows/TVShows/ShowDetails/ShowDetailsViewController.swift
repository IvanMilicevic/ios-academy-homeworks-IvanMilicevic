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
            showDetailsTableView.dataSource = self
            showDetailsTableView.delegate = self
            showDetailsTableView.estimatedRowHeight = 100
            showDetailsTableView.rowHeight = UITableViewAutomaticDimension
            showDetailsTableView.separatorStyle = .none
            showDetailsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        }
    }
    @IBOutlet weak var addNewEpisodeButton: UIButton!
    @IBOutlet weak var navigateBackButton: UIButton!
    
    // MARK: - Private
    private var loginData: LoginData!
    private var showID: String!
    private var showDetails: ShowDetails?
    private var episodesArray: [ShowEpisode] = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchShowDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func configure(id: String, login: LoginData) {
        loginData =  login
        showID = id
    }
    
    // MARK: - IBActions
    @IBAction func navigateBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func addNewEpisode(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddNewEpisode", bundle: nil)
        let addEpViewController = storyboard.instantiateViewController(withIdentifier: "ViewController_AddNewEpisode")
            as! AddNewEpisodeViewController
        
        addEpViewController.showID = showID
        addEpViewController.loginData = loginData
        addEpViewController.delegate = self
        
        let navigationController = UINavigationController.init(rootViewController: addEpViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Private Functions
    private func fetchShowDetails () {
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<ShowDetails>) in
                
                guard let `self` = self else { return }
            
                switch response.result {
                    case .success(let details):
                        self.showDetails=details
                        print("Show Details fetched: \(details)")
                        self.fetchShowEpisodes()
                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        print("Fetching show details went wrong: \(error)")
                        self.callAlertControler(error: error)
                }
        }
    }
    
    private func fetchShowEpisodes () {
        guard
            let token = loginData?.token
            else {
                return
        }
        let headers = ["Authorization": token]
        
        Alamofire
            .request("https://api.infinum.academy/api/shows/\(showID!)/episodes",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<[ShowEpisode]>) in
                
                guard let `self` = self else { return }
                
                switch response.result {
                    case .success(let episodes):
                        self.episodesArray = episodes
                        print("Show episodes fetched: \(episodes)")
                        SVProgressHUD.dismiss()
                        self.showDetailsTableView.reloadData()
                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        print("Fetching episodes went wrong: \(error)")
                        self.callAlertControler(error: error)
                }
        }
        
    }
    
    private func callAlertControler (error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel){
            (action:UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        })
        present(alertController, animated: true, completion: nil)
    }
    
    private func addFloatingActionButton (image: UIImage, x: Int, y: Int, selector : Selector) {
        let btn = UIButton(type: .custom)
        let btnImg = image
        
        btn.frame = CGRect(x: x, y: y, width: 70, height: 70)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 35
        btn.setImage(btnImg, for: .normal)
        btn.addTarget(self,action: selector, for: UIControlEvents.touchUpInside)
        
        view.addSubview(btn)
    }

}

extension ShowDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + episodesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            case 0:
                let cell = showDetailsTableView.dequeueReusableCell(
                    withIdentifier: "TVShowsImageCell",
                    for: indexPath
                ) as! TVShowsImageCell
                return cell
            case 1:
                let cell = showDetailsTableView.dequeueReusableCell(
                    withIdentifier: "TVShowsDescriptionCell",
                    for: indexPath
                ) as! TVShowsDescriptionCell
            
                if showDetails != nil {
                    cell.configure(with: showDetails!, count: episodesArray.count )
                    return cell
                } else {
                    return cell
                }
            default:
                let cell = showDetailsTableView.dequeueReusableCell(
                    withIdentifier: "TVShowsEpisodeCell",
                    for: indexPath
                ) as! TVShowsEpisodeCell
                cell.configure(with: episodesArray[indexPath.row-2])
                return cell
        }

    }
    
}

extension ShowDetailsViewController: UITableViewDelegate {
    
}

extension ShowDetailsViewController: TVShowDetails_Delegate {
    func reloadEpisodes() {
        self.fetchShowDetails()
    }
}
