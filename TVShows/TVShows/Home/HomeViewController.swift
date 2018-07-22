//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 18/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var testOutlet: UITextView!
    
    // MARK: - Public
    weak var delegate: LoginDataExchanger?

    override func viewDidLoad() {
        super.viewDidLoad()
        testOutlet.text=delegate?.getLoginData()?.token
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
