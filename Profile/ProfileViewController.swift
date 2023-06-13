import UIKit

final class ProfileViewController: UIViewController {
    
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var desriptionLabel: UILabel?
    private var profileImage: UIImage?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Profile image
        let profileImage = UIImage(named: "userpick")
        let imageView = UIImageView(image: profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        self.profileImage = profileImage
        
        //Name
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        self.nameLabel = nameLabel
        
        //Login Name
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = .gray
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        self.loginNameLabel = loginNameLabel
        
        //Description
        let desriptionLabel = UILabel()
        desriptionLabel.text = "Hello World!"
        desriptionLabel.textColor = .white
        desriptionLabel.font = UIFont.systemFont(ofSize: 13)
        desriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(desriptionLabel)
        desriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor).isActive = true
        desriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        self.desriptionLabel = desriptionLabel
        
        //Logout Button
        let logoutButton = UIButton.systemButton(with: UIImage(named:"ipad.and.arrow.forward")!, target: self, action: #selector(self.didTapButton))
        logoutButton.tintColor = .red
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    @objc
    private func didTapButton() {}
    
}
