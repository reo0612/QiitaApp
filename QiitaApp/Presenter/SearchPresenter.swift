
import Foundation

protocol SearchPresenterInput {
    var numberOfItems: Int { get }
    func search(searchWord: String?)
    func didSelect(index: Int)
    func item(index: Int) -> QiitaModel
}

protocol SearchPresenterOutput: AnyObject {
    func loding(isStart: Bool)
    func update(error: APIError)
    func update(qiitaModels: [QiitaModel])
    func appError(error: QiitaAppError)
    func showWeb(url: URL)
}

final class SearchPresenter {

    private weak var output: SearchPresenterOutput!
    private var api: APIProtocol!
    private var qiitaModels: [QiitaModel]
    
    init(output: SearchPresenterOutput, api: APIProtocol = API.shared) {
        self.output = output
        self.api = api
        self.qiitaModels = []
    }
}

extension SearchPresenter: SearchPresenterInput {
    func search(searchWord: String?) {
        guard let searchWord = searchWord else { return }
        
        output.loding(isStart: true)
        
        api.requestApiData(searchWord: searchWord) {[weak self] result in
            switch result {
            case .success(let qiitaModels):
                guard !qiitaModels.isEmpty else {
                    self?.output.loding(isStart: false)
                    self?.output.update(error: APIError.emptyApiResponce)
                    return
                }
                self?.output.loding(isStart: false)
                self?.qiitaModels = qiitaModels
                self?.output.update(qiitaModels: qiitaModels)
                
            case .failure(let error):
                self?.output.loding(isStart: false)
                self?.output.update(error: error)
            }
        }
    }
    
    var numberOfItems: Int {
        return qiitaModels.count
    }
    
    func item(index: Int) -> QiitaModel {
        return qiitaModels[index]
    }
    
    func didSelect(index: Int) {
        guard let url = URL(string: qiitaModels[index].url) else {
            output.appError(error: QiitaAppError.getQiita)
            return
        }
        output.showWeb(url: url)
    }
    
}

