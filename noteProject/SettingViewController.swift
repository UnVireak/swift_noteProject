import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let username = username {
            userNameLabel.text = "Welcom \(username.capitalized)!"
        }
    }
    @IBAction func logOutButton(_ sender: Any) {
        logout()
        
    }
    func logout() {
         let alertController = UIAlertController(title: "Logout", message: "Do you want to logout?", preferredStyle: .alert)
         
         let handleOK = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
             self?.logoutFunc()
         }
         
         let handleCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         
         alertController.addAction(handleOK)
         alertController.addAction(handleCancel)
         
         present(alertController, animated: true, completion: nil)
     }
    
    func logoutFunc() {
            username = nil
            userNameLabel.text = ""
            
            if let presentingVC = self.presentingViewController {
                presentingVC.dismiss(animated: true, completion: nil)
            }
        }
}
