//
//  TVShowsEpisodeCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 23/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

class TVShowsEpisodeCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var seasonEpisode: UILabel!
    @IBOutlet weak var episodeTitle: UILabel!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        seasonEpisode.text=""
        episodeTitle.text=""
    }
    
    // MARK: - Functions
    func configure(with item: ShowEpisode){
        seasonEpisode.text="S2 Ep2"
        episodeTitle.text=item.title
    }

}
