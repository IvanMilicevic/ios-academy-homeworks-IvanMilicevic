//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 14/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Private
    private var rememberState: Bool = false
    private var loginCornerRadius: CGFloat = 10
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = loginCornerRadius
        usernameTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
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
        //Handle logging in
    }
    
    @IBAction func createAnAccountButtonPressed(_ sender: Any) {
        //Handle creating of new account
    }
    
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
