//
//  BaseCell.swift
//  PhotoLibrary
//
//  Created by Reza Farahani on 10/7/21.
//  Copyright © 2021 Squire. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
        layoutSubviews()
    }
    
    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("required init not implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        constraintViews()
    }
    
    func addViews() { }          // to overload
    func constraintViews() { }   // to overload
    
}

extension BaseCell: ReusableCell { }
extension BaseCell: NibLoadableCell { }
