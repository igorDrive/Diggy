//
//  MovieAPI.swift
//  Diggy
//
//  Created by Igor Gorbachov on 11/11/20.
//

import Foundation

struct APIMovieConstants {
    private init() { }
    
    static let movieReview = "https://api.nytimes.com/svc/movies/v2/reviews/picks"
    static let movieSearch = "https://api.nytimes.com/svc/movies/v2/reviews/search"
    static let apiKey = "YVQgmNyACMdZG9g3TdXlHyjDdkIiCs3X"
}

enum MovieOrder: String {
    case byTitle = "by-title"
    case byOpeningDay = "by-opening-date"
    case byDate = "by-publication-date"
}

class MovieAPI {
    static let shared = MovieAPI()
    
    private init() { }
    
    func fetchMovies(order: MovieOrder, completion: @escaping ([Movie]?) -> ()) {
        guard let url = configureURL(with: order) else { return }
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
    
    func fetchMovies(movieName: String, completion: @escaping ([Movie]?) -> ()) {
        guard let url = configureURL(movieName: movieName) else { return }
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
    
    private func configureURL(with param: MovieOrder) -> URL? {
        let urlString = "\(APIMovieConstants.movieReview).json?order=\(param.rawValue)&api-key=\(APIMovieConstants.apiKey)"
        return URL(string: urlString)
    }
    
    private func configureURL(movieName: String) -> URL? {
        let urlString = "\(APIMovieConstants.movieSearch).json?query=\(movieName)&api-key=\(APIMovieConstants.apiKey)"
        return URL(string: urlString)
    }
}
