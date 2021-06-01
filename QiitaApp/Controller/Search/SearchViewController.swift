
import UIKit
import Combine
import CombineCocoa

final class SearchViewController: UIViewController {
    
    @IBOutlet weak private var searchTableView: UITableView! {
        didSet {
            searchTableView.register(UINib(nibName: SearchTableViewCell.className, bundle: nil), forCellReuseIdentifier: SearchTableViewCell.className)
        }
    }
    
    @IBOutlet weak private var searchTextField: UITextField!
    
    
    private var input: SearchPresenterInput!
    func inject(input: SearchPresenterInput) {
        self.input = input
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }

}

    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        input.didSelect(index: indexPath.row)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        input.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.className, for: indexPath) as! SearchTableViewCell
        let qiitaModel = input.item(index: indexPath.row)
        cell.configure(qiitaModel: qiitaModel)
        return cell
    }
    
}

extension SearchViewController: SearchPresenterOutput {
    func update(error: APIError) {
        Alert.okAlert(vc: self, title: error.domain, message: "")
    }
    
    func appError(error: QiitaAppError) {
        Alert.okAlert(vc: self, title: error.domain, message: "")
    }
    
    func showWeb(url: URL) {
        Router.showWeb(vc: self, url: url)
    }
    
    func loding(isStart: Bool) {
        searchIndicator.animation(isStart: isStart)
    }
    
    func update(qiitaModels: [QiitaModel]) {
        searchTableView.reload()
    }
    
}
