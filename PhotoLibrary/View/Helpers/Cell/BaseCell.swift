//
//  BaseCell.swift
//  PhotoLibrary
//
//  Created by Reza Farahani on 10/7/21.
//  Copyright © 2021 Squire. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {

    override init(frame: CGRect) {
            super.init(frame: frame)
            addViews()
            constraintViews()
        }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        }
    
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        constraintViews()
//    }
    
    func addViews() { }          // to overload
    func constraintViews() { }   // to overload
    
}
