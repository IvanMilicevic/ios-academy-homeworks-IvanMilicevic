//
//  TVShowsDescriptionCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 23/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

class TVShowsDescriptionCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var showTitle: UILabel!
    @IBOutlet weak var showDescription: UITextView!
    @IBOutlet weak var numberOfEpisodes: UILabel!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle=UITableViewCellSelectionStyle.none
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        //TODO find default image
        showTitle.text=""
        showDescription.text=""
        numberOfEpisodes.text="0"
    }

    // MARK: - Functions
    func configure(with item: ShowDetails, count: Int){
        showTitle.text=item.title
        showDescription.text=item.description
        numberOfEpisodes.text=String(count)
    }
    
}
