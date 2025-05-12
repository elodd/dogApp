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
        guard let dogList = dogList,
              let message = dogList.message else {
            return 0
        }
        return message.keys.sorted().count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dogList = dogList,
              let message = dogList.message else {
            return 0
        }
        let sectionName = message.keys.sorted()[section]
        guard let sectionArray = message[sectionName] else {
            return 0
        }
        return sectionArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let dogList = dogList,
              let message = dogList.message else {
            return nil
        }
        return message.keys.sorted()[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dogList = dogList,
              let message = dogList.message else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sectionName = message.keys.sorted()[indexPath.section]
        guard let sectionArray = message[sectionName] else {
            return UITableViewCell()
        }
        cell.textLabel?.text = sectionArray[indexPath.row]
        return cell
    }
}

