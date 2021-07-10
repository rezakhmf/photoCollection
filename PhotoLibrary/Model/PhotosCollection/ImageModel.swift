//
//  ImageModel.swift
//  PhotoLibrary
//
//  Created by Reza Farahani on 10/7/21.
//  Copyright © 2021 Squire. All rights reserved.
//


import Foundation

struct ImageModel {
    public private(set) var url: String?
    
    init(url: String?) {
        self.url = url
    }
}

public extension String {
    var toURL: URL? {
        return URL(string: self)
    }
}
