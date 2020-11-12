//
//  Movie.swift
//  Diggy
//
//  Created by Igor Gorbachov on 11/11/20.
//

import Foundation

struct MovieData: Codable {
    let results: [MovieResult]
}

struct MovieResult: Codable {
    let displayTitle: String
    let criticName: String
    let headline: String
    let shortSummary: String
    let publicationDate: String
    let link: Link
    let multimedia: Multimedia?
    
    enum CodingKeys: String, CodingKey {
        case headline, link, multimedia
        case criticName = "byline"
        case displayTitle = "display_title"
        case shortSummary = "summary_short"
        case publicationDate = "publication_date"
    }
}

struct Link: Codable {
    let url: String
    let suggestedLinkText: String
    
    enum CodingKeys: String, CodingKey {
        case url
        case suggestedLinkText = "suggested_link_text"
    }
}

struct Multimedia: Codable {
    let titleCover: String
    
    enum CodingKeys: String, CodingKey {
        case titleCover = "src"
    }
}
