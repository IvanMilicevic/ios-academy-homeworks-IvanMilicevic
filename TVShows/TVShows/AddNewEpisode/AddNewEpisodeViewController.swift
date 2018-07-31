//
//  AddNewEpisodeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 24/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

protocol TVShowDetailsDelegate: class {
    func reloadEpisodes()
}

class AddNewEpisodeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var episodeTitleTextField: UITextField!
    @IBOutlet weak var seasonNumberTextField: UITextField!
    @IBOutlet weak var episodeNumberTextField: UITextField!
    @IBOutlet weak var episodeDescriptionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Public
    var loginData: LoginData?
    var showID: String?
    weak var delegate: TVShowDetailsDelegate?
    
    // MARK: - private
    private let imagePicker = UIImagePickerController()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        configureNavigationBar()
        configureTextFieldBorders()
    }
    
    // MARK: - IBActions
    @IBAction func uploadPhoto(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - objC Functions
    @objc func didSelectCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didSelectAdd() {
        guard
            let token = loginData?.token
        else {
            return
        }
        
        if !allFieldsAreOk() {
            return
        }
        
        uploadImageOnAPI(token: token, image: imageView.image!)
    }
    

    
    // MARK: - Private functions
    private func configureNavigationBar() {
        self.title = "Add Episode"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didSelectCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didSelectAdd))
    }
    
    private func configureTextFieldBorders() {
        episodeTitleTextField.setBottomBorderDefault()
        seasonNumberTextField.setBottomBorderDefault()
        episodeNumberTextField.setBottomBorderDefault()
        episodeDescriptionTextField.setBottomBorderDefault()
    }
    
    private func alertUser(title: String, message: String, warning: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel) {
            (action:UIAlertAction) in
            SwiftyLog.warning(warning)
        })
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    private func allFieldsAreOk() -> Bool {
        var fieldsAreOk = true
        
        fieldsAreOk = checkField(field: episodeTitleTextField, mustBeNumber: false) ? fieldsAreOk : false
        fieldsAreOk = checkField(field: seasonNumberTextField, mustBeNumber: true) ? fieldsAreOk : false
        fieldsAreOk = checkField(field: episodeNumberTextField, mustBeNumber: true) ? fieldsAreOk : false
        fieldsAreOk = checkField(field: episodeDescriptionTextField, mustBeNumber: false) ? fieldsAreOk : false
        
        return fieldsAreOk
    }
    
    private func checkField (field: UITextField!, mustBeNumber: Bool) -> Bool {
        if field.text!.isEmpty {
            field.shake()
            return false
        } else {
            if mustBeNumber {
                let num = Int(field.text!);
                
                if num != nil {
                    field.setBottomBorderDefault()
                    return true
                } else {
                    field.shake()
                    return false
                }
            } else {
                field.setBottomBorderDefault()
                return true
            }
        }
    }
    
    private func uploadImageOnAPI(token: String, image: UIImage) {

        let headers = ["Authorization": token]
        let imageByteData = UIImagePNGRepresentation(image)!
        
        Alamofire
            .upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageByteData,
                                         withName: "file",
                                         fileName: "image.png",
                                         mimeType: "image/png")
            }, to: "https://api.infinum.academy/api/media",
               method: .post,
               headers: headers)
            { [weak self] result in
                
                SwiftyLog.debug("UPLOAD ON API:")
                switch result {
                case .success(let uploadRequest, _, _):
                    SwiftyLog.debug("uploadImageOnAPI : SUCESS")
                    self?.processUploadRequest(uploadRequest)
                case .failure(let encodingError):
                    SwiftyLog.debug("uploadImageOnAPI : FAILURE")
                    SwiftyLog.error("\(encodingError)")
                } }
    }
    
    private func processUploadRequest(_ uploadRequest: UploadRequest) {
        uploadRequest
            .responseDecodableObject(keyPath: "data") { (response:
                DataResponse<Media>) in
                SwiftyLog.debug("processUploadRequest")
                switch response.result {
                case .success(let media):
                    SwiftyLog.debug("processUploadRequest : SUCESS")
                    SwiftyLog.info("DECODED: \(media)")
                    self.uploadEpisode(mediaID: media.id)
                case .failure(let error):
                    SwiftyLog.debug("processUploadRequest : FAILURE")
                    SwiftyLog.error("FAILURE: \(error)")
                }
        }
    }
    
    private func uploadEpisode(mediaID: String) {
        guard
            let showID = showID,
            let token = loginData?.token,
            let episodeTitle = episodeTitleTextField.text,
            let seasonNumber = seasonNumberTextField.text,
            let episodeNumber = episodeNumberTextField.text,
            let episodeDescription = episodeDescriptionTextField.text
            else {
                return
        }
        
        let headers = ["Authorization": token]
        let parameters = ["showId": showID,
                          "mediaId": mediaID,
                          "title": episodeTitle,
                          "description": episodeDescription,
                          "episodeNumber": episodeNumber,
                          "season": seasonNumber
        ]
        
        SVProgressHUD.show()
        Alamofire.request("https://api.infinum.academy/api/episodes",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .validate()
            .responseJSON {  [weak self]  dataResponse in
                SVProgressHUD.dismiss()
                
                guard let `self` = self else { return }
                
                switch dataResponse.result {
                    
                case .success(let response):
                    SwiftyLog.info("Sucess \(response)")
                    self.delegate?.reloadEpisodes()
                    self.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    self.alertUser(title: "Error",
                                   message: "Episode is not added: \(error.localizedDescription)",
                        warning: "Failed to add episode")
                }
        }
    }
    

}

extension AddNewEpisodeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image=image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

extension AddNewEpisodeViewController: UINavigationControllerDelegate {
    
}
