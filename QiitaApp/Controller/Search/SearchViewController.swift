
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
    
    private var input: SearchViewModelInput!
    private var output: SearchViewModelOutput!
    
    private var cancellable = Set<AnyCancellable>()
    
    static func makeFromStoryboard() -> SearchViewController {
        let vc = UIStoryboard.searchVC
        let viewModel = SearchViewModel()
        vc.input = viewModel
        vc.output = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        setupViewModel()
    }

}

private extension SearchViewController {
    func setupViewModel() {
        searchTextField.textPublisher
            .compactMap({ $0 }) // nil回避
            .removeDuplicates() // 重複した値を続けて流さない
            .filter({ !$0.isEmpty }) // 空じゃなかったら
            .debounce(for: .milliseconds(600), scheduler: RunLoop.main) // 入力されて6秒以上
            .sink {[weak self] text in
                self?.input.searchWord = text
            }.store(in: &cancellable)
        
        output.qiitaModelsPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.searchTableView.reloadData()
            }.store(in: &cancellable)
        
        output.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] error in
                guard let self = self else { return }
                guard let error = error else { return }
                Alert.okAlert(vc: self, title: error.localizedDescription, message: "")
            }.store(in: &cancellable)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = URL(string: output.qiitaModels[indexPath.row].url)!
        Router.showWeb(vc: self, url: url)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.qiitaModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.className, for: indexPath) as! SearchTableViewCell
        let qiitaModel = output.qiitaModels[indexPath.row]
        cell.configure(qiitaModel: qiitaModel)
        return cell
    }
    
}
