//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 11/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var tapCounter:Int = 0
    let labelText:String = "Dabs: "
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isHidden=true
        loginButton.isEnabled=false
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        DispatchQueue.main.async {
           sleep(3)
            self.activityIndicator.stopAnimating()
            
            self.imageView.isHidden=false
            self.loginButton.isEnabled=true
        }
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func buttonPressed(_ sender: Any) {
        tapCounter+=1
        loginLabel.text = labelText + String(tapCounter)
        
        if(tapCounter % 2 == 0){
            imageView.image = UIImage(named: "Dab1")
        }else{
            imageView.image = UIImage(named: "Dab2")
        }
        
        
    }
    

}
