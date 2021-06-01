
import Foundation
import Combine

protocol APIProtocol {
    func get(searchWord: String) -> AnyPublisher<[QiitaModel], Error>
}

final class API: APIProtocol {
    static let shared = API()
    private init() {}
    
    private let host = "https://qiita.com/api/v2"
    
    func get(searchWord: String) -> AnyPublisher<[QiitaModel], Error> {
        let encodeStr = searchWord.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let endPoint = "items"
        let parameter = "page=1&per_page=30&query=\(encodeStr)"
        
        let url = URL(string: host + "/" + endPoint + "?" + parameter)!
        var urlRequest = URLRequest(url: url)
        let httpMethod = "GET"
        urlRequest.httpMethod = httpMethod
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest).tryMap { element -> Data in
            guard
                let responce = element.response as? HTTPURLResponse,
                responce.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            return element.data
        }
        .decode(type: [QiitaModel].self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
}
