//
//  SearchViewController.swift
//  SimpleApp
//
//  Created by Erik Flores on 2/18/18.
//  Copyright © 2018 Erik Flores. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    lazy var resultController: UIViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultControllerInstance = storyboard.instantiateViewController(withIdentifier: "resultController")
        guard let resultController = resultControllerInstance as? ResultViewController else {
            fatalError("Result Controller Parse")
        }
        return resultController
    }()
    lazy var searchController: UISearchController = {
       let searchController = UISearchController(searchResultsController: resultController)
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        return searchController
    }()
    lazy var fetchResult: NSFetchedResultsController<ClassRoom> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ClassRoom>(entityName: "ClassRoom")
        let sort = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchResult = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResult.delegate = self
        return fetchResult
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.dataSource = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        do {
            try fetchResult.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension SearchViewController {
    func loadData() {
        if (fetchResult.fetchedObjects?.isEmpty)! {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            addClassRoom(id: 101, name: "Clase 101")
            addClassRoom(id: 102, name: "Clase 102")
            addClassRoom(id: 201, name: "Clase 201")
            addClassRoom(id: 202, name: "Clase 202")
            addClassRoom(id: 301, name: "Clase 301")
            addClassRoom(id: 302, name: "Clase 302")
            addClassRoom(id: 401, name: "Clase 401")
            addClassRoom(id: 402, name: "Clase 402")
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addClassRoom(id: Int, name: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let classRoom = NSEntityDescription.insertNewObject(forEntityName: "ClassRoom", into: context) as! ClassRoom
        classRoom.id = Int32(id)
        classRoom.name = name
    }
}

extension SearchViewController: UISearchControllerDelegate {
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchSearchText = NSFetchRequest<ClassRoom>(entityName: "ClassRoom")
        let sort = NSSortDescriptor(key: "id", ascending: true)
        fetchSearchText.sortDescriptors = [sort]
        let predicateSearchText = NSPredicate(format: "name CONTAINS[c] %@", searchText)
        fetchSearchText.predicate = predicateSearchText
        let fetchResultSearchText = NSFetchedResultsController(fetchRequest: fetchSearchText, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchResultSearchText.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        if let resultController = searchController.searchResultsController as? ResultViewController {
            print(fetchResultSearchText.fetchedObjects!)
            resultController.results = fetchResultSearchText.fetchedObjects!
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (fetchResult.sections?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchResult.fetchedObjects?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        cell.textLabel?.text = fetchResult.object(at: indexPath).name
        return cell
    }
}

extension SearchViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        searchTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch (type) {
        case .insert:
            self.searchTableView.insertSections(IndexSet(integer: sectionIndex) , with: .fade)
        case .delete:
            self.searchTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        searchTableView.endUpdates()
    }
}
