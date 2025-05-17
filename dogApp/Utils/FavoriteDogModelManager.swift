//
//  FavoriteDogModelManager.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-15.
//

import Foundation
import SwiftData

@MainActor
class FavoriteDogModelManager {
    static let shared = FavoriteDogModelManager()
    var container: ModelContainer?
    
    private init() {
        initializeModelContainer()
    }
    
    private func initializeModelContainer() {
        guard container == nil else { return } // Only initialize once
        do {
            container = try ModelContainer(for: FavoriteDogModel.self)
        } catch {
            debugPrint("Error initializing ModelContainer: \(error)")
        }
    }
    
    func checkImageIsFavorite(breedName: String?) -> Bool {
        guard let container = container else { return false }
        guard let breedName = breedName else {
            debugPrint("Breed name is nil")
            return false
        }
        do {
            let descriptor = FetchDescriptor<FavoriteDogModel>()
            let favorites = (try container.mainContext.fetch(descriptor))
            if favorites.isEmpty {
                debugPrint("No favorite images found.")
                return false
            } else {
                for favorite in favorites {
                    if breedName == favorite.breedName {
                        debugPrint("Image is already a favorite.")
                        return true
                    }
                }
            }
        } catch {
            debugPrint("Error fetching favorite images: \(error)")
            return false
        }
        return false
    }
    
    func setImageFavorite(breedName: String?, imageUrl: String?, isFavorite: Bool) {
        if isFavorite {
            removeImageFromFavorites(breedName: breedName, imageUrl: imageUrl)
        } else {
            addImageToFavorites(breedName: breedName, imageUrl: imageUrl)
        }
    }
    
    func addImageToFavorites(breedName: String?, imageUrl: String?) {
        guard let container = container else { return }
        guard let breedName = breedName, let imageUrl = imageUrl else {
            debugPrint("Breed name or image URL is nil")
            return
        }
        let isAlreadyFavorite = checkImageIsFavorite(breedName: breedName)
        guard isAlreadyFavorite == false else {
            debugPrint("Image is already a favorite.")
            return
        }
        do {
            let favoriteDog = FavoriteDogModel(breedName: breedName, imageUrl: imageUrl)
            container.mainContext.insert(favoriteDog)
            try container.mainContext.save()
            debugPrint("Added image to favorites")
        } catch {
            debugPrint("Error adding image to favorites: \(error)")
        }
    }
    
    func removeImageFromFavorites(breedName: String?, imageUrl: String?) {
        guard let container = container else { return }
        guard let breedName = breedName, let imageUrl = imageUrl else {
            debugPrint("Breed name or image URL is nil")
            return
        }
        do {
            let descriptor = FetchDescriptor<FavoriteDogModel>()
            let favorites = (try container.mainContext.fetch(descriptor))
            if favorites.isEmpty {
                debugPrint("No favorite images found.")
            } else {
                for favorite in favorites {
                    if breedName == favorite.breedName && imageUrl == favorite.imageUrl {
                        container.mainContext.delete(favorite)
                        try container.mainContext.save()
                        debugPrint("Removed image from favorites")
                    }
                }
            }
        } catch {
            debugPrint("Error removing image from favorites: \(error)")
        }
    }

    func loadFavoriteImages(completion: @escaping (Result<[FavoriteDogModel], Error>) -> Void) {
        guard let container = container else { return }
        do {
            let descriptor = FetchDescriptor<FavoriteDogModel>()
            let favoriteDogs = (try container.mainContext.fetch(descriptor))
            completion(.success(favoriteDogs))
        } catch {
            debugPrint("Error fetching favorite images: \(error)")
            completion(.failure(error))
        }
    }

}
