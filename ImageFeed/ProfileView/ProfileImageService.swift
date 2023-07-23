import UIKit

final class ProfileImageService{
    
    static let shared = ProfileImageService()
    
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    
    struct UserResult: Decodable {
        let profileImage: ImageURL?
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }
    
    struct ImageURL: Decodable {
        let small: String?
    }
    
    
    
}
