//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Hanyu Tang on 11/4/21.
//

import Foundation
import UIKit

class SentMemesTableViewController: SentMemesViewController {
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
        memesTableView.rowHeight = 100
        
        NSLayoutConstraint.activate([
            memesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            memesTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            memesTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}

extension SentMemesTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "memeCell")
        cell.imageView?.image = memes[indexPath.row].memeImage
        cell.textLabel?.text = memes[indexPath.row].topText + memes[indexPath.row].bottomText
        cell.detailTextLabel?.text = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailViewController = MemeDetailViewController()
        memeDetailViewController.memeImage.image = memes[indexPath.row].memeImage!
        self.navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
}
