//
//  Models.swift
//  PhotoLibrary
//
//  Created by Yurii Petelko on 3/11/20.
//  Copyright © 2020 Squire. All rights reserved.
//

import UIKit

struct PhotosCollection: Decodable {
    let hits: [PhotoInfo]
    let total: Int
}

struct PhotoInfo: Decodable {
    let comments: Int
    let downloads: Int
    let favorites: Int
    let likes: Int
    let largeImageURL: String
    let tags: String
}
