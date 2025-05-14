//
//  DogFavoritesImageViewController.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-14.
//

import Foundation
import UIKit

class DogFavoritesImageViewController: UIViewController {
    
    var dogImage: UIImage?
    var dogBreed: String?
    
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var breedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = dogImage {
            dogImageView.image = image
        }
        if let breed = dogBreed {
            breedLabel.text = breed
        }
    }
}





