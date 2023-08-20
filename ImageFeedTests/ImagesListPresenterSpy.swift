import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImageFeed.ImagesListViewViewControllerProtocol?
    var viewDidLoadCheck: Bool = true
    var photos: [ImageFeed.Photo] = []
    
    func timeSetup(_ date: Date) -> String {
        return ""
    }
    
    func getCellURL(indexPath: IndexPath) -> (thumbUrl: URL, largeUrl: URL)? {
        return nil
    }
    
    func getDateCell(indexPath: IndexPath) -> Date? {
        return nil
    }
    
    func isLiked(indexPath: IndexPath) -> Bool {
        return true
    }
    
    func imageListCellDidTapLike(_ cell: ImageFeed.ImagesListCell, indexPath: IndexPath) {
        return
    }
    
    func viewDidLoad() {
        viewDidLoadCheck = true
    }
    
    func updateViewTable() {
        
    }
    
    func fetchPhotosNextPage() {
        
    }
    
    
}
