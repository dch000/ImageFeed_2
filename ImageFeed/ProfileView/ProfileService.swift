import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    private var task: URLSessionTask?
    private (set) var profile: Profile?
    
    
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
    
    public func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void){
        assert(Thread.isMainThread)
        task?.cancel()
        guard let request = fetchProfileRequest(token) else {return}
        let task = URLSession.shared.object(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else {return}
            self.task = nil
            switch result {
            case .success(let profileResult):
                self.profile = Profile(username: profileResult.username ?? "",
                                       name: "\(profileResult.firstname ?? "") \(profileResult.lastname ?? "") ",
                                       loginName: "@\(profileResult.username ?? "")",
                                       bio: profileResult.bio ?? "")
                //TODO: profile image
                print("\(String(describing: self.profile))")
                completion(.success(self.profile!))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
        
    }
    
    private func fetchProfileRequest(_ token: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(path: "/me",
                                                 httpMethod: "GET",
                                                 baseURL: URL(string: "https://api.unsplash.com")!
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
