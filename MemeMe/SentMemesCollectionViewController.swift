//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Hanyu Tang on 11/4/21.
//

import Foundation
import UIKit


class SentMemesCollectionViewController: SentMemesViewController {
    private let space:CGFloat = 3.0
    private var portraitDimension:CGFloat {
        return (view.frame.size.width - (2 * space)) / 3.0
    }
    private var landscapeDimension:CGFloat {
        return (view.frame.size.height - (2 * space)) / 3.0
    }
    
    private var memesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        
        memesCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        
        view.addSubview(memesCollectionView)
        memesCollectionView.dataSource = self
        memesCollectionView.delegate = self
        memesCollectionView.register(MemeCollectionCell.self, forCellWithReuseIdentifier: "memeCell")
        
        installConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let flowLayout = memesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {return}
        
        if UIApplication.shared.statusBarOrientation.isLandscape {
            flowLayout.itemSize = CGSize(width: landscapeDimension, height: landscapeDimension)
          } else {
              flowLayout.itemSize = CGSize(width: portraitDimension, height: portraitDimension)
          }

          flowLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memesCollectionView.reloadData()
    }
    
    func installConstraints() {
        memesCollectionView.translatesAutoresizingMaskIntoConstraints = true
        memesCollectionView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            memesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            memesCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            memesCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}

extension SentMemesCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCell", for: indexPath) as! MemeCollectionCell
        cell.data = memes[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailViewController = MemeDetailViewController()
        memeDetailViewController.memeImage.image = memes[indexPath.row].memeImage!
        self.navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
}
