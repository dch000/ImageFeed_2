import UIKit

final class ProfileImageService{
    
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
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
    
    public func fetchProfileImageURL(_ token: String, username: String?, completion: @escaping (Result<String?, Error>) -> Void){
        assert(Thread.isMainThread)
        task?.cancel()
        guard let username = username else {return}
        guard let request = fetchProfileImageRequest(token, username: username) else {return}
        
        let task = URLSession.shared.object(for: request) { [weak self] (result: Result<UserResult,Error>) in
            guard let self = self else {return}
            self.task = nil
            switch result {
            case .success(let userResult):
                let smallSizeProfileImage = userResult.profileImage?.small
                self.avatarURL = smallSizeProfileImage
                completion(.success(self.avatarURL))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": self.avatarURL as Any])
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func fetchProfileImageRequest(_ token: String, username: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET",
            baseURL: Constants.defaultBaseURL
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
