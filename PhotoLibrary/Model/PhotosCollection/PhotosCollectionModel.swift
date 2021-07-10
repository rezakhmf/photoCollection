//
//  PhotosCollection.swift
//  PhotoLibrary
//
//  Created by Reza Farahani on 10/7/21.
//  Copyright © 2021 Squire. All rights reserved.
//



struct PhotosCollection: Decodable {
    let hits: [PhotoInfo]
    let total: Int
}
