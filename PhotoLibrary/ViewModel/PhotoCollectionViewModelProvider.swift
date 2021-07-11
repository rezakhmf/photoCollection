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
    var dataStore: ImageDataStore
    var loadingQueue:  OperationQueue
    
    init(networkRepository : PixabayNetworkClient = PixabayNetworkClient(),
         dataStore: ImageDataStore = ImageDataStore(),
         loadingQueue: OperationQueue = OperationQueue()) {
        self.networkRepository = networkRepository
        self.dataStore = dataStore
        self.loadingQueue = loadingQueue
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

