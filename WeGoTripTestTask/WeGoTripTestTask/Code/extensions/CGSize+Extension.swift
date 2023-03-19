//
//  CGSize+Extension.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 18.03.2023.
//

import Foundation

extension CGSize: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
    
}
