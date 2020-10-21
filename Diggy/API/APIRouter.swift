
import Alamofire

protocol APIRouter {
    static var baseUrl: URL { get }
    var method: Alamofire.HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters { get }
}

enum GitHubAPIRouter: APIRouter {
    
    case getJobs
    
    static var baseUrl: URL {
        switch self {
        default:
            guard let url = URL(string: "https://jobs.github.com/positions.json") else {
                fatalError()
            }
            return url
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getJobs:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getJobs:
            return "/"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getJobs:
            return [:]
        }
    }
    
}

extension GitHubAPIRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = try GitHubAPIRouter.baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        return try encoding.encode(urlRequest, with: parameters)
    }
}


