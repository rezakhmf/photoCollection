//
//  PhotoCollectionViewModelProvider.swift
//  PhotoLibrary
//
//  Created by Reza Farahani on 10/7/21.
//  Copyright © 2021 Squire. All rights reserved.
//

import Foundation

protocol PhotoCollectionViewModelProvider: AnyObject {
    func getPhotosCollection(completion: @escaping ([PhotoInfo]) -> Void)
}

public class PhotoCollectionViewModel: PhotoCollectionViewModelProvider {
    
    let networkRepository : PixabayNetworkClient
    
    init(networkRepository : PixabayNetworkClient = PixabayNetworkClient()) {
        self.networkRepository = networkRepository
    }
    
    func getPhotosCollection(completion: @escaping ([PhotoInfo]) -> Void) {
        networkRepository.fetchImageList(for: "football") { result in
            switch result {
            case .success(let photos):
                completion(photos)
            case .failure(let error):
                print(error)
            }
        }
    }
}

