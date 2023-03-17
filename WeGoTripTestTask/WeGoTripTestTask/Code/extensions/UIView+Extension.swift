//
//  UIView+Extension.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import UIKit

extension UIView {
    
    /// Round corners
    /// - Parameters:
    ///   - corners: corners, which will rounded.
    ///   - radius: radius of round.
    func makeRoundCorners(_ corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
}
