
import Foundation
import Alamofire

protocol APIProtocol {
    func requestApiData(searchWord: String, complition: ((Result<[QiitaModel], APIError>) -> Void)?)
}

final class API: APIProtocol {
    static let shared = API()
    private init() {}
    
    private let host = "https://qiita.com/api/v2"
    
    func requestApiData(searchWord: String, complition: ((Result<[QiitaModel], APIError>) -> Void)? = nil) {
        guard let encodeStr = searchWord.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            complition?(.failure(APIError.encodeFailed(nil)))
            return
        }
        let endPoint = "items"
        let parameter = "page=1&per_page=30&query=\(encodeStr)"
        
        let urlStr = host + "/" + endPoint + "?" + parameter
        
        AF.request(urlStr, method: .get).responseJSON { responce in
            if let error = responce.error {
                complition?(.failure(APIError.responceFailed(error)))
                return
            }
            guard let data = responce.data else {
                complition?(.failure(APIError.responceFailed(nil)))
                return
            }
            do {
                let qiitaModels = try JSONDecoder().decode([QiitaModel].self, from: data)
                complition?(.success(qiitaModels))
                
            }catch(let error) {
                complition?(.failure(APIError.decodeFailed(error)))
            }
        }
    }
}
