import UIKit
import Kingfisher


public protocol ProfileViewViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar()
}

final class ProfileViewController: UIViewController, ProfileViewViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    private lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
        avatarView.image = UIImage(named: "default_avatar")
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
        logoutButton.accessibilityIdentifier = "logoutButton"
        logoutButton.tintColor = Resources.Colors.buttonColor
        return logoutButton
    } ()
    
    func configure(_ presenter: ProfilePresenterProtocol) {
            self.presenter = presenter
            self.presenter?.view = self
         }
    
    func updateProfileDetails() {
        profileName.text = presenter?.updateProfileDetails()?.profileName
        profileTag.text = presenter?.updateProfileDetails()?.profileTag
        profileInfo.text = presenter?.updateProfileDetails()?.profileInfo
    }
    
    func updateAvatar() {
        guard let url = presenter?.getAvatarURL() else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 35, backgroundColor: .clear)
        avatarView.kf.indicatorType = .activity
        avatarView.kf.setImage(with: url,
                               placeholder: UIImage(named: "default_avatar"),
                               options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)]) { result in
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
        presenter?.showAlert(vc: self)
    }
    
    private func logOut() {
        presenter?.logOut()
    }
 
    override func viewDidLoad() {
        view.backgroundColor = Resources.Colors.backgroundColor
        addViews()
        applyConstraints()
        updateProfileDetails()
        updateAvatar()
        presenter?.view = self
    }
}
