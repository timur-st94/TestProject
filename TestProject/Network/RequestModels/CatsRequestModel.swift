import Foundation

struct CatsRequestModel: APIRequest {
    let method = RequestType.GET
    let url = URL(string: Constants.catsPath)!
    let parameters = [String: Any]()
}
