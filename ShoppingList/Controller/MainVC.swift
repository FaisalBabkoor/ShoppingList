//
//  MainVC.swift
//  DreamLister
//
//  Created by Faisal Babkoor on 4/6/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    //IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmente: UISegmentedControl!
    //Variable
    //var fetchResualtController: NSFetchedResultsController<Item>!
    var item = [Item]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        attemptFetch()
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        attemptFetch()
        tableView.reloadData()
    }
    
    //TableView Things.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MAIN_CELL, for: indexPath) as! ItemCell
       
        let item = self.item[indexPath.row]
        cell.confeger(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let num: CGFloat = 150
        tableView.estimatedRowHeight = num
        tableView.rowHeight = UITableView.automaticDimension
        return num
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let it = item[indexPath.row]
        performSegue(withIdentifier: EditItemDetailsVC, sender: it)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == EditItemDetailsVC{
            if let destination = segue.destination as? ItemDetailsVC{
                let sen = sender as! Item
                destination.itemToEdit = sen
            }
        }
    }
    // Core Data
    func attemptFetch(){
        let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
        
        let dataSort = NSSortDescriptor(key: "created", ascending: false)
        let pricSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        let TypeSort = NSSortDescriptor(key: "toItemType", ascending: true)

        
        if segmente.selectedSegmentIndex == 0{
            fetchRequest.sortDescriptors = [dataSort]
        }else if segmente.selectedSegmentIndex == 1{
            fetchRequest.sortDescriptors = [pricSort]
            
        }else if segmente.selectedSegmentIndex == 2{
            fetchRequest.sortDescriptors = [titleSort]
            
        }else if segmente.selectedSegmentIndex == 3{
            fetchRequest.sortDescriptors = [TypeSort]
        }
        do{
            item = try context.fetch(fetchRequest)
        }catch{
            print("خطأ")
        }
    }
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        attemptFetch()
        tableView.reloadData()
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            guard let indexPath = indexPath else{return}
            tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.middle)
            break
        case .delete:
            guard let indexPath = indexPath else{return}
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
            break
        case .update:
            guard let indexPath = indexPath else{return}
            let cell = tableView.cellForRow(at: indexPath) as! ItemCell
            let item = self.item[indexPath.row]
            cell.confeger(item: item)
            break
        case . move:
            guard let indexPath = indexPath else{return}
            guard let newIndexPath = newIndexPath else{return}
            tableView.moveRow(at: indexPath, to: newIndexPath)
            
        }
    }

    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
