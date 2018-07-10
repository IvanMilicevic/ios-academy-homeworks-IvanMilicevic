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
    
    @IBOutlet weak var loginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func buttonPressed(_ sender: Any) {
        tapCounter+=1
        loginLabel.text = "Taps: " + String(tapCounter)
    }
    

}
