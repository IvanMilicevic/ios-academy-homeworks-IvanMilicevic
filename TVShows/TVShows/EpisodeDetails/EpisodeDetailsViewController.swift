//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 30/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

class EpisodeDetailsViewController: UIViewController {

    
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seasonAndEpisodeNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Public
    var loginData: LoginData!
    var episodeID: String!
    
    // MARK: - Private
    private var episodesArray: [ShowEpisode] = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScrollView()
        fetchEpisodeDetails()
    }

    // MARK: - IBActions
    @IBAction func didGoBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Public
    func configure(id: String, login: LoginData) {
        loginData =  login
        episodeID = id
    }
    
    // MARK: - Private
    private func configureScrollView() {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
    }
    
    
    private func fetchEpisodeDetails() {
        
    }
    
    
}
