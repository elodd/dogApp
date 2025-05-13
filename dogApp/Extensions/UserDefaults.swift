//
//  UIUserDefaults.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-13.
//

import Foundation

extension UserDefaults {
    func setDogFavorite(breed: String?, value: Bool = false ) {
        if let breed = breed {
            if value {
                self.set(true, forKey: breed)
            } else {
                self.set(false, forKey: breed)
            }
            self.synchronize()
        }
    }

    func getDogFavorite(breed: String?) -> Bool {
        if let breed = breed {
            return self.bool(forKey: breed)
        }
        return false
    }
}
