//
//  FavoriteDogModel.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-14.
//

import Foundation
import SwiftData

@Model
final class FavoriteDogModel {
    var id: String
    var breedName: String
    var imageUrl: String

    init(breedName: String, imageUrl: String) {
        self.id = UUID().uuidString
        self.breedName = breedName
        self.imageUrl = imageUrl
    }
}

extension FavoriteDogModel: CustomStringConvertible {
    var description: String {
        return "[FavoriteDogModel] id: \(self.id)\nbreedName: \(self.breedName)\nimageUrl: \(self.imageUrl)"
    }
}
