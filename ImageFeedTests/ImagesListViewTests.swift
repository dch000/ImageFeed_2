@testable import ImageFeed
import XCTest

final class ImagesListViewTests: XCTestCase {
    
    func testGetDateForCell() {
        //given
        let presenter = ImagesListPresenter()
        let viewController = ImagesListViewController()
        viewController.configure(presenter)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        guard let dateCell = formatter.date(from: "2023/07/28 11:11") else { return }
        //when
        let date = presenter.timeSetup(dateCell)
        //then
        XCTAssertEqual(date, "July 28, 2023")
    }
    
    func testViewControllerDidViewLoad() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        //when
        _ = viewController.view
        //then
        XCTAssertTrue(presenter.viewDidLoadCheck)
    }
    
    func testIsLiked() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        //when
        presenter.isLiked(indexPath: IndexPath())
        //then
        XCTAssertTrue(presenter.isLiked(indexPath: IndexPath()))
    }
    
    
}


