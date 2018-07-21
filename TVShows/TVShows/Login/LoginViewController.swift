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

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    // MARK: - Private
    private var rememberState: Bool = false
    private let loginCornerRadius: CGFloat = 10
    private var user: User?
    private var loginData: LoginData?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    // MARK: - IBActions
    @IBAction func rememberMeButtonPressed(_ sender: Any) {
        rememberState = !rememberState
        
        if rememberState {
            rememberMeButton.setImage(UIImage(named: "ic-checkbox-filled"), for: .normal)
        } else {
            rememberMeButton.setImage(UIImage(named: "ic-checkbox-empty"), for: .normal)
        }

    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let email : String = emailTextField.text!
        let password : String = passwordTextField.text!
        
        if !isLoginOk(email: email, password: password){
            return
        }
        
        SVProgressHUD.show()
        loginUserWith(email: email, password: password)
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
                        print("Success: \(user)")
                        self.loginUserWith(email: email, password: password)
                    case .failure(let error):
                        SVProgressHUD.showError(withStatus: "Error")
                        print("API failure: \(error)")
                }
            }
    }
    
    
    // MARK: - Private Functions
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    private func isLoginOk(email: String, password : String) -> Bool {
        var loginIsOk = true;
        if email.isEmpty {
            emailTextField.setBottomBorderRed()
            loginIsOk = false
        } else {
            emailTextField.setBottomBorderDefault()
        }
        if password.isEmpty {
            passwordTextField.setBottomBorderRed()
            loginIsOk = false
        } else {
            passwordTextField.setBottomBorderDefault()
        }
        
        return loginIsOk
    }
    
    private func loginUserWith(email: String, password : String) {

        
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                (response: DataResponse<LoginData>) in
                switch response.result {
                case .success(let loginData):
                    self.loginData = loginData
                    print("Success: \(loginData)")
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let viewControllerD = storyboard.instantiateViewController(withIdentifier: "ViewController_Home")
                    self.navigationController?.pushViewController(viewControllerD, animated: true)
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    
                    let alertController = UIAlertController(title: "Login Problem",
                                                            message: "Wrong username or password.",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel){
                        (action:UIAlertAction) in
                        print("Problem with logging in occured.")
                    })
                    self.present(alertController, animated: true, completion: nil)
                    
                    print("Login Error: \(error)")
                }
            }
    }
}
