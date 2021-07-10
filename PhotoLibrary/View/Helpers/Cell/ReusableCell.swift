//
//  ReusableCell.swift
//  PhotoLibrary
//
//  Created by Reza Farahani on 10/7/21.
//  Copyright © 2021 Squire. All rights reserved.
//

import Foundation

import Foundation
import UIKit

protocol ReusableCell: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableCell where Self: UITableViewCell {
    static var defaultReuseIdentifier: String { NSStringFromClass(self) }
}

//
protocol NibLoadableCell: AnyObject {
    static var nibName: String { get }
}

extension NibLoadableCell where Self: UITableViewCell {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: (".")).last!
    }
}

//
extension UITableView {
    
    func register<T: UITableViewCell>(_ cellClass: T.Type) where T: ReusableCell {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UITableViewCell>(nib: T.Type) where T: ReusableCell, T: NibLoadableCell {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableCell {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
}
