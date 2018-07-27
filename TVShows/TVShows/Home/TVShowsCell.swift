//
//  TVShowsCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 22/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit
import Kingfisher

class TVShowsCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var cellLabel: UILabel!
    @IBOutlet private weak var cellImage: UIImageView!
    
    // MARK: - Private
    private let placeholderImg: UIImage = UIImage(named: "ic-camera")!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellLabel.text = nil
        cellImage.image=UIImage(named: "ic-camera")
    }
    
    // MARK: - Functions
    func configure(with item: Show){
        cellLabel.text = item.title
        //nesto je mal spor pazi
        
        //Big image
        //let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3f/Fronalpstock_big.jpg")
        //let url = URL(string: "https://upload.wikimedia.org/wikipedia/hr/a/a0/Simpsoni.png")
        let url = URL(string: "https://rzzy0b736k-flywheel.netdna-ssl.com/wp-content/uploads/2016/02/XFiles_01_cvr-MOCKONLY.jpg")
        
        

        cellImage.kf.setImage(with: url, placeholder: placeholderImg)
        
    }

}
