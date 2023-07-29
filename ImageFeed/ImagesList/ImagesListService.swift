import UIKit

final class ImagesListService {
    
    static let shared = ImagesListService()
    private (set) var phoros: [Photo] = []
    private var lastLoadedPage: Int?
    
    func fetchPhotosNextPage() {
        
    }
    
}
