import UIKit

public protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    func updateViewTable()
    func timeSetup(_ date: Date) -> String
    func getCellURL(indexPath: IndexPath) -> (thumbUrl: URL, largeUrl: URL)?
    func getDateCell(indexPath: IndexPath) -> Date?
    func isLiked(indexPath: IndexPath) -> Bool
    func imageListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath)
    func viewDidLoad()
    func fetchPhotosNextPage()
    
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewViewControllerProtocol?
    private var imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    func updateViewTable() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
    func timeSetup(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }
    
    func getCellURL(indexPath: IndexPath) -> (thumbUrl: URL, largeUrl: URL)? {
        guard let imageCellThumbURL = imagesListService.photos[indexPath.row].thumbImageURL,
              let imageCellLargeURL = imagesListService.photos[indexPath.row].largeImageURL,
              let thumbUrl = URL(string: imageCellThumbURL),
              let largeUrl = URL(string: imageCellLargeURL)
        else { return nil }
        return (thumbUrl, largeUrl)
    }
    
    func getDateCell(indexPath: IndexPath) -> Date? {
        return imagesListService.photos[indexPath.row].createdAt
    }
    
    func isLiked(indexPath: IndexPath) -> Bool {
        return imagesListService.photos[indexPath.row].isLiked == false
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id , isLike: photo.isLiked ) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success:
                    self?.photos = self?.imagesListService.photos ?? []
                    cell.setIsLiked(isLiked: self?.photos[indexPath.row].isLiked ?? true)
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
        imagesListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification,
                                                                           object: nil,
                                                                           queue: .main
        ) { [ weak self] _ in
            guard let self = self else { return }
            self.updateViewTable()
        }
    }
}
