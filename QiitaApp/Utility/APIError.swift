
import Foundation

enum APIError: Error {
    case responceFailed(Error?)
    case encodeFailed(Error?)
    case decodeFailed(Error)
    case emptyApiResponce
    
    var domain: String {
        switch self {
        case .responceFailed(let error):
            return "\(error?.localizedDescription ?? "error")が理由で応答に失敗しました"
        case .encodeFailed(let error):
            return "\(error?.localizedDescription ?? "error")が理由でエンコードに失敗しました"
        case .decodeFailed(let error):
            return "\(error.localizedDescription)が理由でデコードに失敗しました"
        case .emptyApiResponce:
            return "検索結果がありませんでした"
        }
    }
    
}
