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
import Spring

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
    @IBOutlet weak var addNewEpisodeButton: SpringButton!
    @IBOutlet weak var navigateBackButton: SpringButton!
    
    // MARK: - Private
    private var loginData: LoginData!
    private var showID: String!
    private var showDetails: ShowDetails?
    private var episodesArray: [ShowEpisode] = []
    private let refresher = UIRefreshControl()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpRefresheControl()
        fetchShowDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func navigateBack(_ sender: Any) {
        animate(button: navigateBackButton)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewEpisode(_ sender: Any) {
        animate(button: addNewEpisodeButton)
        let storyboard = UIStoryboard(name: "AddNewEpisode", bundle: nil)
        let addEpViewController = storyboard.instantiateViewController(withIdentifier: "ViewController_AddNewEpisode")
            as! AddNewEpisodeViewController
        
        addEpViewController.configure(id: showID, login: loginData, delegate: self)
        
        let navigationController = UINavigationController.init(rootViewController: addEpViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    
    // MARK: - Functions
    func configure(id: String, login: LoginData) {
        loginData =  login
        showID = id
    }
    
    
    // MARK: - @objc functions
    @objc func updateTableView() {
        fetchShowEpisodes()
        let delay = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
            guard let `self` = self else { return }
            
            self.refresher.endRefreshing()
        }
    }
    
    
    // MARK: - Private functions
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
                        SwiftyLog.info("Show Details fetched - \(details)")
                        self.fetchShowEpisodes()
                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        SwiftyLog.error("Fetching show details went wrong - \(error)")
                        self.alert(error: error)
                }
        }
    }
    
    private func setUpRefresheControl() {
        refresher.tintColor = UIColorFromRGB(rgbValue: 0xff758c)
        refresher.addTarget(self, action: #selector(updateTableView), for: .valueChanged)
        showDetailsTableView.refreshControl = refresher
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
                        SwiftyLog.info("Show episodes fetched - \(episodes)")
                        SVProgressHUD.dismiss()
                        self.showDetailsTableView.reloadData()
                        self.animateTable()
                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        SwiftyLog.error("Fetching episodes went wrong - \(error)")
                        self.alert(error: error)
                }
        }
        
    }
    
    private func alert (error: Error) {
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
    
    private func animate(button: SpringButton) {
        button.force = CGFloat(1)
        button.duration = CGFloat(1)
        button.animation = Spring.AnimationPreset.ZoomIn.rawValue
        button.curve = Spring.AnimationCurve.EaseIn.rawValue
        
        button.animate()
    }
    
    private func animateTable() {
        let cells = showDetailsTableView.visibleCells
        let tableViewHeight = showDetailsTableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 0.25,
                           delay: Double(delayCounter) * 0.02,
                           options: .curveEaseInOut,
                           animations: { cell.transform=CGAffineTransform.identity },
                           completion: nil)
            delayCounter += 1
        }
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
                cell.configure(with: showDetails, auth: loginData)
                cell.selectionStyle = .none
                return cell
            case 1:
                let cell = showDetailsTableView.dequeueReusableCell(
                    withIdentifier: "TVShowsDescriptionCell",
                    for: indexPath
                ) as! TVShowsDescriptionCell
                cell.selectionStyle = .none
                
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == 1{
            return
        }
        let storyboard = UIStoryboard(name: "EpisodeDetails", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController_EpisodeDetails")
            as! EpisodeDetailsViewController
        
        
        viewController.configure(id: episodesArray[indexPath.row-2].id, login: loginData)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension ShowDetailsViewController: TVShowDetailsDelegate {
    func reloadEpisodes() {
        self.fetchShowDetails()
    }
}
