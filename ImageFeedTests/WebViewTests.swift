
@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) // behavior verification
    }
    
    func testPresenterCallsLoadRequest() {
        //given
        let viewController = WebViewViewControllerSpy()
        let autHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: autHelper)
        viewController.presenter = presenter
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssert(viewController.loadRequestCalled)
        
    }
    
}
