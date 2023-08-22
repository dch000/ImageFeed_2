import ImageFeed
import Foundation
import WebKit

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ImageFeed.ProfileViewViewControllerProtocol?
    var showAlertCheck:Bool = false
    var logOutCheck: Bool = false
    var getAvatarURLCheck: Bool = false
    var updateProfileCheck: Bool = false
    var mockDetails = ("Dmitriy Chebotarev", "DCH", "Hello World")
    
    func getAvatarURL() -> URL? {
        getAvatarURLCheck = true
        return nil
    }
    
    func updateProfileDetails() -> (profileName: String, profileTag: String, profileInfo: String)? {
        updateProfileCheck = true
        let profileName = mockDetails.0
        let profileTag = mockDetails.1
        let profileInfo = mockDetails.2
        return (profileName, profileTag, profileInfo)
    }
    
    func showAlert(vc: UIViewController) {
        showAlertCheck = true
    }
    
    func logOut() {
        logOutCheck = true
    }
    
    func viewDidLoad() {
        
    }
    
    static func cleanSession() {
        
    }
    
    
}
