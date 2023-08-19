import UIKit
import Kingfisher
import WebKit

public protocol ProfileViewViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar()
}

final class ProfileViewController: UIViewController, ProfileViewViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
        avatarView.contentMode = .scaleAspectFill
        avatarView.layer.cornerRadius = 35
        avatarView.clipsToBounds = true
        return avatarView
    } ()
    
    private lazy var profileName: UILabel = {
        let profileName = UILabel()
        profileName.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        profileName.textColor = .white
        return profileName
    } ()
    
    private lazy var profileTag: UILabel = {
        let profileTag = UILabel()
        profileTag.font = UIFont.systemFont(ofSize: 13)
        profileTag.textColor = Resources.Colors.tagColor
        return profileTag
    } ()
    
    private lazy var profileInfo: UILabel = {
        let profileInfo = UILabel()
        profileInfo.font = UIFont.systemFont(ofSize: 13)
        profileInfo.textColor = .white
        return profileInfo
    } ()
    
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton.systemButton(
            with: Resources.Images.Profile.logoutButton ?? UIImage(),
            target: self,
            action: #selector(Self.didTapButton)
        )
        logoutButton.tintColor = Resources.Colors.buttonColor
        return logoutButton
    } ()
    
    private func avatarAnimation() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: 70, height: 70))
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 35
        gradient.masksToBounds = true
        
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
        avatarView.layer.addSublayer(gradient)
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 35, backgroundColor: .clear)
        avatarView.kf.indicatorType = .activity
        avatarView.kf.setImage(with: url, placeholder: UIImage(named: "default_avatar"), options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)]) { result in
            switch result {
            case .success(let value):
                print(value.image)
                print(value.cacheType)
                print(value.source)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addViews() {
        [avatarView,
         profileName,
         profileTag,
         profileInfo,
         logoutButton].forEach(view.setupView(_:))
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarView.heightAnchor.constraint(equalToConstant: 70),
            avatarView.widthAnchor.constraint(equalToConstant: 70),
            
            profileName.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 8),
            profileName.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            profileName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            
            profileTag.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 8),
            profileTag.leadingAnchor.constraint(equalTo: profileName.leadingAnchor),
            profileTag.trailingAnchor.constraint(equalTo: profileName.trailingAnchor),
            
            profileInfo.topAnchor.constraint(equalTo: profileTag.bottomAnchor, constant: 8),
            profileInfo.leadingAnchor.constraint(equalTo: profileName.leadingAnchor),
            profileInfo.trailingAnchor.constraint(equalTo: profileName.trailingAnchor),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
        ])
    }
    
    @objc private func didTapButton(){
        showAlert()
    }
    
    static func cleanSession() {
     
    }
    
    private func cleanAllService() {
        ProfileService.shared.cleanSession()
        ProfileImageService.shared.cleanSession()
        ImagesListService.shared.cleanSession()
        ProfileViewController.cleanSession()
    }
    
    private func logOut() {
        cleanAllService()
        switchToSplashViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProfileDetails()
        updateAvatar()
        //avatarAnimation()
    }
    
    override func viewDidLoad() {
        view.backgroundColor = Resources.Colors.backgroundColor
        addViews()
        applyConstraints()
        updateProfileDetails()
        updateAvatar()
       
    }
}
