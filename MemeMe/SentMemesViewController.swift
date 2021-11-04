//
//  SentMemesViewController.swift
//  MemeMe
//
//  Created by Hanyu Tang on 11/3/21.
//

import Foundation
import UIKit

// MARK: SentMemesViewController
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
        memeEditorViewController.modalPresentationStyle = .fullScreen
        present(memeEditorViewController, animated: true, completion: nil)
    }
}

// MARK: SentMemesTableViewController
class SentMemesTableViewController: SentMemesViewController, UITableViewDataSource, UITableViewDelegate {
    private let memesTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(memesTableView)
        memesTableView.dataSource = self
        memesTableView.delegate = self
        memesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "memeCell")
        installConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memesTableView.reloadData()
    }
    
    func installConstraints() {
        memesTableView.translatesAutoresizingMaskIntoConstraints = false
        memesTableView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            memesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            memesTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            memesTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath)
        cell.imageView?.image = memes[indexPath.row].memeImage
        cell.textLabel?.text = memes[indexPath.row].topText + memes[indexPath.row].bottomText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailViewController = MemeDetailViewController()
        memeDetailViewController.memeImage.image = memes[indexPath.row].memeImage!
        self.navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
}

// MARK: SentMemesCollectionViewController
class SentMemesCollectionViewController: SentMemesViewController, UICollectionViewDataSource {
    private let memesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(memesCollectionView)
        //memesCollectionView.dataSource = self(
        //memesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "memeCell")
        installConstraints()
    }
    
    func installConstraints() {
        memesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        memesCollectionView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            memesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            memesCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            memesCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCell", for: indexPath)
        cell.largeContentImage = memes[indexPath.row].memeImage
        return cell
    }
}
