import UIKit

class EditViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var folder: Folder!
    var delegate: AddNewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
                
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           view.addGestureRecognizer(tapGesture)
        titleTextField.text = folder?.title
//        detailTextField.text = folder?.detail
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
    
    
    @IBAction func clickUpdateCollectionView(_ sender: UIButton) {
        let title = titleTextField.text ?? ""
//        let detail = detailTextField.text ?? ""
        let updatedFolder = Folder(id: folder.id, title: title,items: folder.items)
        
        delegate?.updateData(folder: updatedFolder)
        navigationController?.popViewController(animated: true)
    }
}
