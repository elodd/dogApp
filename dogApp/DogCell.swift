//
//  DogCell.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-13.
//

import Foundation
import UIKit

class DogCell: UITableViewCell {
    static let identifier = "DogCell"
    var isFavorite: Bool = false
    @IBOutlet weak var dogFavoriteButton: UIButton!

    func setup(breed: String) {
        let isFavorite = UserDefaults.standard.isFavorite(breed: breed)
        let imageName = isFavorite ? "star.fill" : "star"
        dogFavoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @IBAction func dogFavoriteButtonTapped(_ sender: UIButton) {
        let breed = textLabel?.text
        self.isFavorite = UserDefaults.standard.isFavorite(breed: breed)
        self.isFavorite.toggle()
        let imageName = self.isFavorite ? "star.fill" : "star"
        UserDefaults.standard.setFavorite(breed: breed, value: self.isFavorite)
        dogFavoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
