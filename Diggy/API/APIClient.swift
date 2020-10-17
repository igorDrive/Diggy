import Alamofire

typealias DataResponseCompletion = (AFDataResponse<Data>) -> Void
typealias ParsedCompletion<T: Decodable> = (T?, Error?) -> Void

protocol GitHubAPI {
    func getJobs(completion: @escaping ParsedCompletion<[Job]>)
}

class APIClient {
    
    let sessionManager: Session
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        
        sessionManager = Session(configuration: configuration)
    }
    
    private func doRequest(_ urlRequest: URLRequestConvertible, completionHandler: @escaping (AFDataResponse<Data>) -> Void) {
        let request = sessionManager.request(urlRequest)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
        request.responseData(completionHandler: completionHandler)
    }

}

extension APIClient: GitHubAPI {
    func getJobs(completion: @escaping ParsedCompletion<[Job]>) {
        doRequest(GitHubAPIRouter.getJobs, withParsedCompletion: completion)
    }
}

extension APIClient {

    private func doRequest<T: Decodable>(_ urlRequest: URLRequestConvertible,
                                         withParsedCompletion completion: @escaping ParsedCompletion<T>) {
        
        DispatchQueue.global(qos: .background).async { [self] in
            doRequest(urlRequest, completionHandler: { [weak self] (response) in
                DispatchQueue.main.async {
                    self?.parseDictionaryObject(response, completion: completion)
                }
            })
        }
    }
    
    private func parseDictionaryObject<T: Decodable>(_ response: AFDataResponse<Data>,
                                                     completion: @escaping ParsedCompletion<T>) {
        switch response.result {
        case .success(let data):
            do {
                let value = try JSONDecoder().decode(T.self, from: data)
                completion(value, nil)
            } catch let error {
                completion(nil, error)
            }
        case .failure(let error):
            completion(nil, error)
        }
    }
}
