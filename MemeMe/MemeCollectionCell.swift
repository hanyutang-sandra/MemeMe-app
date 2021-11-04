//
//  MemeCollectionCell.swift
//  MemeMe
//
//  Created by Hanyu Tang on 11/4/21.
//

import UIKit

class MemeCollectionCell: UICollectionViewCell {
    var data: Meme? {
        didSet {
            guard let data = data else {return}
            memeImageView.image = data.memeImage
        }
    }
    
    private let memeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect){
        super.init(frame: .zero)
        contentView.addSubview(memeImageView)
        
        NSLayoutConstraint.activate([
            memeImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            memeImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            memeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            memeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
