//
//  CACornerMask+Extension.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import QuartzCore

extension CACornerMask {
    
    /// Right top corner
    static let topRight: CACornerMask = .layerMaxXMinYCorner
    
    /// Right bottom corner
    static let bottomRight: CACornerMask = .layerMaxXMaxYCorner
    
    /// Left top corner
    static let topLeft: CACornerMask = .layerMinXMinYCorner
    
    ///  Left bottom corner
    static let bottomLeft: CACornerMask = .layerMinXMaxYCorner
    
    /// Top corners
    static let top: CACornerMask = [.topLeft, .topRight]
    
    /// Bottom corners
    static let bottom: CACornerMask = [.bottomLeft, .bottomRight]
    
    /// Left corners
    static let left: CACornerMask = [.topLeft, .bottomLeft]
    
    /// Right corners
    static let right: CACornerMask = [.topRight, .bottomRight]
    
    /// All corners
    static let all: CACornerMask = [.top, .bottom]
}
