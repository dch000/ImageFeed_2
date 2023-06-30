import UIKit

struct OAuthTokenResponseBody: Decodable {
    let accesToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accesToken = "acces_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
