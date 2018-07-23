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
   
    @IBOutlet weak var showDetailsTableView: UITableView! {
        didSet {
            showDetailsTableView.dataSource=self
            showDetailsTableView.delegate=self
            showDetailsTableView.rowHeight=CGFloat(150)
        }
    }
    
    // MARK: - Public
    var loginData: LoginData?
    var showID: String?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension ShowDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let numberOfRows = showsArray?.count else {
//            return 0
//        }
//        return numberOfRows
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        switch indexPath.row {
        case 0:
            cell = showDetailsTableView.dequeueReusableCell(
                withIdentifier: "TVShowsImageCell",
                for: indexPath
            )
        case 1:
            cell = showDetailsTableView.dequeueReusableCell(
                withIdentifier: "TVShowsDescriptionCell",
                for: indexPath
            )
            
        default:
            cell = showDetailsTableView.dequeueReusableCell(
                withIdentifier: "TVShowsEpisodeCell",
                for: indexPath
            )
        }

        return cell
    }
    
}

extension ShowDetailsViewController: UITableViewDelegate {
    
}
