import UIKit

enum Res {
    enum Colors {
        static let backgroundColor = UIColor(hexString: "#1A1B22")
        static let tagColor = UIColor(hexString: "#AEAFB4")
        static let buttonColor = UIColor(hexString: "#F56B6C")
    }
    
    enum Images {
        enum Profile {
            static let defaultAvatar = UIImage(named: "default_avatar")
            static let tempAvatar = UIImage(named: "avatar")
            static let logoutButton = UIImage(named: "logout_button")
        }
    }
    
    enum TabBar {
        static let imageList = UIImage(named: "tab_editorial_active")
        static let profile = UIImage(named: "tab_profile_active")
    }
}
