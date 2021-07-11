//
//  PhotoDetailsViewModelProvider.swift
//  PhotoLibrary
//
//  Created by Reza Farahani on 11/7/21.
//  Copyright © 2021 Squire. All rights reserved.
//

import Foundation

protocol PhotoDetailsViewModelProvider: AnyObject {
    func getPhotoInfo(photoInfo: PhotoInfo,completion: @escaping (Bool) -> Void)
    
    
    
}

public class PhotoDetailsViewModel: PhotoDetailsViewModelProvider {
    
    var deteils : [PhotoDetails] = [PhotoDetails]()
    
    func getPhotoInfo(photoInfo: PhotoInfo, completion: @escaping (Bool) -> Void) {
        
        guard let author = photoInfo.user, let downloads = photoInfo.downloads,
              let comments = photoInfo.comments, let likes = photoInfo.likes,
              let views = photoInfo.views else {
            print("not valid data")
            return
        }
        
        deteils.removeAll()
        
        deteils.append(PhotoDetails(title: "Author Name" , subTitle: author))
        deteils.append(PhotoDetails(title: "Count of Download" , subTitle: String(downloads)))
        deteils.append(PhotoDetails(title: "Count of Views" , subTitle: String(views)))
        deteils.append(PhotoDetails(title: "Count of Likes" , subTitle: String(likes)))
        deteils.append(PhotoDetails(title: "Count of Comment" , subTitle: String(comments)))
        
        
        completion(true)
    }
}
