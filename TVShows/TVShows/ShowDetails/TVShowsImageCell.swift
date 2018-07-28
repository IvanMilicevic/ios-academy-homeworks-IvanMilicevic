//
//  TVShowsImageCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 23/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit
import Kingfisher

class TVShowsImageCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var showImageView: UIImageView!
    
    // MARK: - Private
    private let placeholderImg: UIImage = UIImage(named: "ic-camera")!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showImageView.image=nil
    }

    // MARK: - Functions
    func configure(with item: ShowDetails?, auth: LoginData) {
        guard
            let item: ShowDetails = item
            else {
                return
                
        }
        
        let url = URL(string: "https://api.infinum.academy\(item.imageUrl)");
        let modifier = AnyModifier { request in
            var r = request
            r.setValue(auth.token, forHTTPHeaderField: "Authorization")
            return r
        }
        showImageView.kf.setImage(with: url, placeholder: placeholderImg, options: [.requestModifier(modifier)])
    }

}
