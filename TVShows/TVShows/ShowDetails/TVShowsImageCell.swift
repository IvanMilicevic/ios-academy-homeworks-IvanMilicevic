//
//  TVShowsImageCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 23/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

class TVShowsImageCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var showImage: UIImageView!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //TODO find default image
        showImage.image=UIImage(named: "show-details-default")
//        showImage.image = UIImage(named: "resizer.php")
    }

    // MARK: - Functions
    func configure(with item: UIImage) {
        showImage.image = item
    }

}
