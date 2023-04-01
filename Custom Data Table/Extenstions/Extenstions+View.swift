//
//  Extenstions+View.swift
//  Custom Data Table
//
//  Created by Shishir_Mac on 1/4/23.
//

import Foundation
import UIKit

extension UIView {
    // UIView Shadow function
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1.5
        
    }
}
