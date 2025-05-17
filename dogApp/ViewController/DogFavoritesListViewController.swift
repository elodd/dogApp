//
//  DogFavoritesListViewController.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-14.
//

import Foundation
import UIKit

protocol DogFavoritesListViewControllerDelegate: AnyObject {
    func didRemoveDogFromFavoritesFromList(favoriteDog: FavoriteDogModel?)
    func didAddDogToFavoritesFromList(favoriteDog: FavoriteDogModel?)
}

class DogFavoritesListViewController: UITableViewController {
    
    var favoriteDogs: [FavoriteDogModel] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FavoriteDogModelManager.shared.loadFavoriteImages() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                debugPrint("Error loading favorites: \(error)")
            case .success(let favoriteDogs):
                self.favoriteDogs = favoriteDogs
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteDogs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UITableViewCell else {
            return UITableViewCell()
        }
        
        let favoriteDog = self.favoriteDogs[indexPath.row]
        cell.textLabel?.text = "Favorite image of a \(favoriteDog.breedName)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoriteDog = self.favoriteDogs[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let dogImageViewController = storyboard.instantiateViewController(withIdentifier: "DogImageViewController") as? DogImageViewController else {
            return
        }
        dogImageViewController.imageUrl = favoriteDog.imageUrl
        dogImageViewController.breedName = favoriteDog.breedName
        dogImageViewController.favoriteDogModel = favoriteDog
        dogImageViewController.favoriteDelegate = self
        self.present(dogImageViewController, animated: true)
    }
}

extension DogFavoritesListViewController: DogFavoritesListViewControllerDelegate {
    func didRemoveDogFromFavoritesFromList(favoriteDog: FavoriteDogModel?) {
        guard let favoriteDog = favoriteDog else { return }
        for favorite in favoriteDogs {
            if favorite.breedName == favoriteDog.breedName && favorite.imageUrl == favoriteDog.imageUrl {
                favoriteDogs.removeAll { $0 == favorite }
                tableView.reloadData()
            }
        }
    }

    func didAddDogToFavoritesFromList(favoriteDog: FavoriteDogModel?) {
        guard let favoriteDog = favoriteDog else { return }
        favoriteDogs.append(favoriteDog)
        FavoriteDogModelManager.shared.addImageToFavorites(breedName: favoriteDog.breedName, imageUrl: favoriteDog.imageUrl)
        tableView.reloadData()
    }
}
