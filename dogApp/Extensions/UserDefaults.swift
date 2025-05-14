//
//  UIUserDefaults.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-13.
//

import Foundation

extension UserDefaults {
    func setFavorite(breed: String?, value: Bool = false) {
        if let breed = breed {
            if value {
                self.set(true, forKey: breed)
            } else {
                self.set(false, forKey: breed)
            }
            self.synchronize()
        }
    }

    func isFavorite(breed: String?) -> Bool {
        if let name = breed {
            let bool = self.bool(forKey: name)
            print("isFavorite: \(bool) for breed: \(name)")
            return bool
        }
        return false
    }
}
