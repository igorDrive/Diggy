
import Foundation

struct Job: Codable {
    let id: String
    let type: String
    let url: String
    let createdAt: String
    let company: String
    let companyUrl: String?
    let location: String
    let title: String
    let description: String
    let howToApply: String?
    let companyLogo: String?
    
    enum CodingKeys: String, CodingKey {
        case id, type, url, company, location, title, description
        case createdAt = "created_at"
        case companyUrl = "company_url"
        case howToApply = "how_to_apply"
        case companyLogo = "company_logo"
    }
}
