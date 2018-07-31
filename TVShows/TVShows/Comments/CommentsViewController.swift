//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 30/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var commentsTableView: UITableView! {
        didSet {
            commentsTableView.dataSource = self
            commentsTableView.delegate = self
//            commentsTableView.estimatedRowHeight = 100
//            commentsTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
    
    // MARK: - private functions
    private func configureNavigationBar() {
        self.title="Comments"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let img = UIImage(named: "ic-navigate-back")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didGoBack))
    }
    
    // MARK: - objC Functions
    @objc func didGoBack() {
        dismiss(animated: true, completion: nil)
    }

}

extension CommentsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(
            withIdentifier: "CommentsCell",
            for: indexPath
            ) as! CommentsCell
        
        return cell
    }
    
}

extension CommentsViewController: UITableViewDelegate {
    
    
}
