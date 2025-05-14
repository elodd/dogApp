//
//  DogListViewController.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-12.
//

import UIKit

class DogListViewController: UITableViewController {
    var dogList: [String]?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(DogCell.self, forCellReuseIdentifier: "cell")
        
        DogAPI.shared.fetchDogList() { result in
            switch result {
            case .failure(let error):
                print("Failed to fetch dog list: \(error)")
            case .success(let dogList):
                guard let message = dogList.message else {
                    print("Message in dog list is nil")
                    return
                }
                self.dogList = message.flatMap {
                    if $0.value.isEmpty {
                        return [$0.key]
                    }
                    let breedName = $0.key
                    let subBreed = $0.value.compactMap( { $0 })
                    return subBreed.map { "\(breedName) \($0)" }
                }.sorted()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dogList = dogList else {
            return 0
        }
        return dogList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DogCell", for: indexPath) as? DogCell else {
            return UITableViewCell()
        }
        guard let dogList = self.dogList else {
            return UITableViewCell()
        }
        let comboName = dogList[indexPath.row]
        cell.textLabel?.text = comboName
        cell.setup(breed: comboName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dogList = self.dogList else {
            return
        }
        let comboName = dogList[indexPath.row]
        guard let breedName = comboName.components(separatedBy: " ").first else{
            return
        }
        print("Selected dog: \(breedName)")
        showDogImage(breed: breedName)
    }

    func showDogImage(breed: String) {
        DogAPI.shared.fetchRandomImageURL(breed: breed) { result in
            switch result {
            case .failure(let error):
                print("Failed to fetch dog image: \(error)")
            case .success(let url):
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let dogImageViewController = storyboard.instantiateViewController(withIdentifier: "DogImageViewController") as? DogImageViewController else {
                        return
                    }
                    dogImageViewController.imageUrl = url.absoluteString
                    self.present(dogImageViewController, animated: true)
                }
            }
        }
    }
}

