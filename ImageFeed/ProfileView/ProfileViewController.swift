import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var avatarTemp: UIImageView = {
        let avatarTemp = UIImageView()
        avatarTemp.image = Res.Images.Profile.tempAvatar
        return avatarTemp
    } ()
    
    private lazy var profileName: UILabel = {
        let profileName = UILabel()
        profileName.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        profileName.textColor = .white
        profileName.text = "Екатерина Новикова"
        return profileName
    } ()
    
    private lazy var profileTag: UILabel = {
        let profileTag = UILabel()
        profileTag.font = UIFont.systemFont(ofSize: 13)
        profileTag.textColor = Res.Colors.tagColor
        profileTag.text = "@ekaterina_nov"
        return profileTag
    } ()
    
    private lazy var profileInfo: UILabel = {
        let profileInfo = UILabel()
        profileInfo.font = UIFont.systemFont(ofSize: 13)
        profileInfo.textColor = .white
        profileInfo.text = "Hello, world!"
        return profileInfo
    } ()
    
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton.systemButton(
            with: Res.Images.Profile.logoutButton ?? UIImage(),
            target: ProfileViewController.self,
            action: #selector(Self.didTapButton)
        )
        logoutButton.tintColor = Res.Colors.buttonColor
        return logoutButton
    } ()
    
    private func addViews() {
        [avatarTemp,
         profileName,
         profileTag,
         profileInfo,
         logoutButton].map{self.view.setupView($0)}
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            avatarTemp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarTemp.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarTemp.heightAnchor.constraint(equalToConstant: 70),
            avatarTemp.widthAnchor.constraint(equalToConstant: 70),
            
            profileName.topAnchor.constraint(equalTo: avatarTemp.bottomAnchor, constant: 8),
            profileName.leadingAnchor.constraint(equalTo: avatarTemp.leadingAnchor),
            profileName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            
            profileTag.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 8),
            profileTag.leadingAnchor.constraint(equalTo: profileName.leadingAnchor),
            profileTag.trailingAnchor.constraint(equalTo: profileName.trailingAnchor),
            
            profileInfo.topAnchor.constraint(equalTo: profileTag.bottomAnchor, constant: 8),
            profileInfo.leadingAnchor.constraint(equalTo: profileName.leadingAnchor),
            profileInfo.trailingAnchor.constraint(equalTo: profileName.trailingAnchor),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: avatarTemp.centerYAnchor),
        ])
    }
    
    @objc private func didTapButton(){
        
    }
    
    override func viewDidLoad() {
        view.backgroundColor = Res.Colors.backgroundColor
        addViews()
        applyConstraints()
    }
}
