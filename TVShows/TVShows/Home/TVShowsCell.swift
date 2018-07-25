//
//  TVShowsCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 22/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

class TVShowsCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var cellLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellLabel.text=nil
    }
    
    // MARK: - Private Functions
    func configure(with item: Show){
        cellLabel.text=item.title
    }

}
