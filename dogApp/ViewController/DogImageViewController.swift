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
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = .white
        addImageViewConstraints()
        addToolbarConstraints()
        downloadImage()
    }
    
    private func addImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    private func addToolbarConstraints() {
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
        
    private func downloadImage() {
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
    
    @IBAction func favoriteButtonTapped() {
        print("Favorite button tapped")
        // Read from database
        // Save to database
    }

    @IBAction func dismissButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
