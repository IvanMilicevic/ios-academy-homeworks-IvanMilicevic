//
//  AddNewEpisodeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 24/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

class AddNewEpisodeViewController: UIViewController {

    
    @IBOutlet weak var episodeTitle: UITextField!
    @IBOutlet weak var seasonN: UITextField!
    @IBOutlet weak var episodeN: UITextField!
    @IBOutlet weak var episodeDescription: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        episodeTitle.setBottomBorderDefault()
        seasonN.setBottomBorderDefault()
        episodeN.setBottomBorderDefault()
        episodeDescription.setBottomBorderDefault()
    }
    
    @objc func didSelectCancel() {
        // Add show API call
    }
    
    @objc func didSelectAdd() {
        // Add show API call
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func uploadPhoto(_ sender: Any) {
    }
    
    private func configureNavigationBar() {
        self.title="Add Episode"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didSelectCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didSelectAdd))
    }

}
