//
//  Book.swift
//  Diggy
//
//  Created by Igor Gorbachov on 5/11/20.
//

import Foundation

struct BookData: Codable {
    let results: BookResults
}

struct BookResults: Codable {
    let books: [Book]
}

struct Book: Codable {
    let description: String
    let title: String
    let author: String
    let bookImage: String
    let amazonProductURL: String

    enum CodingKeys: String, CodingKey {
        case description, title, author
        case bookImage = "book_image"
        case amazonProductURL = "amazon_product_url"
    }
}
