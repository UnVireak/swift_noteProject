//
//  UpdateNoteTableViewController.swift
//  noteProject
//
//  Created by mac on 19/5/24.
//

import UIKit

class UpdateNoteTableViewController: UIViewController {
    var note: Item!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var delegate: CreateNoteTableDelegate?
    @IBOutlet weak var detailTextField: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
                
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           view.addGestureRecognizer(tapGesture)

        titleTextField.text = note.title
        detailTextField.text = note.detail
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
    
    @IBAction func clickUpdateNote(_ sender: Any) {
        let title = titleTextField.text ?? ""
        let detail = detailTextField.text ?? ""
        let updatedItem = Item(id: note.id, title: title, detail: detail)
        delegate?.updateData(note: updatedItem)
        navigationController?.popViewController(animated: true)
    }
    

}
