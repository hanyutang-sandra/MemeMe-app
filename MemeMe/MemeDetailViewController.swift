//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Hanyu Tang on 11/3/21.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    let memeImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        view.addSubview(memeImage)
        installConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func installConstraints(){
        memeImage.translatesAutoresizingMaskIntoConstraints = false
        memeImage.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            memeImage.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            memeImage.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            memeImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}
