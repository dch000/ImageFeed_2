import UIKit

enum Constants {
    static let accessKey = "7QKQeSqaqfMmIbgDG4LMPUJLVK-rdQ4lpa0rdIqQM4w"
    static let secretKey = "MJDZmFZ6dt3uyzYdOEWQsy7r0GkAB-SYkRBNJ3vBtGM"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL = URL(string: "https://api.unsplash.com/")!
    static let authURLString = "https://unsplash.com/oauth/authorize"
}
struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accesScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey ,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accesScope: Constants.accessScope,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 authURLString: Constants.authURLString)
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accesScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accesScope = accesScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}

