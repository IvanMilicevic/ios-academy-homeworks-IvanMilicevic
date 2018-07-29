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
import Kingfisher

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var homeTableView: UITableView! {
        didSet {
            homeTableView.dataSource = self
            homeTableView.delegate = self
            homeTableView.estimatedRowHeight = 44
            homeTableView.separatorStyle = .none
        }
    }
    
    // MARK: - Public
    var loginData: LoginData?
    
    // MARK: - Private
    private var showsArray: [Show] = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchShowsArray()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationItem.hidesBackButton = true
    }
    
     // MARK: - Private Functions
    private func fetchShowsArray() {
        guard
            let token = loginData?.token
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<[Show]>) in
            
               guard let `self` = self else { return }
            
                switch response.result {
                    case .success(let shows):
                        SVProgressHUD.dismiss()
                        SwiftyLog.info("Shows fetched: \(shows)")
                        self.showsArray = shows
                        self.homeTableView.reloadData()
                        self.animateTable()
                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        SwiftyLog.error("Fetching shows went wrong - \(error)")
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
            self.returnToLoginScreen()
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func returnToLoginScreen(){
        navigationController?.popViewController(animated: true)
    }
    
    private func configureNavigationBar() {
        self.title="Shows"
        let img = UIImage(named: "ic-logout")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didLogout))
    }
    
    private func animateTable() {
        let cells = homeTableView.visibleCells
        let tableViewHeight = homeTableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75,
                           delay: Double(delayCounter) * 0.05,
                           options: .curveEaseInOut,
                           animations: { cell.transform=CGAffineTransform.identity },
                           completion: nil)
            delayCounter += 1
        }
        
        
    }
    
    // MARK: - objC Functions
    @objc func didLogout() {
        UserDefaults.standard.set(false, forKey: TVShowsUserDefaultsKeys.loggedIn.rawValue)
        navigationController?.popViewController(animated: true)
    }

}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(
            withIdentifier: "TVShowsCell",
            for: indexPath
        ) as! TVShowsCell
        
        cell.configure(with: showsArray[indexPath.row], loginData: loginData)
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            showsArray.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ShowDetails", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController_ShowDetails")
            as! ShowDetailsViewController
        
        viewController.configure(id: showsArray[indexPath.row].id, login: loginData!)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(viewController, animated: true)
    }

}




