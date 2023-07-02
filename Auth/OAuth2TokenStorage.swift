import UIKit

class OAuth2TokenStorage {
    var bearerToken = "Token"
    
    var token: String? {
        set {
            return UserDefaults.standard.set(newValue, forKey: bearerToken)
        }
        get {
            UserDefaults.standard.string(forKey: bearerToken)
        }
    }
}
