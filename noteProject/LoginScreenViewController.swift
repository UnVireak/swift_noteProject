import UIKit

class LoginScreenViewController: UIViewController {
    
    @IBOutlet weak var mainViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
                
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           view.addGestureRecognizer(tapGesture)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameTextField.becomeFirstResponder()
    }

    @objc func showKeyboard(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
        
        UIView.animate(withDuration: animationDuration) {
            self.stackBottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    @objc func hideKeyboard(notification: Notification) {
         let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
         
         UIView.animate(withDuration: animationDuration) {
             self.stackBottomConstraint.constant = 0
             self.view.layoutIfNeeded()
         }
     }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveLoginButton(_ sender: UIButton) {
        
        let userName = userNameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        let basseUsername = "aditi"
        let basePassword = "2024"
        
        if( ((userName == basseUsername) || (userName == "admin")) &&  (password == basePassword )){
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarController = storyboard.instantiateViewController(withIdentifier: "Tab") as? HomeTabViewController {
                tabBarController.username = userNameTextField.text
                tabBarController.modalPresentationStyle = .fullScreen
                present(tabBarController, animated: true, completion: nil)
                userNameTextField.text = nil
                passwordTextField.text = nil
            }
        }
        else if ((userName.isEmpty || userName == "") || (password.isEmpty || password == "")){
                
                let alertController = UIAlertController(title: "Error", message: "Please complete the field", preferredStyle: .alert)
                present(alertController, animated: true)
                let alrtAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
                alertController.addAction(alrtAction)
            } else{
                
                let alertController = UIAlertController(title: "Error", message: "username or password incorrect", preferredStyle: .alert)
                present(alertController, animated: true)
                let alrtAction = UIAlertAction(title: "Close", style: .destructive, handler: nil)
                alertController.addAction(alrtAction)
            }
            
            
        }
        
    }
    

