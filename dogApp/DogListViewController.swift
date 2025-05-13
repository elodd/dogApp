//
//  DogListViewController.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-12.
//

import UIKit

class DogListViewController: UITableViewController {
    
    var dogList: DogAPI.DogList?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        DogAPI.shared.fetchDogList() { result in
            switch result {
            case .failure(let error):
                print("Failed to fetch dog list: \(error)")
            case .success(let dogList):
                self.dogList = dogList
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
        guard let dogList = dogList,
              let message = dogList.message else {
            return 0
        }
        return message.keys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dogList = dogList,
              let message = dogList.message else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sectionName = message.keys.sorted()[indexPath.row]
        cell.textLabel?.text = sectionName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dogList = dogList,
              let message = dogList.message else {
            return
        }
        let sectionName = message.keys.sorted()[indexPath.row]
        print("Selected dog: \(sectionName)")
        showDogImage(breed: sectionName)
    }

    // TODO: Correct showDogImage() method
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

