import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
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
            target: ProfileViewController.self,
            action: #selector(Self.didTapButton)
        )
        logoutButton.tintColor = Resources.Colors.buttonColor
        return logoutButton
    } ()
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else {return}
        profileName.text = profileService.profile?.name
        profileTag.text = profileService.profile?.loginName
        profileInfo.text = profileService.profile?.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {return}
        let processor = RoundCornerImageProcessor(cornerRadius: 35, backgroundColor: .clear)
        avatarView.kf.indicatorType = .activity
        avatarView.kf.setImage(with: url,
                               placeholder: UIImage(named: "default_avatar"),
                               options: [.processor(processor),
                                         .cacheSerializer(FormatIndicatedCacheSerializer.png)]) {result in
                                             switch result {
                                             case.success(let value):
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
         logoutButton].map{self.view.setupView($0)}
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProfileDetails()
        updateAvatar()
    }
    
    override func viewDidLoad() {
        view.backgroundColor = Resources.Colors.backgroundColor
        addViews()
        applyConstraints()
        updateProfileDetails()
        updateAvatar()
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self = self else {return}
                self.updateAvatar()
            }
        updateAvatar()
    }
}
