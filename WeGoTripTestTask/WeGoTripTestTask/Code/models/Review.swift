//
//  Review.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import RealmSwift

final class Review: Object, Codable {
    @Persisted var tourId: String = UUID().uuidString
    @Persisted var reviewText: String?
    @Persisted var wishesText: String?
    @Persisted var tourRating: Rating = .neutral
    @Persisted var guideRating: Rating = .neutral
    @Persisted var infoPresentationRating: Rating = .neutral
    @Persisted var navigationRating: Rating = .neutral
}
