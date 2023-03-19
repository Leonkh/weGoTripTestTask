//
//  Rating.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import RealmSwift

enum Rating: Int, PersistableEnum, CaseIterable, Codable {
    case veryBad = 1
    case bad = 2
    case neutral = 3
    case good = 4
    case veryGood = 5
}
