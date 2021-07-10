//
//  PhotoDetailTableViewCell.swift
//  PhotoLibrary
//
//  Created by Yurii Petelko on 3/12/20.
//  Copyright © 2020 Squire. All rights reserved.
//

import UIKit

final class PhotoDetailTableViewCell: UITableViewCell {
    static let reuseIdentifier = "PhotoDetailTableViewCell"
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
}
