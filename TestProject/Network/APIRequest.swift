import Foundation

public enum RequestType: String {
    case GET, POST
}

protocol APIRequest {
    var method: RequestType { get }
    var url: URL { get }
    var parameters: [String : Any] { get }
}

extension APIRequest {
    func createRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
