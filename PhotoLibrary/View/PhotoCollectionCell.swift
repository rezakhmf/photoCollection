//
//  PhotoCollectionCell.swift
//  PhotoLibrary
//
//  Created by Reza Farahani on 10/7/21.
//  Copyright © 2021 Squire. All rights reserved.
//

import Foundation
import UIKit

class PhotoCollectionCell: BaseCell {
    
    //MARK: - UI components
    let shadowView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 68, height: 68))
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 2
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 10).cgPath
        
        return view
    }()
    
    var photoImageView: UIImageView = {
        let imageView =  UIImageView()
        imageView.image = UIImage(named: "empty_pic")
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 5.0
        imageView.backgroundColor = .clear
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var authorLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Author:"
        label.font = UIFont.boldSystemFont(ofSize:10)
        return label
    }()
    
    var authorTextLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Not available!"
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize:12)
        return label
    }()
    
    var photoIdLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Photo ID:"
        label.font = UIFont.boldSystemFont(ofSize:10)
        return label
    }()
    
    var photoIdTextLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Not available!"
        label.font = UIFont.systemFont(ofSize:12)
        return label
    }()
    
    override func addViews() {
        [shadowView, photoImageView, authorLabel,
          authorTextLabel, photoIdLabel, photoIdTextLabel].forEach { addSubview($0) }
        
        [self.photoIdLabel, authorTextLabel, photoIdTextLabel].forEach { $0.sizeToFit()}
        self.backgroundColor = .darkGray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func constraintViews() {
        self.shadowView.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: self.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, centerX: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 0), size: .init(width: 68, height: 68))
        
        self.photoImageView.anchor(top: self.shadowView.topAnchor, leading: self.shadowView.leadingAnchor, bottom: nil, trailing: nil, centerX: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 68, height: 68))

        self.authorLabel.anchor(top: self.shadowView.topAnchor, leading: self.shadowView.trailingAnchor, bottom: nil, trailing: nil, centerX: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0))

        self.authorTextLabel.anchor(top: self.authorLabel.bottomAnchor, leading: self.authorLabel.leadingAnchor, bottom: nil, trailing: nil, centerX: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        

        self.photoIdLabel.anchor(top: self.authorTextLabel.bottomAnchor, leading: self.authorLabel.leadingAnchor, bottom: nil, trailing:nil, centerX: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))

        self.photoIdTextLabel.anchor(top: self.photoIdLabel.bottomAnchor, leading: self.authorLabel.leadingAnchor, bottom: nil, trailing: nil, centerX: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
    }
    
    func configure(photoInfo: PhotoInfo?, image: UIImage?) {
        
        guard let author = photoInfo?.user, let photoId = photoInfo?.id,
              let image = image else {
            print("one of the necessary info for building the cell was empty")
            return
        }
        
        self.photoImageView.image = image
        self.authorTextLabel.text = author
        self.photoIdTextLabel.text = String(photoId)
    }
    
    
}
