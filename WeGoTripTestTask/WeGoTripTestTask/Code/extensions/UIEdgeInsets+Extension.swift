//
//  UIEdgeInsets+Extension.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import UIKit

extension UIEdgeInsets {
    
    var horizontal: CGFloat {
        return left + right
    }
    
    var vertical: CGFloat {
        return top + bottom
    }
    
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical,
                  left: horizontal,
                  bottom: vertical,
                  right: horizontal)
    }
    
}

extension UIEdgeInsets: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(top)
        hasher.combine(bottom)
        hasher.combine(left)
        hasher.combine(right)
    }
    
    
}
