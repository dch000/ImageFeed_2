import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private var isFirstAppear = true
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private lazy var screenLogo: UIImageView = {
        let screenLogo = UIImageView()
        screenLogo.translatesAutoresizingMaskIntoConstraints = false
        screenLogo.image = UIImage(named: "splash_screen_logo")
        return screenLogo
    } ()
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
        
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Что-то пошло не так",
                                                message: "Не удалось войти в систему",
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok",
                                   style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstAppear == true {
            if OAuth2TokenStorage.token != nil {
                guard let token = OAuth2TokenStorage.token else { return }
                fetchProfile(token: token)
                switchToTabBarController()
            } else {
                isFirstAppear = false
                guard let authViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
                    return }
                authViewController.delegate = self
                authViewController.modalPresentationStyle = .fullScreen
                present(authViewController, animated: true)
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        addViews()
        applyConstraints()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func addViews() {
        view.addSubview(screenLogo)
    }
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            screenLogo.widthAnchor.constraint(equalToConstant: 60),
            screenLogo.heightAnchor.constraint(equalToConstant: 60),
            screenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else {return}
            self.fetchOAuthToken(code)
            
        }
    }
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                self.showAlert()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userProfile):
                self.profileImageService.fetchProfileImageURL(token, username: userProfile.username) { _ in }
                self.switchToTabBarController()
            case .failure:
                break
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
