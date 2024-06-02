//
//  TableViewController.swift
//  noteProject
//
//  Created by mac on 18/5/24.
//

import UIKit

class TableViewController: UIViewController{
 
    
    
    @IBOutlet weak var tableView: UITableView!

    var folder: Folder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func clickCreateTable(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CreateNoteTableViewController") as! CreateNoteTableViewController
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    


}
extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        let item = folder.items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.detail // Set the detail text label
        return cell
    }
    
    
}
extension TableViewController:  UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, complete in
            self?.confirmDeleteItem(at: indexPath) { confirmed in
                if confirmed {
                    self?.deleteItem(at: indexPath)
                }
                complete(confirmed)
            }
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, complete in
            
            self?.editdata(at: indexPath)
            complete(true)
        }
        editAction.backgroundColor = UIColor(red: 0/255, green: 127/255, blue: 255/255, alpha: 1.0)
               
                
    
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    func confirmDeleteItem(at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
         let alertController = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
         
         let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
             completion(true)
         }
         
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
             completion(false)
         }
         
         alertController.addAction(confirmAction)
         alertController.addAction(cancelAction)
         
         present(alertController, animated: true, completion: nil)
     }
    
    func deleteItem(at indexPath: IndexPath) {
        folder.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        DataManager.shared.saveFolder(folder) // Save changes to DataManager
    }
    
    @objc func editdata(at indexPath: IndexPath){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "UpdateNoteTableViewController") as! UpdateNoteTableViewController
        let item = folder.items [indexPath.row]
        viewController.note = item
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension TableViewController: CreateNoteTableDelegate {
    func saveData(note: Item) {
        if let index = folder.items.firstIndex(where: { $0.id == note.id }) {
                folder.items[index] = note
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            } else {
                folder.items.append(note)
                tableView.insertRows(at: [IndexPath(row: folder.items.count - 1, section: 0)], with: .fade)
            }
        DataManager.shared.saveFolder(folder)
    }
    
    func updateData(note: Item) {
        if let index = folder.items.firstIndex(where: { $0.id == note.id }) {
            folder.items[index] = note
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        DataManager.shared.saveFolder(folder)
        
    }
}

