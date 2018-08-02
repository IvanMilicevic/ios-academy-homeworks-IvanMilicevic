//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 14/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import KeychainAccess
import Spring

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: SpringButton!
    @IBOutlet weak var rememberMeButton: SpringButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var rememberMeLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var createAnAccountButton: UIButton!
    
    //  MARK: - IBOutlet constraints
    @IBOutlet weak var emailTextFieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextFieldTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTextFieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTextFieldTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Private
    private let loginCornerRadius: CGFloat = 10
    private var rememberState: Bool = false
    private var user: User?
    private var loginData: LoginData?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        checkIfUserLoggedIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        prepareTextFields()
        prepareForAnimation()
    }
    
    
    // MARK: - IBActions
    @IBAction func rememberMeButtonPressed(_ sender: Any) {
        rememberState = !rememberState
        rememberMeButton.doAnimation()
        
        if rememberState {
            rememberMeButton.setImage(UIImage(named: "ic-checkbox-filled"), for: .normal)
        } else {
            rememberMeButton.setImage(UIImage(named: "ic-checkbox-empty"), for: .normal)
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let email : String = emailTextField.text!
        let password : String = passwordTextField.text!
        
        if !isLoginOk(email: email, password: password) {
            return
        }
        
        SVProgressHUD.show()
        loginUserWith(email: email, password: password, animate: true)
    }

    @IBAction func createAnAccountButtonPressed(_ sender: Any) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            isLoginOk(email: email, password: password)
        else {
                return
        }
        
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request("https://api.infinum.academy/api/users",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<User>) in
                
                guard let `self` = self else {
                    return
                }
                
                switch response.result {
                    case .success(let user):
                        self.user = user
                        SwiftyLog.info("Success: \(user)")
                        self.loginUserWith(email: email, password: password, animate: true)
                    case .failure(let error):
                        SVProgressHUD.showError(withStatus: "Error")
                        SwiftyLog.error("API failure - \(error)")
                }
            }
    }
    
    
    // MARK: - objc functions
    @objc func keyboardWillShow(notification: NSNotification) {
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    // MARK: - Private functions
    private func configure() {
        SVProgressHUD.setDefaultMaskType(.black)
        loginButton.layer.cornerRadius = loginCornerRadius
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name:NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name:NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        
        emailTextField.setBottomBorderDefault()
        passwordTextField.setBottomBorderDefault()
    }
    
    private func isLoginOk(email: String, password : String) -> Bool {
        var loginIsOk = true;
        if email.isEmpty {
            emailTextField.shake()
            loginIsOk = false
        } else {
            emailTextField.setBottomBorderDefault()
        }
        if password.isEmpty {
            passwordTextField.shake()
            loginIsOk = false
        } else {
            passwordTextField.setBottomBorderDefault()
        }
        
        return loginIsOk
    }
    
    private func loginUserWith(email: String, password: String, animate: Bool) {
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request("https://api.infinum.academy/api/users/sessions",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<LoginData>) in
                
                guard let `self` = self else { return }
                
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let loginData):
                    self.loginData = loginData
                    SwiftyLog.info("Success: \(loginData)")
                    
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController_Home")
                    as! HomeViewController
                    viewController.loginData = self.loginData

                    if (self.rememberState){
                        self.storeDataForLoggingIn(email: email, password: password)
                    }
                    
                    self.navigationController?.pushViewController(viewController, animated: animate)
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 401:
                        Util.alert(target: self, title: "Login Problem", message: "Wrong email or password", error: error)
                    case nil:
                        Util.alert(target: self, title: "Login Problem", message: error.localizedDescription, error: error)
                    default:
                        Util.alert(target: self, title: "Login Problem", message: "Something went wrong", error: error)
                    }
                    
                }
            }
    }
    
    private func prepareTextFields() {
        emailTextField.text=nil
        passwordTextField.text=nil
    }
    
    private func checkIfUserLoggedIn() {
        if UserDefaults.standard.bool(forKey: TVShowsUserDefaultsKeys.loggedIn.rawValue) == true {
            let(email,password) = KeycChainService.getEmailAndPassword()
            loginUserWith(email: email,
                          password: password,
                          animate: false)
        }
    }
    
    private func storeDataForLoggingIn(email: String, password: String) {
        UserDefaults.standard.set(true, forKey: TVShowsUserDefaultsKeys.loggedIn.rawValue)
        KeycChainService.storeEmailAndPassword(email: email, password: password)
    }
    
    private func prepareForAnimation() {
        emailTextFieldLeadingConstraint.constant -= view.bounds.width
        emailTextFieldTrailingConstraint.constant += view.bounds.width
        
        passwordTextFieldLeadingConstraint.constant -= view.bounds.width
        passwordTextFieldTrailingConstraint.constant += view.bounds.width
        
        loginImageView.alpha=0
        rememberMeButton.alpha=0
        loginButton.alpha=0
        rememberMeButton.alpha=0
        rememberMeLabel.alpha=0
        orLabel.alpha=0
        createAnAccountButton.alpha=0
    }
    
    private func animate () {
        moveToTheRight(leadingConstraint: emailTextFieldLeadingConstraint,
                       trailingConstraint: emailTextFieldTrailingConstraint,
                       duration:1)
        moveToTheRight(leadingConstraint: passwordTextFieldLeadingConstraint,
                       trailingConstraint: passwordTextFieldTrailingConstraint,
                       duration:1.3)
        makeElementsOpaque()
    }
    
    private func moveToTheRight(leadingConstraint: NSLayoutConstraint, trailingConstraint: NSLayoutConstraint, duration: TimeInterval) {
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                        
                        guard let `self` = self else { return }
                        
                        leadingConstraint.constant += self.view.bounds.width
                        trailingConstraint.constant -= self.view.bounds.width
                        
                        self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func makeElementsOpaque() {
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: { [weak self] in
                        guard let `self` = self else { return }
                        
                        self.loginImageView.alpha=1
                        self.rememberMeButton.alpha=1
                        self.rememberMeLabel.alpha=1
                        self.loginButton.alpha=1
                        self.rememberMeButton.alpha=1
                        self.orLabel.alpha=1
                        self.createAnAccountButton.alpha=1
                        
                        self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
}

