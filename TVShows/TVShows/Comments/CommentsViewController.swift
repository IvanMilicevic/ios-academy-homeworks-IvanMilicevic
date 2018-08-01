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
import Spring

class CommentsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var commentsTableView: UITableView! {
        didSet {
            commentsTableView.dataSource = self
            commentsTableView.delegate = self
            commentsTableView.estimatedRowHeight=70
            commentsTableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputBatBottomConstraint: NSLayoutConstraint!
    @IBOutlet var emptyStateView: UIView!
    // MARK: - Public
    var loginData: LoginData!
    var episodeID: String!
    
    // MARK: - private
    private let cornerRadius: CGFloat = 18
    private let bottomConstraint: CGFloat = 10
    private var commentsArray: [Comment] = [] {
        didSet {
            commentsTableView.backgroundView = commentsArray.count == 0 ? emptyStateView : nil
        }
    }
    private let refresher = UIRefreshControl()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.setCornerRadius(cornerRadius: cornerRadius)
        configureNavigationBar()
        addKeyboardEventsHandlers()
        fetchComments()
        setUpRefresheControl()
    }
    
    // MARK: - IBActions
    @IBAction func didPost(_ sender: Any) {
        guard
            let text = inputTextField.text,
            !text.isEmpty
            else {
                return
        }
        
        let headers = ["Authorization": loginData.token]
        let parameters = ["text": text,
                          "episodeId": episodeID!]
        
        SVProgressHUD.show()
        Alamofire.request("https://api.infinum.academy/api/comments",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .validate()
            .responseJSON {  [weak self]  dataResponse in
                SVProgressHUD.dismiss()
                
                guard let `self` = self else { return }
                
                switch dataResponse.result {
                    case .success(let response):
                        SwiftyLog.info("Sucess \(response)")
                        self.inputTextField.text = nil
                        self.fetchComments()
                    case .failure(let error):
                        Util.alert(target: self, title: "Error", message: "Comment is not added", error: error)
                }
        }
        
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
    
    private func setUpRefresheControl() {
        refresher.tintColor = UIColorFromRGB(rgbValue: 0xff758c)
        refresher.addTarget(self, action: #selector(updateTableView), for: .valueChanged)
        commentsTableView.refreshControl = refresher
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
    
    @objc func updateTableView() {
        fetchComments()
        let delay = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
            guard let `self` = self else { return }
            
            self.refresher.endRefreshing()
        }
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
        
        cell.configure(with: commentsArray[indexPath.row])
        
        return cell
    }
    
}

extension CommentsViewController: UITableViewDelegate {
    
    
}
