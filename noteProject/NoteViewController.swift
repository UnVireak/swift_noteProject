//
//  CollectionViewController.swift
//  Second-Project
//
//  Created by user241995 on 5/12/24.
//

import UIKit


class NoteViewController: UIViewController {
    
    var selectedFolder: Folder?
    
    @IBOutlet weak var collectionView: UICollectionView!
    var folderNote: [Folder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         folderNote = DataManager.shared.folders
         collectionView.reloadData()
     }
    
    @IBAction func clickCreateNote(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let viewController = storyboard.instantiateViewController(identifier: "CreateNoteViewController") as! CreateNoteViewController
               viewController.delegate = self
               navigationController?.pushViewController(viewController, animated: true)
        
    }
    

}
extension NoteViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folderNote.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for:indexPath) as! NoteCollectionViewCell
        let note = folderNote[indexPath.row]
        cell.layer.cornerRadius = 8
        cell.titleLabel?.text = note.title
        return cell
    }
    
    
}

extension NoteViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFolder = folderNote[indexPath.row]
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
              if let detailVC = storyboard.instantiateViewController(withIdentifier: "TableViewController") as? TableViewController {
                  detailVC.folder = selectedFolder
                  detailVC.hidesBottomBarWhenPushed = true
                  navigationController?.pushViewController(detailVC, animated: true)
              }
//
    }

    
    func presentDeleteConfirmationAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Folder", message: "Are you sure you want to delete this folder and all its notes?", preferredStyle: .alert)

                let yesAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] _ in
                    self?.deleteFolder(at: indexPath)

                }

                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

                alert.addAction(yesAction)
                alert.addAction(noAction)

                present(alert, animated: true, completion: nil)
    }
    func deleteFolder(at indexPath: IndexPath) {
          DataManager.shared.removeFolder(at: indexPath.item)
          folderNote.remove(at: indexPath.item)
          collectionView.deleteItems(at: [indexPath])
      }
    

    internal func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
                  guard let self = self else { return nil }
            
            let editAction = UIAction(title: "Edit", image: UIImage(systemName: "arrow.clockwise.circle")) { [weak self] _ in
                         guard let self = self else { return }
                         let storyboard = UIStoryboard(name: "Main", bundle: nil)
                         let viewController = storyboard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
                        viewController.hidesBottomBarWhenPushed = true
                         viewController.folder = self.folderNote[indexPath.item]
                         viewController.delegate = self
                         self.navigationController?.pushViewController(viewController, animated: true)
                     }

                     let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                         self?.presentDeleteConfirmationAlert(for: indexPath)
                     }

                     return UIMenu(title: "Actions", children: [editAction, deleteAction])
                 }
    }
    
    }
    


extension  NoteViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let size = (width - 10)/4 - 10

        return CGSize(width: size, height: size)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
extension NoteViewController : AddNewDelegate{
    func saveData(folder: Folder) {
        DataManager.shared.saveFolder(folder)
        folderNote = DataManager.shared.folders
        collectionView.reloadData()

    }
    
    func updateData(folder: Folder) {
        DataManager.shared.saveFolder(folder)
              folderNote = DataManager.shared.folders
              collectionView.reloadData()
        }
    }

  
    
    

