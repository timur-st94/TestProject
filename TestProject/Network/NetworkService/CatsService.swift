import Foundation

final class CatsService {
    private let client = APIClient()
    
    func catsRequest(completion: @escaping ([CatModel]?, Error?) -> ()) {
        let requestModel = CatsRequestModel()
        client.send(request: requestModel.createRequest(), completion: completion)
    }
}
