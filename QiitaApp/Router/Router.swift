
import UIKit
import SafariServices

final class Router {
    static func showRoot(window: UIWindow) {
        let searchVC = SearchViewController.makeFromStoryboard()
        let navSearchVC = UINavigationController(rootViewController: searchVC)
        window.rootViewController = navSearchVC
        window.makeKeyAndVisible()
    }
    
    static func showWeb(vc: UIViewController, url: URL, animated: Bool = true, complition: (() -> Void)? = nil) {
       let safariVC = SFSafariViewController(url: url)
        vc.present(safariVC, animated: animated, completion: complition)
    }
}
