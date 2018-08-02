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
    override func prepareForReuse() {
        super.prepareForReuse()
        
        seasonEpisode.text = nil
        episodeTitle.text = nil
    }
    
    
    // MARK: - Functions
    func configure(with item: ShowEpisode) {
        var episodeNum = "?"
        var seasonNum = "?"
        if Util.isInteger(item.episodeNumber) {
            episodeNum = String(Int(item.episodeNumber)!) //get rid of possible 0 before number
        }
        if Util.isInteger(item.season) {
            seasonNum = String(Int(item.season)!) //get rid of possible 0 before number
        }
        
        seasonEpisode.text = "S\(seasonNum) Ep\(episodeNum)"
        episodeTitle.text = item.title
    }


}
