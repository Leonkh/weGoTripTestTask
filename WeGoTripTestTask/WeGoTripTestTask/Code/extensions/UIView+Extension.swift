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
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func dropShadow(shadowSize: CGFloat = 2.0,
                    shadowOpacity: Float = 0.2,
                    shadowOffset: CGSize = .zero) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowSize
        
        self.layer.shadowOpacity = shadowOpacity
    }
    
}
