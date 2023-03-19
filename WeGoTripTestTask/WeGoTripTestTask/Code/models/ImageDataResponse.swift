//
//  ImageDataResponse.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 18.03.2023.
//

import Foundation

struct ImageDataResponse: Codable {
    let data: ImageDataResponseContent
}

struct ImageDataResponseContent: Codable {
    let author: Author
}

struct Author: Codable {
    let avatar: String
}
