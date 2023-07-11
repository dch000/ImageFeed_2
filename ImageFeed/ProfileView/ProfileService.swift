import UIKit

final class ProfileService {
    
    struct ProfileResult: Decodable {
        let username: String?
        let firstname: String?
        let lastname: String?
        let bio: String?
        
        enum CodingKeys: String, CodingKey {
            case username = "username"
            case firstname = "first_name"
            case lastname = "last_name"
            case bio = "bio"
        }
    }
    
    public struct Profile {
        let username: String?
        let name: String?
        let loginName: String?
        let bio: String?
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void){
        
    }
    
}
