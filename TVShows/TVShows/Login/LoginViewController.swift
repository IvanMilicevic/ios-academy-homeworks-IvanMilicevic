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
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Private
    private var rememberState: Bool = false
    private var loginCornerRadius: CGFloat = 10
    private var user: User?
    private var loginData: LoginData?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(.black)
        
        loginButton.layer.cornerRadius = loginCornerRadius
        usernameTextField.setBottomBorderDefault()
        passwordTextField.setBottomBorderDefault()
    }
    
    
    // MARK: - IBActions
    @IBAction func rememberMeButtonPressed(_ sender: Any) {
        rememberState=(!rememberState)
        
        if rememberState {
            rememberMeButton.setImage( UIImage.init(named: "ic-checkbox-filled"), for: .normal)
        } else {
            rememberMeButton.setImage( UIImage.init(named: "ic-checkbox-empty"), for: .normal)
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let email : String = usernameTextField.text!
        let password : String = passwordTextField.text!
        
        if !isLoginOk(email: email, password: password){
            return
        }
        
        SVProgressHUD.show()
        loginUserWith(email: email, password: password)
    }
    
    @IBAction func createAnAccountButtonPressed(_ sender: Any) {
        let email : String = usernameTextField.text!
        let password : String = passwordTextField.text!
        
        if !isLoginOk(email: email, password: password){
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                (response: DataResponse<User>) in
                switch response.result {
                    case .success(let user):
                        self.user=user
                        print("Success: \(user)")
                        self.loginUserWith(email: email, password: password)
                    case .failure(let error):
                        SVProgressHUD.showError(withStatus: "Error")
                        print("API failure: \(error)")
                }
            }
    }
    
    
    // MARK: - Private Functions
    private func isLoginOk(email: String, password : String) -> Bool{
        var loginIsOk = true;
        if(email.isEmpty){
            usernameTextField.setBottomBorderRed()
            loginIsOk=false
        }else{
            usernameTextField.setBottomBorderDefault()
        }
        if(password.isEmpty){
            passwordTextField.setBottomBorderRed()
            loginIsOk=false
        }else{
            passwordTextField.setBottomBorderDefault()
        }
        
        return loginIsOk
    }
    
    private func loginUserWith(email: String, password : String) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewControllerD = storyboard.instantiateViewController(withIdentifier: "ViewController_Home")
        
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
                    self.loginData=loginData
                    print("Success: \(loginData)")
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    self.navigationController?.pushViewController(viewControllerD, animated: true)
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: "Error")
                    print("Failure: \(error)")
                }
            }
    }
    
    
    
}

extension UITextField {
    func setBottomBorderDefault() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func setBottomBorderRed() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
}
