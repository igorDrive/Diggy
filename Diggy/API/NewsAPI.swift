//
//  NewsAPI.swift
//  Diggy
//
//  Created by Igor Gorbachov on 29/10/20.
//

import Foundation

struct APINewsConstants {
    private init() { }
    
    static let mostPopularBaseURL = "https://api.nytimes.com/svc/mostpopular/v2/emailed/"
    static let apiKey = "YVQgmNyACMdZG9g3TdXlHyjDdkIiCs3X"
}

enum Period: Int {
    case oneDay = 1
    case sevenDays = 7
    case thirtyDays = 30
}

class NewsAPI {
    static let shared = NewsAPI()
    
    private init() { }
    
    func fetchNews(period: Period, completion: @escaping ([Article]?) -> ()) {
        guard let url = configureURL(period: period) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(nil)
                return
            }
            if let safeData = data {
                let results = self.parseJSON(articleData: safeData)
                completion(results)
            }
        }
        task.resume()
    }
    
    private func parseJSON(articleData: Data) -> [Article]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ArticleResult.self, from: articleData)
            let articles = decodedData.articles
            return articles
        } catch {
            print(error)
            return nil
        }
    }
    
    private func configureURL(period: Period) -> URL? {
        let urlString = "\(APINewsConstants.mostPopularBaseURL)\(period.rawValue).json?api-key=\(APINewsConstants.apiKey)"
        return URL(string: urlString)
    }
}
