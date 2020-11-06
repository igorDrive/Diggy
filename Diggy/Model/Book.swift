//
//  Book.swift
//  Diggy
//
//  Created by Igor Gorbachov on 5/11/20.
//

//import Foundation
//
//struct BookResult: Codable {
//    let results: Results
//}
//
//struct Results: Codable {
//    let books: [Book]
//}
//
//struct Book: Codable {
//    let description: String
//    let title: String
//    let author: String
//    let book_image: String
//    let amazon_product_url: String
//}


import Foundation

// MARK: - Welcome
struct BookData: Codable {
    let results: BookResults
}

// MARK: - Results
struct BookResults: Codable {
    let books: [Book]
}

// MARK: - Book
struct Book: Codable {
    let rank, rankLastWeek, weeksOnList, asterisk: Int
    let dagger: Int
    let primaryIsbn10, primaryIsbn13, publisher, bookDescription: String
    let price: Int
    let title, author, contributor, contributorNote: String
    let bookImage: String
    let bookImageWidth, bookImageHeight: Int
    let amazonProductURL: String
    let ageGroup, bookReviewLink, firstChapterLink, sundayReviewLink: String
    let articleChapterLink: String
    let isbns: [Isbn]
    let buyLinks: [BuyLink]
    let bookURI: String

    enum CodingKeys: String, CodingKey {
        case rank
        case rankLastWeek = "rank_last_week"
        case weeksOnList = "weeks_on_list"
        case asterisk, dagger
        case primaryIsbn10 = "primary_isbn10"
        case primaryIsbn13 = "primary_isbn13"
        case publisher
        case bookDescription = "description"
        case price, title, author, contributor
        case contributorNote = "contributor_note"
        case bookImage = "book_image"
        case bookImageWidth = "book_image_width"
        case bookImageHeight = "book_image_height"
        case amazonProductURL = "amazon_product_url"
        case ageGroup = "age_group"
        case bookReviewLink = "book_review_link"
        case firstChapterLink = "first_chapter_link"
        case sundayReviewLink = "sunday_review_link"
        case articleChapterLink = "article_chapter_link"
        case isbns
        case buyLinks = "buy_links"
        case bookURI = "book_uri"
    }
}

// MARK: - BuyLink
struct BuyLink: Codable {
    let name: Name
    let url: String
}

enum Name: String, Codable {
    case amazon = "Amazon"
    case appleBooks = "Apple Books"
    case barnesAndNoble = "Barnes and Noble"
    case booksAMillion = "Books-A-Million"
    case bookshop = "Bookshop"
    case indiebound = "Indiebound"
}

// MARK: - Isbn
struct Isbn: Codable {
    let isbn10, isbn13: String
}

