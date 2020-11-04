//
//  Article.swift
//  Diggy
//
//  Created by Igor Gorbachov on 25/10/20.
//

import Foundation

struct ArticleResult: Codable {
    let articles: [Article]
    enum CodingKeys: String, CodingKey {
        case articles = "results"
    }
}
struct Article: Codable {
    let id: Int
    let url: String
    let source: String
    let publishDate: String
    let section: String
    let author: String
    let type: String
    let title: String
    let abstract: String
    let keyWords: [String]
    let media: [Media]
    enum CodingKeys: String, CodingKey {
        case id, url, source, section, type, title, abstract, media
        case publishDate = "published_date"
        case author = "byline"
        case keyWords = "des_facet"
    }
    struct Media: Codable {
        let type: String
        let caption: String
        let metadata: [MetaData]
        enum CodingKeys: String, CodingKey {
            case type, caption
            case metadata = "media-metadata"
        }
        struct MetaData: Codable {
            let url: String
            let height: Int
            let width: Int
        }
    }
}
