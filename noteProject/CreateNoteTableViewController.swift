//
//  CreateNoteTableViewController.swift
//  noteProject
//
//  Created by mac on 19/5/24.
//

import UIKit

protocol CreateNoteTableDelegate {
    func saveData(note: Item)
    func updateData(note: Item)
}

class CreateNoteTableViewController: UIViewController {
    var delegate: CreateNoteTableDelegate?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
                
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           view.addGestureRecognizer(tapGesture)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.becomeFirstResponder()
    }

    @objc func showKeyboard(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
        
        UIView.animate(withDuration: animationDuration) {
            self.bottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    @objc func hideKeyboard(notification: Notification) {
         let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
         
         UIView.animate(withDuration: animationDuration) {
             self.bottomConstraint.constant = 0
             self.view.layoutIfNeeded()
         }
     }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

    
    @IBAction func saveDataTableButton(_ sender: UIButton) {
        validateTitle()
       
    }
    
    func validateTitle() {
        guard let title = titleTextField.text, !title.isEmpty else {
            presentAlertAction()
            return
        }
        let note = Item(title: title, detail: detailTextField.text)
                delegate?.saveData(note: note)
                
                // Optionally, dismiss the view controller after saving
                navigationController?.popViewController(animated: true)
    }
    func presentAlertAction() {
         let alertController = UIAlertController(title: "Error", message: "Title cannot be empty", preferredStyle: .alert)
         let handleOK = UIAlertAction(title: "OK", style: .default, handler: nil)
         alertController.addAction(handleOK)
         present(alertController, animated: true, completion: nil)
     }
    

}
