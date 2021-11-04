//
//  TabBarController.swift
//  MemeMe
//
//  Created by Hanyu Tang on 11/3/21.
//

import Foundation
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    private let tableNavigationBarController = UINavigationController(rootViewController: SentMemesTableViewController())
    private let sentMemesTableViewControllerIcon = UITabBarItem(title: "Table View", image: UIImage(named: "Table"), tag: 0)
    private let collectionNavigationBarController = UINavigationController(rootViewController: SentMemesCollectionViewController())
    private let sentMemesCollectionViewControllerIcon = UITabBarItem(title: "Collection View", image: UIImage(named: "Collection"), tag: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewControllers = setupViewControllerItems()
    }
    
    func setupViewControllerItems() -> [UINavigationController]{
        tableNavigationBarController.tabBarItem = sentMemesTableViewControllerIcon
        collectionNavigationBarController.tabBarItem = sentMemesCollectionViewControllerIcon
        return [tableNavigationBarController, collectionNavigationBarController]
    }
}
