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
import Spring

protocol TVShowDetailsDelegate: class {
    func reloadEpisodes()
}

class AddNewEpisodeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var episodeTitleTextField: UITextField!
    @IBOutlet weak var seasonNumberTextField: UITextField!
    @IBOutlet weak var episodeNumberTextField: UITextField!
    @IBOutlet weak var episodeDescriptionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.backgroundColor = .white
            imageView.layer.cornerRadius = 125
            imageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uploadPhotoButton: SpringButton!
    
    // MARK: - Public
    var loginData: LoginData?
    var showID: String?
    weak var delegate: TVShowDetailsDelegate?
    
    // MARK: - private
    private let imagePicker = UIImagePickerController()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureImagePicker()
        configureNavigationBar()
        configureTextFieldBorders()
        configureKeyboardEvents()
    }
    
    // MARK: - IBActions
    @IBAction func uploadPhoto(_ sender: Any) {
        uploadPhotoButton.force = CGFloat(1)
        uploadPhotoButton.duration = CGFloat(0.2)
        uploadPhotoButton.animation = Spring.AnimationPreset.Flash.rawValue
        uploadPhotoButton.curve = Spring.AnimationCurve.EaseInOutBack.rawValue
        uploadPhotoButton.repeatCount=2
        uploadPhotoButton.animate()

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
    
    // MARK: - objc functions
    @objc func keyboardWillShow(notification: NSNotification) {
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height/2
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    // MARK: - Private functions
    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
    }
    
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
    
    private func configureKeyboardEvents() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name:NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name:NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
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
                if Util.isInteger(field.text!) {
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
        
        SVProgressHUD.show()
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
                
                guard let `self` = self else { return }
                
                SwiftyLog.debug("UPLOAD ON API:")
                switch result {
                case .success(let uploadRequest, _, _):
                    SwiftyLog.debug("uploadImageOnAPI : SUCESS")
                    self.processUploadRequest(uploadRequest)
                case .failure(let encodingError):
                    SVProgressHUD.dismiss()
                    SwiftyLog.debug("uploadImageOnAPI : FAILURE")
                    SwiftyLog.error("\(encodingError)")
                } }
    }
    
    private func processUploadRequest(_ uploadRequest: UploadRequest) {
        uploadRequest
            .responseDecodableObject(keyPath: "data") { (response: DataResponse<Media>) in
                SwiftyLog.debug("processUploadRequest")
                switch response.result {
                case .success(let media):
                    SwiftyLog.debug("processUploadRequest : SUCESS")
                    SwiftyLog.info("DECODED: \(media)")
                    self.uploadEpisode(mediaID: media.id)
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    Util.alert(target: self, title: "Error", message: "Episode is not added", error: error)
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
        
        Alamofire.request("https://api.infinum.academy/api/episodes",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .validate()
            .responseJSON {  [weak self]  dataResponse in
                
                
                guard let `self` = self else { return }
                
                switch dataResponse.result {
                    
                case .success(let response):
                    SwiftyLog.info("Sucess \(response)")
                    self.delegate?.reloadEpisodes()
                    self.dismiss(animated: true, completion: nil)
                    SVProgressHUD.showSuccess(withStatus: "Episode added")
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    Util.alert(target: self, title: "Error", message: "Episode is not added", error: error)
                }
        }
    }
    

}

extension AddNewEpisodeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = UIViewContentMode.scaleToFill
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

extension AddNewEpisodeViewController: UINavigationControllerDelegate {
    
}
