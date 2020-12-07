//
//  MovieAPI.swift
//  Diggy
//
//  Created by Igor Gorbachov on 11/11/20.
//

import Foundation

struct APIMovieConstants {
    private init() { }
    
    static let baseURL = "https://api.nytimes.com/svc/movies/v2/reviews/"
    static let apiKey = "YVQgmNyACMdZG9g3TdXlHyjDdkIiCs3X"
}

enum MovieFilter: String {
    case byTitle = "by-title"
    case byOpeningDay = "by-opening-date"
    case byDate = "by-publication-date"
}

class MovieAPI {
    static let shared = MovieAPI()
    
    private init() { }
    
    func fetchMovies(filter: MovieFilter? = nil, search: String? = nil, completion: @escaping ([Movie]?) -> ()) {
        guard let url = configureURL(with: filter, search: search) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(nil)
                return
            }
            if let safeData = data {
                let results = self.parseJSON(movieData: safeData)
                completion(results)
            }
        }
        task.resume()
    }
    
    private func parseJSON(movieData: Data) -> [Movie]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MovieData.self, from: movieData)
            let movies = decodedData.results
            return movies
        } catch {
            print(error)
            return nil
        }
    }
    
    private func configureURL(with filter: MovieFilter?, search: String?) -> URL? {
        if let searchQuery = search {
            return URL(string: "\(APIMovieConstants.baseURL)search.json?query=\(searchQuery)&api-key=\(APIMovieConstants.apiKey)")
        } else {
            if let filter = filter?.rawValue {
                return URL(string: "\(APIMovieConstants.baseURL)picks.json?order=\(filter)&api-key=\(APIMovieConstants.apiKey)")
            } else {
                return nil
            }
        }
    }
}
