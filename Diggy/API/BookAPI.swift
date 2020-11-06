//
//  BookAPI.swift
//  Diggy
//
//  Created by Igor Gorbachov on 5/11/20.
//

import Foundation

struct APIBookConstants {
    private init() { }
    
    static let bestSellersURL = "https://api.nytimes.com/svc/books/v3/lists/current/"
    static let apiKey = "YVQgmNyACMdZG9g3TdXlHyjDdkIiCs3X"
}

enum BookGenre: String {
    case hardCover = "hardcover-fiction"
    case paperCover = "paperback-nonfiction"
    case ebook = "e-book-fiction"
}

class BookAPI {
    static let shared = BookAPI()
    
    private init() { }
    
    func fetchBooks(genre: BookGenre,completion: @escaping ([Book]?) -> ()) {
        guard let urlComponents = configureURL(with: genre) else { return }
        let session = URLSession(configuration: .default)
        let urlRequest = URLRequest(url: urlComponents.url!)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                completion(nil)
                return
            }
            if let safeData = data {
                print(safeData.printJSON())
                let results = self.parseJSON(bookData: safeData)
                completion(results)
            }
        }
        task.resume()
    }
    
    private func parseJSON(bookData: Data) -> [Book]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(BookData.self, from: bookData)
            let books = decodedData.results.books
            return books
        } catch {
            print(error)
            return nil
        }
    }
    
    private func configureURL(with param: BookGenre) -> URLComponents? {
        let urlString = "\(APIBookConstants.bestSellersURL)\(param.rawValue).json"
        var url = URLComponents(string: urlString)
        url?.queryItems = [
            URLQueryItem(name: "api-key", value: APIBookConstants.apiKey)
        ]
        return url
    }
}

extension Data
{
    func printJSON()
    {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8)
        {
            print(JSONString)
        }
    }
}
