//
//  TVShowsCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 22/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

class TVShowsCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var cellLabel: UILabel!
    @IBOutlet private weak var cellImage: UIImageView!
    
    // MARK: - Private
    private let placeholderImg: UIImage = UIImage(named: "missing")!
    
    // MARK: - View Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        cellLabel.text = nil
        cellImage.image=UIImage(named: "ic-camera")
    }
    
    // MARK: - Functions
    func configure(with item: Show, loginData: LoginData?){
        cellLabel.text = item.title

        guard
            let token = loginData?.token
            else {
                cellImage.image=placeholderImg
                return
        }
        let headers = ["Authorization": token]
        
        Alamofire
            .request("https://api.infinum.academy/api/shows/\(item.id)",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<ShowDetails>) in

                guard let `self` = self else { return }

                switch response.result {
                    case .success(let details):
                        SwiftyLog.info("Show Details fetched - \(details)")
                        
                        let url = URL(string: "https://api.infinum.academy\(details.imageUrl)")
                        let modifier = AnyModifier { request in
                            var r = request
                            r.setValue(token, forHTTPHeaderField: "Authorization")
                            return r
                        }
                        
                        self.cellImage.kf.setImage(with: url,
                                                   placeholder: self.placeholderImg,
                                                   options: [.requestModifier(modifier)])
                case .failure(let error):
                        SwiftyLog.error("Fetching show details went wrong - \(error)")
                }
        }
        
    }

}
