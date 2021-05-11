
import UIKit

final class SearchViewController: UIViewController {
    
    @IBOutlet weak private var searchTableView: UITableView! {
        didSet {
            searchTableView.register(UINib(nibName: SearchTableViewCell.className, bundle: nil), forCellReuseIdentifier: SearchTableViewCell.className)
        }
    }
    
    @IBOutlet weak private var searchIndicator: UIActivityIndicatorView!
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        let placeholder = "検索"
        searchBar.placeholder = placeholder
        return searchBar
    }()
    
    private var input: SearchPresenterInput!
    func inject(input: SearchPresenterInput) {
        self.input = input
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        input.search(searchWord: searchBar.text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
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
