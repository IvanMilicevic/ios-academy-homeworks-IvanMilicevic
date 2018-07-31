//
//  CommentsCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 31/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        userImageView.image = nil
        titleLabel.text = nil
        commentTextLabel.text = "nil"
    }
    
    // MARK: - Functions
    func configure(with item: Comment) {
        userImageView.image = UIImage(named: "img-placeholder-user1")
        titleLabel.text = item.userEmail
        commentTextLabel.text = item.text
    }

}
