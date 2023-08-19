import UIKit
import WebKit

public protocol ProfilePresenterProtocol {
    func getAvatarURL() -> URL?
    func updateProfileDetails() -> (profileName: String, profileTag: String, profileInfo: String)?
    
}

final class ProfilePresenter: ProfilePresenterProtocol {
    private var profileService = ProfileService.shared
    
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
    
    func showAlert() {
        let alertController = UIAlertController(title: "Выход",
                                                message: "Вы уверены что хотите выйти?",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] action in
            guard let self = self else {return}
            self.logOut()
        }))
        alertController.addAction(UIAlertAction(title: "Нет", style: .default))
        present(alertController, animated: true)
    }
    
    
}
