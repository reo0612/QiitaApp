
import UIKit

extension UIStoryboard {
    static var searchVC: SearchViewController {
        UIStoryboard(name: "Search", bundle: nil).instantiateInitialViewController() as! SearchViewController
    }
}
