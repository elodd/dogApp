//
//  DogImageViewController.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-12.
//
import UIKit

class DogImageViewController: UIViewController {
    var imageUrl: String?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = .white
        addImageViewConstraints()
        downloadImage()
    }

    func addImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }

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
