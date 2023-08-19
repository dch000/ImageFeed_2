import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    
    func testSgowAlertLogOut() {
        //given
        let profileViewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        //when
        presenter.showAlert(vc: profileViewController)
        //then
        XCTAssertTrue(presenter.showAlertCheck)
    }
    
    func testLogOut() {
        //given
        let presenter = ProfilePresenter()
        let presenterSpy = ProfilePresenterSpy()
        let viewController = ProfileViewController()
        viewController.configure(presenter)
        //when
        presenter.logOut()
        presenterSpy.logOut()
        //then
        XCTAssertEqual(OAuth2TokenStorage.token, nil)
        XCTAssertTrue(presenterSpy.logOutCheck)
    }
    
    func testUpdateAvatar() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        //when
        viewController.updateAvatar()
        //then
        XCTAssertTrue(presenter.getAvatarURLCheck)
    }
    
    func testUpdateDetails() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        //when
        presenter.updateProfileDetails()
        //then
        XCTAssertTrue(presenter.updateProfileCheck)
    }
    
    func testChangeWindowAfterLogOut() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        //when
        presenter.logOut()
        
        guard let windows = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        //then
        XCTAssertTrue(windows.rootViewController?.isKind(of: SplashViewController.self) == true)
        
    }
    
    
}
