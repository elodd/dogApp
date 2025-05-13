//
//  DogImageViewController.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-12.
//
import UIKit

class DogImageViewController: UIViewController {
    var imageUrl: String?
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = .white
        downloadImage()
    }

    // TODO: Correct assigning the image 
    func downloadImage() {
        guard let imageUrl = imageUrl,
              let imageUrl = URL(string: imageUrl) else {
            return
        }
        DogAPI.shared.fetchDogImage(from: imageUrl) { result in
            switch result {
            case .failure(let error):
                print("Failed to fetch dog image: \(error)")
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    print("Image data is nil")
                    return
                }
                guard let imageView = self.imageView else {
                    return
                }
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }
}
