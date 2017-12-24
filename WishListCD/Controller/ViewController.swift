//
//  ViewController.swift
//  WishListCD
//
//  Created by Ulices Meléndez on 17/12/17.
//  Copyright © 2017 Ulices Meléndez Acosta. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var filterSegmentControl: UISegmentedControl!
    
    var fetchResultsController: NSFetchedResultsController<Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        
        //generateTestData()
        attemptFetch()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let items = fetchResultsController.fetchedObjects, items.count > 0 {
            let item = items[indexPath.row]
            performSegue(withIdentifier: "ItemDetailVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailVC" {
            if let destination = segue.destination as? ItemDetailsViewController {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        let item = fetchResultsController.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    @IBAction func filterSegmentChange(_ sender: Any) {
        attemptFetch()
        itemsTableView.reloadData()
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        let dataSort: NSSortDescriptor!
        let selectedFilter = filterSegmentControl.selectedSegmentIndex
        
        if selectedFilter == 0 {
            dataSort = NSSortDescriptor(key: "creationDate", ascending: false)
        } else if selectedFilter == 1 {
            dataSort = NSSortDescriptor(key: "price", ascending: true)
        } else {
            dataSort = NSSortDescriptor(key: "title", ascending: true)
        }
        
//        let dateSort = NSSortDescriptor(key: "creationDate", ascending: false)
//        let priceSort = NSSortDescriptor(key: "price", ascending: true)
//        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [dataSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        fetchResultsController = controller
        
        
        do {
            try controller.performFetch()
        } catch let error as NSError {
            print("Error: \(error)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        itemsTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        itemsTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case.insert:
            if let index = newIndexPath {
                itemsTableView.insertRows(at: [index], with: .fade)
            }
            
        case.delete:
            if let index = indexPath {
                itemsTableView.deleteRows(at: [index], with: .fade)
            }
            
        case.update:
            if let index = indexPath {
                let cell = itemsTableView.cellForRow(at: index) as! ItemCell
                configureCell(cell: cell, indexPath: index as NSIndexPath)
            }
            
        case.move:
            if let index = indexPath {
                itemsTableView.deleteRows(at: [index], with: .fade)
            } else if let index = newIndexPath {
                itemsTableView.insertRows(at: [index], with: .fade)
            }
            
        default:
            break
        }
    }
    
    func generateTestData() {
        let item = Item(context: context)
        item.title = "iPhone X"
        item.price = 1000
        item.detail = "Details Details Details Details Details Details Details"
        
        let item1 = Item(context: context)
        item1.title = "Mac Book Pro"
        item1.price = 2000
        item1.detail = "Details Details Details Details Details Details Details"
        
        let item2 = Item(context: context)
        item2.title = "iPad"
        item2.price = 350
        item2.detail = "Details Details Details Details Details Details Details"
        
        let item3 = Item(context: context)
        item3.title = "IDK"
        item3.price = 99
        item3.detail = "Details Details Details Details Details Details Details"
        
    }
    
}

























