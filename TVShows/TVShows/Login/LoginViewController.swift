//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 11/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Private
    private var tapCounter: Int = 0
    private let labelText: String = "Dabs: "
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isHidden = true
        loginButton.isEnabled = false
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .white
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.activityIndicator.stopAnimating()
            self.imageView.isHidden=false
            self.loginButton.isEnabled=true
        }
    }

    @IBAction func buttonPressed(_ sender: Any) {
        tapCounter+=1
        loginLabel.text = labelText + String(tapCounter)
        
        if tapCounter % 2 == 0 {
            imageView.image = UIImage(named: "Dab1")
        } else {
            imageView.image = UIImage(named: "Dab2")
        }
        
    }



}
