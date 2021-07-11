//
//  PhotoInfo.swift
//  PhotoLibrary
//
//  Created by Reza Farahani on 10/7/21.
//  Copyright © 2021 Squire. All rights reserved.
//



struct PhotoInfo: Decodable {
    let id: Int?
    let user: String?
    let comments: Int?
    let downloads: Int?
    let views: Int?
    let likes: Int?
    let previewURL: String?
}
