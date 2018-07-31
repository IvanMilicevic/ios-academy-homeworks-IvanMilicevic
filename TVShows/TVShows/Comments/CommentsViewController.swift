//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 30/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class CommentsViewController: UIViewController {

    // MARK: - IBOutlet views
    @IBOutlet weak var commentsTableView: UITableView! {
        didSet {
            commentsTableView.dataSource = self
            commentsTableView.delegate = self
        }
    }
    @IBOutlet weak var inputTextField: UITextField!
    
    // MARK: - IBOutlet constraints
    @IBOutlet weak var inputBatBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Public
    var loginData: LoginData!
    var episodeID: String!
    
    // MARK: - private
    private let cornerRadius: CGFloat = 18
    private let bottomConstraint: CGFloat = 10
    private var commentsArray: [Comment] = []
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.setCornerRadius(cornerRadius: cornerRadius)
        configureNavigationBar()
        addKeyboardEventsHandlers()
        fetchComments()
    }
    
    // MARK: - Public
    func configure(id: String, login: LoginData) {
        loginData =  login
        episodeID = id
    }
    
    // MARK: - private functions
    private func configureNavigationBar() {
        self.title="Comments"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let img = UIImage(named: "ic-navigate-back")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didGoBack))
    }
    
    
    private func addKeyboardEventsHandlers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name:NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name:NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    private func fetchComments() {
        
        let headers = ["Authorization": loginData.token]
        
        SVProgressHUD.show()
        Alamofire
            .request("https://api.infinum.academy/api/episodes/\(episodeID!)/comments",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<[Comment]>) in
                
                guard let `self` = self else { return }
                
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let comments):
                    self.commentsArray = comments
                    SwiftyLog.info("Comments fetched - \(comments)")
                    self.commentsTableView.reloadData()
                case .failure(let error):
                    SwiftyLog.error("Fetching episode details went wrong - \(error)")
                }
        }
    }
    
    // MARK: - objC Functions
    @objc func didGoBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        inputBatBottomConstraint.constant=bottomConstraint+keyboardFrame.size.height
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        inputBatBottomConstraint.constant=bottomConstraint
    }

}

extension CommentsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(
            withIdentifier: "CommentsCell",
            for: indexPath
            ) as! CommentsCell
        
        return cell
    }
    
}

extension CommentsViewController: UITableViewDelegate {
    
    
}
