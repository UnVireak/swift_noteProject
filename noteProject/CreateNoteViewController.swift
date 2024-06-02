import UIKit

protocol AddNewDelegate {
    func saveData(folder: Folder)
    func updateData(folder: Folder)
}

class CreateNoteViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var bottomConstaint: NSLayoutConstraint!
    
    var delegate: AddNewDelegate?
    var folder: Folder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
                
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           view.addGestureRecognizer(tapGesture)
        
        if let folder = folder {
            titleTextField.text = folder.title
       
        }
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
        self.bottomConstaint.constant = keyboardHeight
        self.view.layoutIfNeeded()
    }
}
@objc func hideKeyboard(notification: Notification) {
     let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
     
     UIView.animate(withDuration: animationDuration) {
         self.bottomConstaint.constant = 0
         self.view.layoutIfNeeded()
     }
 }
@objc func dismissKeyboard() {
    view.endEditing(true)
}

    
    @IBAction func saveButton(_ sender: UIButton) {
        
        let title = titleTextField.text ?? ""
        if  title.isEmpty  {
            let alertController = UIAlertController(title: "Empty!", message: "Title can't be empty.", preferredStyle: .alert)
            let alertActionOK = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(alertActionOK)
            present(alertController, animated: true)
        } else{
            let newFolder = Folder(id: UUID(), title: title, items: [])
            
            if var folder = folder {
                folder.title = title
                delegate?.updateData(folder: folder)
            } else {
                delegate?.saveData(folder: newFolder)
            }
            
            navigationController?.popViewController(animated: true)
        }
              
    }
}
