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
    
    func fetchBooks(genre: BookGenre, completion: @escaping ([Book]?) -> ()) {
        guard let url = configureURL(with: genre) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(nil)
                return
            }
            if let safeData = data {
//                print(safeData.printJSON1())
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
    
    private func configureURL(with param: BookGenre) -> URL? {
        let urlString = "\(APIBookConstants.bestSellersURL)\(param.rawValue).json?api-key=\(APIBookConstants.apiKey)"
        return URL(string: urlString)
    }
}

//extension Data
//{
//    func printJSON1()
//    {
//        if let JSONString = String(data: self, encoding: String.Encoding.utf8)
//        {
//            print(JSONString)
//        }
//    }
//}
