
import Foundation
import Combine

protocol SearchViewModelInput {
    var searchWord: String { get set }
    var searchWordPublisher: Published<String>.Publisher { get }
}

protocol SearchViewModelOutput {
    var qiitaModels: [QiitaModel] { get }
    var qiitaModelsPublisher: Published<[QiitaModel]>.Publisher { get }
    var error: Error? { get }
    var errorPublisher: Published<Error?>.Publisher { get }
}

final class SearchViewModel: SearchViewModelInput, SearchViewModelOutput {
    @Published var searchWord: String = ""
    var searchWordPublisher: Published<String>.Publisher { $searchWord }
    
    @Published var error: Error? = nil
    var errorPublisher: Published<Error?>.Publisher { $error }
    @Published var qiitaModels: [QiitaModel] = []
    var qiitaModelsPublisher: Published<[QiitaModel]>.Publisher { $qiitaModels }
    
    private var cancellable = Set<AnyCancellable>()
    
    init(api: APIProtocol = API.shared) {
        let searchWordPublisher = searchWordPublisher
            .compactMap({ $0 })
            .removeDuplicates()
            .filter({ !$0.isEmpty })
            .eraseToAnyPublisher()
        
        searchWordPublisher.sink {[weak self] text in
            guard let self = self else{ return }
            api.get(searchWord: String(describing: text)).sink { complition in
                switch complition {
                case .finished:
                    print(complition)
                    
                case .failure(let error):
                    self.error = error
                }
                
            } receiveValue: { qiitaModels in
                self.qiitaModels = qiitaModels
                
            }.store(in: &self.cancellable)
        }.store(in: &cancellable)
        
    }
}
