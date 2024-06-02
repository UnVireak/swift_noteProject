import UIKit

class HomeTabViewController: UITabBarController {
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passUsernameToSettingsVC()
    }
    private func passUsernameToSettingsVC() {
           if let viewControllers = viewControllers {
               for viewController in viewControllers {
                   if let navController = viewController as? UINavigationController,
                      let settingsVC = navController.topViewController as? SettingViewController {
                       settingsVC.username = username
                       
                   } else if let settingsVC = viewController as? SettingViewController {
                       settingsVC.username = username
                   }
               }
           }
       }
}
