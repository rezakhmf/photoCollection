//
//  DataLoadOperation.swift
//  PhotoLibrary
//
//  Created by Reza Farahani on 10/7/21.
//  Copyright © 2021 Squire. All rights reserved.
//

import Foundation
import UIKit

class ImageDataStore {
    private var images: [ImageModel] = [ImageModel]()
    public var photos : [PhotoInfo] = [PhotoInfo]() {
        didSet {
            images.removeAll()
            photos.forEach { images.append(ImageModel(url: $0.previewURL)) }
        }
    }
    public var numberOfImage: Int {
        return images.count
    }
    
    let networkRepository : PixabayNetworkClient
    
    init(networkRepository: PixabayNetworkClient = PixabayNetworkClient()) {
        self.networkRepository = networkRepository
    }
    
    public func loadImage(at index: Int) -> DataLoadOperation? {
        if (0..<images.count).contains(index) {
            return DataLoadOperation(networkRepository: networkRepository, image: images[index])
        }
        return .none
    }
}

class DataLoadOperation: Operation {
    
    // MARK: - Dependencies
    let networkRepository : PixabayNetworkClient
    //ghalate in
    
    var image: UIImage?
    var loadingCompleteHandler: ((UIImage?) -> ())?
    private var _image: ImageModel
    
    init(networkRepository: PixabayNetworkClient, image: ImageModel) {
        self.networkRepository = networkRepository
        self._image = image
    }
    
    override func main() {
        if isCancelled { return }
        guard let url = _image.url else { return }
        networkRepository.fetchImage(on: url) { (result) in
            DispatchQueue.main.async() { [weak self] in
                guard let `self` = self else { return }
                if self.isCancelled { return }
                switch result {
                case .success(let image):
                    self.image = image
                    self.loadingCompleteHandler?(self.image)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}


