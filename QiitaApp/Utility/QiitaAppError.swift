
import Foundation

enum QiitaAppError: Error {
    case getQiita
    
    var domain: String {
        switch self {
        case .getQiita:
            return "値が取得できませんでした"
        }
    }
}
