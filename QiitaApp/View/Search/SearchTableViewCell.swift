
import UIKit

final class SearchTableViewCell: UITableViewCell {

    static var className: String { String(describing: SearchTableViewCell.self) }
    
    @IBOutlet weak private var nameLabel: UILabel!
    
    func configure(qiitaModel: QiitaModel) {
        nameLabel.text = qiitaModel.title
    }
}
