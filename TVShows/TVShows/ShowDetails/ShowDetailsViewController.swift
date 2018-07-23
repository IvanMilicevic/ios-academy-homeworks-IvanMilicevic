//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 23/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

class ShowDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textViewOne: UITextView!
    @IBOutlet weak var textViewTwo: UITextView!
    
    // MARK: - Public
    var loginData: LoginData?
    var showID: String?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        textViewTwo.text=showID
        textViewOne.text=loginData?.token
        // Do any additional setup after loading the view.
    }

}
