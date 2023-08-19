import UIKit
import WebKit

public protocol ProfilePresenterProtocol {
    func getAvatarURL() -> URL?
    func updateProfileDetails() -> (profileName: String, profileTag: String, profileInfo: String)?
    func showAlert(vc: UIViewController)
    func logOut()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewViewControllerProtocol?
    private var profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        window.rootViewController = SplashViewController()
    }
    
    func getAvatarURL() -> URL? {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL)
        else {return nil}
        return url
    }
    
    func updateProfileDetails() -> (profileName: String, profileTag: String, profileInfo:String)? {
        guard
            let profileName = profileService.profile?.name,
            let profileTag = profileService.profile?.loginName,
            let profileInfo = profileService.profile?.bio
        else { return nil }
        return (profileName, profileTag, profileInfo)
    }
    
    func showAlert(vc: UIViewController) {
        let alertController = UIAlertController(title: "Выход",
                                                message: "Вы уверены что хотите выйти?",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] action in
            guard let self = self else {return}
            self.logOut()
        }))
        alertController.addAction(UIAlertAction(title: "Нет", style: .default))
        vc.present(alertController, animated: true)
    }
    
    func logOut() {
        profileService.cleanSession()
        ProfileService.shared.cleanSession()
        ProfileImageService.shared.cleanSession()
        ImagesListService.shared.cleanSession()
        OAuth2TokenStorage.token?.removeAll()
        self.switchToSplashViewController()
    }
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self]  _ in
                guard let self = self else { return }
                self.view?.updateAvatar()
            }
    }
    
    static func cleanSession() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
}
