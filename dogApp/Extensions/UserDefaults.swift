//
//  UIUserDefaults.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-13.
//

import Foundation

extension UserDefaults {
    func setFavorite(breed: String?, value: Bool = false) {
        if let name = breed {
            if value {
                self.set(true, forKey: name)
            } else {
                self.set(false, forKey: name)
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
