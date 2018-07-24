//
//  AddNewEpisodeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 24/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

class AddNewEpisodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
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
    
    private func configureNavigationBar() {
        self.title="Add Episode"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didSelectCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didSelectAdd))
    }

}
