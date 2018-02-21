//
//  ResultViewController.swift
//  SimpleApp
//
//  Created by Erik Flores on 2/18/18.
//  Copyright © 2018 Erik Flores. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultTableView: UITableView!
    var results = [ClassRoom]() {
        didSet {
            resultTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row].name
        return cell
    }
}

