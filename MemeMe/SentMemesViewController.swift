//
//  SentMemesViewController.swift
//  MemeMe
//
//  Created by Hanyu Tang on 11/3/21.
//

import Foundation
import UIKit

class SentMemesViewController: UIViewController {
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddMeme))
        self.navigationItem.title = "Sent Memes"
    }
    
    @objc func handleAddMeme() {
        let memeEditorViewController = MemeEditorViewController()
        self.navigationController?.pushViewController(memeEditorViewController, animated: true)
    }
}
