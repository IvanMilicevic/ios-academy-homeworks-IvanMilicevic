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
        //TODO find default image
        showImageView.image=UIImage(named: "show-details-default")
//        showImage.image = UIImage(named: "resizer.php")
    }

    // MARK: - Functions
    func configure(with item: ShowDetails?, auth: LoginData) {
        
        guard let item: ShowDetails = item else { return }
        
        let url = URL(string: "https://rzzy0b736k-flywheel.netdna-ssl.com/wp-content/uploads/2016/02/XFiles_01_cvr-MOCKONLY.jpg")
        
//        let url = URL(string: "https://api.infinum.academy/api\(item.imageUrl)");
        
        let modifier = AnyModifier { request in
            var r = request
            r.setValue(auth.token, forHTTPHeaderField: "Authorization")
            return r
        }
        showImageView.kf.setImage(with: url, placeholder: placeholderImg, options: [.requestModifier(modifier)])
        
        
        
    }

}
