
import UIKit

extension UITableView {
    func reload() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
