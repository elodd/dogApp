//
//  DataManager.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-15.
//

import Foundation
import SwiftData

@MainActor
class DataManager {
    static let shared = DataManager()
    var container: ModelContainer?
    
    private init() {
        initialiseModelContainer()
    }
    
    private func initialiseModelContainer() {
        do {
            container = try ModelContainer(for: FavoriteDogModel.self)
        } catch {
            print("Error initializing ModelContainer: \(error)")
        }
    }
    
    func checkImageIsFavorite(breedName: String?) -> Bool {
        guard let container = container else { return false }
        guard let breedName = breedName else {
            print("Breed name is nil")
            return false
        }
        do {
            let descriptor = FetchDescriptor<FavoriteDogModel>()
            let favorites = (try container.mainContext.fetch(descriptor))
            if favorites.isEmpty {
                print("No favorite images found.")
                return false
            } else {
                for favorite in favorites {
                    if breedName == favorite.breedName {
                        print("Image is already a favorite.")
                        return true
                    }
                }
            }
        } catch {
            print("Error fetching favorite images: \(error)")
            return false
        }
        return false
    }
    
    func setImageFavorite(breedName: String?, imageUrl: String?, isFavorite: Bool) throws {
        if isFavorite {
            removeImageFromFavorites(breedName: breedName, imageUrl: imageUrl)
        } else {
            addImageToFavorites(breedName: breedName, imageUrl: imageUrl)
        }
    }
    
    func addImageToFavorites(breedName: String?, imageUrl: String?) {
        guard let container = container else { return }
        guard let breedName = breedName, let imageUrl = imageUrl else {
            print("Breed name or image URL is nil")
            return
        }
        do {
            let favoriteDog = FavoriteDogModel(breedName: breedName, imageUrl: imageUrl)
            container.mainContext.insert(favoriteDog)
            try container.mainContext.save()
            print("Added image to favorites")
        } catch {
            print("Error adding image to favorites: \(error)")
        }
    }
    
    func removeImageFromFavorites(breedName: String?, imageUrl: String?) {
        guard let container = container else { return }
        guard let breedName = breedName, let imageUrl = imageUrl else {
            print("Breed name or image URL is nil")
            return
        }
        do {
            let descriptor = FetchDescriptor<FavoriteDogModel>()
            let favorites = (try container.mainContext.fetch(descriptor))
            if favorites.isEmpty {
                print("No favorite images found.")
            } else {
                for favorite in favorites {
                    if breedName == favorite.breedName && imageUrl == favorite.imageUrl {
                        container.mainContext.delete(favorite)
                        try container.mainContext.save()
                        print("Removed image from favorites")
                    }
                }
            }
        } catch {
            print("Error removing image from favorites: \(error)")
        }
    }
}
